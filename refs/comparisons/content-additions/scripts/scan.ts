import { unzipSync } from "fflate";
import { readdirSync, readFileSync, writeFileSync } from "node:fs";
import { join } from "node:path";

const dir = process.argv[2];
const outFile = process.argv[3];

type Handler = { ann: string; methods: string[]; ats?: string[] };
type MixinInfo = { cls: string; targets: string[]; handlers: Handler[] };
type DepInfo = { modId: string; mandatory: string; versionRange: string; side: string };
type JarInfo = {
  file: string;
  mods: { id: string; version: string }[];
  deps: Record<string, DepInfo[]>;
  jarjar: string[];
  mixins: MixinInfo[];
  nested: JarInfo[];
};

const dec = new TextDecoder("utf-8");

function parseClass(buf: Uint8Array) {
  const dv = new DataView(buf.buffer, buf.byteOffset, buf.byteLength);
  let p = 8;
  const n = dv.getUint16(p); p += 2;
  const utf: Record<number, string> = {};
  const cls: Record<number, number> = {};
  const str: Record<number, number> = {};
  for (let i = 1; i < n; i++) {
    const tag = buf[p++];
    switch (tag) {
      case 1: { const l = dv.getUint16(p); p += 2; utf[i] = dec.decode(buf.subarray(p, p + l)); p += l; break; }
      case 3: case 4: p += 4; break;
      case 5: case 6: p += 8; i++; break;
      case 7: cls[i] = dv.getUint16(p); p += 2; break;
      case 8: str[i] = dv.getUint16(p); p += 2; break;
      case 9: case 10: case 11: case 12: case 17: case 18: p += 4; break;
      case 15: p += 3; break;
      case 16: case 19: case 20: p += 2; break;
      default: throw new Error("bad tag " + tag);
    }
  }
  p += 6;
  const ic = dv.getUint16(p); p += 2 + ic * 2;

  function elem(): any {
    const tag = String.fromCharCode(buf[p++]);
    switch (tag) {
      case "s": { const v = utf[dv.getUint16(p)]; p += 2; return v; }
      case "c": { const v = utf[dv.getUint16(p)]; p += 2; return v; }
      case "e": { p += 2; const v = utf[dv.getUint16(p)]; p += 2; return v; }
      case "@": return ann();
      case "[": { const c = dv.getUint16(p); p += 2; const a: any[] = []; for (let i = 0; i < c; i++) a.push(elem()); return a; }
      default: p += 2; return null;
    }
  }
  function ann(): { type: string; vals: Record<string, any> } {
    const type = utf[dv.getUint16(p)]; p += 2;
    const c = dv.getUint16(p); p += 2;
    const vals: Record<string, any> = {};
    for (let i = 0; i < c; i++) {
      const name = utf[dv.getUint16(p)]; p += 2;
      vals[name] = elem();
    }
    return { type, vals };
  }
  function attrs(): { type: string; vals: Record<string, any> }[] {
    const out: { type: string; vals: Record<string, any> }[] = [];
    const ac = dv.getUint16(p); p += 2;
    for (let i = 0; i < ac; i++) {
      const name = utf[dv.getUint16(p)]; p += 2;
      const len = dv.getUint32(p); p += 4;
      const end = p + len;
      if (name === "RuntimeInvisibleAnnotations" || name === "RuntimeVisibleAnnotations") {
        const c = dv.getUint16(p); p += 2;
        for (let k = 0; k < c; k++) out.push(ann());
      }
      p = end;
    }
    return out;
  }
  const fc = dv.getUint16(p); p += 2;
  for (let i = 0; i < fc; i++) { p += 6; attrs(); }
  const mc = dv.getUint16(p); p += 2;
  const methods: { name: string; anns: { type: string; vals: Record<string, any> }[] }[] = [];
  for (let i = 0; i < mc; i++) {
    const name = utf[dv.getUint16(p + 2)];
    p += 6;
    methods.push({ name, anns: attrs() });
  }
  const classAnns = attrs();
  return { methods, classAnns };
}

function descToName(d: string) {
  let s = d;
  if (s.startsWith("L") && s.endsWith(";")) s = s.slice(1, -1);
  return s.replace(/\//g, ".");
}

function parseModsToml(t: string) {
  const mods: { id: string; version: string }[] = [];
  const deps: Record<string, DepInfo[]> = {};
  const blocks = t.split(/^\s*\[\[/m).slice(1);
  for (const b of blocks) {
    const head = b.slice(0, b.indexOf("]]"));
    const body = b.slice(b.indexOf("]]") + 2);
    const kv = (k: string) => {
      const m = body.match(new RegExp("^\\s*" + k + "\\s*=\\s*(?:\"([^\"]*)\"|'([^']*)'|([^\\s#]+))", "m"));
      return m ? (m[1] ?? m[2] ?? m[3] ?? "") : "";
    };
    if (head === "mods") mods.push({ id: kv("modId"), version: kv("version") });
    else if (head.startsWith("dependencies.")) {
      const owner = head.slice("dependencies.".length).replace(/"/g, "");
      (deps[owner] ??= []).push({ modId: kv("modId"), mandatory: kv("mandatory") || kv("type"), versionRange: kv("versionRange"), side: kv("side") });
    }
  }
  return { mods, deps };
}

function scanJar(name: string, data: Uint8Array, depth: number): JarInfo {
  const files = unzipSync(data, { filter: (f) => f.name.endsWith(".class") || f.name.endsWith(".json") || f.name.endsWith(".toml") || f.name.endsWith(".MF") || (f.name.startsWith("META-INF/jarjar/") && f.name.endsWith(".jar")) });
  const info: JarInfo = { file: name, mods: [], deps: {}, jarjar: [], mixins: [], nested: [] };
  const toml = files["META-INF/mods.toml"];
  let tomlText = "";
  if (toml) {
    tomlText = dec.decode(toml);
    const r = parseModsToml(tomlText);
    info.mods = r.mods;
    info.deps = r.deps;
  }
  const cfgs = new Set<string>();
  for (const m of tomlText.matchAll(/\[\[mixins\]\][^\[]*?config\s*=\s*"([^"]+)"/g)) cfgs.add(m[1]);
  const mf = files["META-INF/MANIFEST.MF"];
  if (mf) {
    const t = dec.decode(mf).replace(/\r?\n /g, "");
    const m = t.match(/^MixinConfigs:\s*(.+)$/m);
    if (m) m[1].split(",").forEach((x) => cfgs.add(x.trim()));
  }
  for (const c of cfgs) {
    const raw = files[c];
    if (!raw) continue;
    let j: any;
    try { j = JSON.parse(dec.decode(raw).replace(/^\uFEFF/, "").replace(/\/\*[\s\S]*?\*\//g, "").replace(/^\s*\/\/.*$/gm, "")); } catch { continue; }
    const pkg = (j.package ?? "").replace(/\./g, "/");
    const list: string[] = [...(j.mixins ?? []), ...(j.client ?? []), ...(j.server ?? [])];
    for (const m of list) {
      const path = pkg + "/" + m.replace(/\./g, "/") + ".class";
      const cb = files[path];
      if (!cb) continue;
      let pc;
      try { pc = parseClass(cb); } catch { continue; }
      const mx = pc.classAnns.find((a) => a.type === "Lorg/spongepowered/asm/mixin/Mixin;");
      if (!mx) continue;
      const targets: string[] = [];
      for (const v of mx.vals.value ?? []) targets.push(descToName(v));
      for (const v of mx.vals.targets ?? []) targets.push(String(v).replace(/\//g, "."));
      const handlers: Handler[] = [];
      for (const me of pc.methods) {
        for (const a of me.anns) {
          if (!a.type.startsWith("Lorg/spongepowered/asm/mixin/injection/") && !a.type.startsWith("Lcom/llamalad7/mixinextras/") && a.type !== "Lorg/spongepowered/asm/mixin/Overwrite;") continue;
          const short = a.type.replace(/^L.*\//, "").replace(/;$/, "");
          let ms: string[] = [];
          if (a.vals.method) ms = (a.vals.method as any[]).map((x) => String(x).replace(/\(.*$/, "").replace(/^L.*;/, ""));
          else if (a.type === "Lorg/spongepowered/asm/mixin/Overwrite;") ms = [me.name];
          const atv = a.vals.at;
          const atl: any[] = Array.isArray(atv) ? atv : atv ? [atv] : [];
          const ats = atl.map((x: any) => (x && x.vals ? String(x.vals.target ?? x.vals.value ?? "") : "")).filter(Boolean);
          handlers.push({ ann: short, methods: ms, ats } as any);
        }
      }
      info.mixins.push({ cls: (j.package ?? "") + "." + m, targets, handlers });
    }
  }
  for (const f of Object.keys(files)) {
    if (f.startsWith("META-INF/jarjar/") && f.endsWith(".jar")) {
      info.jarjar.push(f.slice("META-INF/jarjar/".length));
      if (depth < 2) {
        try { info.nested.push(scanJar(f, files[f], depth + 1)); } catch {}
      }
    }
  }
  return info;
}

const out: JarInfo[] = [];
for (const f of readdirSync(dir).filter((x) => x.endsWith(".jar")).sort()) {
  try {
    out.push(scanJar(f, new Uint8Array(readFileSync(join(dir, f))), 0));
  } catch (e) {
    out.push({ file: f, mods: [], deps: {}, jarjar: [], mixins: [], nested: [], error: String(e) } as any);
  }
}
writeFileSync(outFile, JSON.stringify(out));
console.log("scanned", out.length, "jars,", out.reduce((a, j) => a + j.mixins.length, 0), "mixin classes");

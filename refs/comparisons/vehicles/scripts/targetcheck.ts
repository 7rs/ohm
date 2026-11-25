import { unzipSync } from "fflate";
import { readFileSync, readdirSync } from "node:fs";
import { join } from "node:path";

const candFile = process.argv[2];
const jarDirs = process.argv[3].split(",");
const onlyJar = process.argv[4]?.toLowerCase();
const cand: any[] = JSON.parse(readFileSync(candFile, "utf8"));
const dec = new TextDecoder("utf-8");

const wanted = new Set<string>();
const isMc = (t: string) => /^(net\.minecraft\.|com\.mojang\.|net\.minecraftforge\.|java\.|org\.joml|org\.spongepowered|it\.unimi)/.test(t);
function collect(j: any, f: (m: any) => void) {
  j.mixins.forEach(f);
  (j.nested ?? []).forEach((n: any) => collect(n, f));
}
for (const c of cand) {
  if (onlyJar && !c.file.toLowerCase().includes(onlyJar)) continue;
  collect(c, (m) => m.targets.forEach((t: string) => { if (!isMc(t)) wanted.add(t.replace(/\./g, "/")); }));
}

type Cls = { methods: Set<string>; fields: Set<string> };
const world = new Map<string, Cls>();
function parse(buf: Uint8Array): Cls {
  const dv = new DataView(buf.buffer, buf.byteOffset, buf.byteLength);
  let p = 8;
  const n = dv.getUint16(p); p += 2;
  const utf: Record<number, string> = {};
  for (let i = 1; i < n; i++) {
    const tag = buf[p++];
    switch (tag) {
      case 1: { const l = dv.getUint16(p); p += 2; utf[i] = dec.decode(buf.subarray(p, p + l)); p += l; break; }
      case 3: case 4: p += 4; break;
      case 5: case 6: p += 8; i++; break;
      case 7: case 8: case 16: case 19: case 20: p += 2; break;
      case 9: case 10: case 11: case 12: case 17: case 18: p += 4; break;
      case 15: p += 3; break;
      default: throw new Error("bad tag " + tag);
    }
  }
  p += 6;
  const ic = dv.getUint16(p); p += 2 + ic * 2;
  const skipAttrs = () => {
    const ac = dv.getUint16(p); p += 2;
    for (let a = 0; a < ac; a++) { p += 2; const l = dv.getUint32(p); p += 4 + l; }
  };
  const fields = new Set<string>(), methods = new Set<string>();
  const fc = dv.getUint16(p); p += 2;
  for (let i = 0; i < fc; i++) { const name = utf[dv.getUint16(p + 2)]; p += 6; fields.add(name); skipAttrs(); }
  const mc = dv.getUint16(p); p += 2;
  for (let i = 0; i < mc; i++) { const name = utf[dv.getUint16(p + 2)]; p += 6; methods.add(name); skipAttrs(); }
  return { methods, fields };
}
function scanJar(bytes: Uint8Array, depth = 0) {
  const files = unzipSync(bytes, { filter: (f) => f.name.endsWith(".class") || f.name.endsWith(".jar") });
  for (const [name, data] of Object.entries(files)) {
    if (name.endsWith(".jar")) { if (depth < 3) scanJar(data, depth + 1); continue; }
    const cn = name.slice(0, -6);
    if (wanted.has(cn) && !world.has(cn)) { try { world.set(cn, parse(data)); } catch {} }
  }
}
for (const d of jarDirs) {
  for (const f of readdirSync(d)) if (f.endsWith(".jar")) scanJar(new Uint8Array(readFileSync(join(d, f))));
}

const norm = (m: string) => m.replace(/^L[^;]*;/, "").replace(/\(.*$/, "").replace(/^\*$/, "");
for (const c of cand) {
  if (onlyJar && !c.file.toLowerCase().includes(onlyJar)) continue;
  let total = 0, missingClass = new Map<string, string[]>(), missingMethod: string[] = [];
  const seenMissingClass = new Set<string>();
  collect(c, (m) => {
    for (const t of m.targets) {
      if (isMc(t)) continue;
      total++;
      const cn = t.replace(/\./g, "/");
      const cl = world.get(cn);
      if (!cl) {
        if (!seenMissingClass.has(t)) { seenMissingClass.add(t); missingClass.set(t, [m.cls.split(".").pop()]); }
        continue;
      }
      for (const h of m.handlers) for (const me of h.methods) {
        const n = norm(me);
        if (!n || n === "<init>" || n === "<clinit>") continue;
        if (!cl.methods.has(n) && !cl.fields.has(n)) missingMethod.push(`${t.split(".").pop()}#${me} (${h.ann})`);
      }
    }
  });
  console.log(`=== ${c.file}: non-MC mixin targets=${total}, target classes not found=${missingClass.size}, handler methods not found by name=${missingMethod.length}`);
  [...missingClass.keys()].slice(0, 40).forEach((k) => console.log("  NO CLASS " + k));
  missingMethod.slice(0, 40).forEach((k) => console.log("  NO METHOD " + k));
}

import { unzipSync } from "fflate";
import { readdirSync, readFileSync, writeFileSync } from "node:fs";
import { join } from "node:path";

const dir = process.argv[2];
const outFile = process.argv[3];
const needles = ["tacz", "superbwarfare", "simpleenemy", "zombieawareness", "attributefix", "clanginghowl", "touhou_little_maid"];

const dec = new TextDecoder("latin1");
const utf = new TextDecoder("utf-8");

type Row = {
  file: string; sizeMB: number; loaders: string; modIds: string; versions: string; modLoader: string;
  forgeRange: string; mcRange: string; required: string; optional: string; jarjar: string;
  mixinConfigs: number; classCount: number; hits: Record<string, number>; dataTacz: string[];
};

function parseToml(t: string) {
  const mods: { id: string; version: string }[] = [];
  const req: string[] = [];
  const opt: string[] = [];
  let forgeRange = "", mcRange = "";
  const loader = (t.match(/^\s*modLoader\s*=\s*"([^"]+)"/m) ?? [])[1] ?? "";
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
      const id = kv("modId");
      const mand = kv("mandatory") || kv("type");
      const isReq = /^(true|required)$/i.test(mand);
      const range = kv("versionRange");
      if (id === "forge") forgeRange = range;
      else if (id === "minecraft") mcRange = range;
      else (isReq ? req : opt).push(id + (range ? " " + range : ""));
    }
  }
  return { mods, req, opt, forgeRange, mcRange, loader };
}

const rows: Row[] = [];
for (const f of readdirSync(dir).filter((x) => x.endsWith(".jar")).sort()) {
  const raw = new Uint8Array(readFileSync(join(dir, f)));
  const r: Row = { file: f, sizeMB: Math.round((raw.length / 1048576) * 10) / 10, loaders: "", modIds: "", versions: "", modLoader: "", forgeRange: "", mcRange: "", required: "", optional: "", jarjar: "", mixinConfigs: 0, classCount: 0, hits: {}, dataTacz: [] };
  try {
    const files = unzipSync(raw, { filter: (x) => x.name.endsWith(".class") || x.name.endsWith(".json") || x.name.endsWith(".toml") || x.name.endsWith(".MF") || x.name.endsWith(".mcmeta") || (x.name.startsWith("META-INF/jarjar/") && x.name.endsWith(".jar")) });
    const loaders: string[] = [];
    if (files["META-INF/mods.toml"]) loaders.push("forge");
    if (files["META-INF/neoforge.mods.toml"]) loaders.push("neoforge");
    if (files["fabric.mod.json"]) loaders.push("fabric");
    if (files["quilt.mod.json"]) loaders.push("quilt");
    r.loaders = loaders.join("+");
    const t = files["META-INF/mods.toml"];
    if (t) {
      const p = parseToml(utf.decode(t));
      r.modIds = p.mods.map((m) => m.id).join(",");
      r.versions = p.mods.map((m) => m.version).join(",");
      r.modLoader = p.loader;
      r.forgeRange = p.forgeRange;
      r.mcRange = p.mcRange;
      r.required = p.req.join(" ; ");
      r.optional = p.opt.join(" ; ");
    }
    r.jarjar = Object.keys(files).filter((x) => x.startsWith("META-INF/jarjar/")).map((x) => x.slice(16)).join(",");
    for (const n of needles) r.hits[n] = 0;
    for (const [name, data] of Object.entries(files)) {
      if (name.endsWith(".class")) {
        r.classCount++;
        const s = dec.decode(data).toLowerCase();
        for (const n of needles) if (s.includes(n)) r.hits[n]++;
      } else if (name.endsWith(".json") && (name.startsWith("data/") || name.includes("/tags/"))) {
        const s = utf.decode(data).toLowerCase();
        if (s.includes("tacz")) r.dataTacz.push(name);
      }
      if (name.endsWith(".mixins.json") || /mixins?\.json$/.test(name)) r.mixinConfigs++;
    }
  } catch (e) {
    r.loaders = "ERROR " + String(e).slice(0, 60);
  }
  rows.push(r);
}
writeFileSync(outFile, JSON.stringify(rows, null, 1));
const head = ["file", "sizeMB", "loaders", "modIds", "versions", "modLoader", "forgeRange", "mcRange", "required", "optional", "jarjar", "classCount", "tacz", "superbwarfare", "simpleenemy", "zombieawareness", "attributefix", "clanginghowl", "dataTacz"];
const esc = (v: any) => '"' + String(v ?? "").replace(/"/g, "'") + '"';
const csv = [head.join(",")];
for (const r of rows) csv.push([r.file, r.sizeMB, r.loaders, r.modIds, r.versions, r.modLoader, r.forgeRange, r.mcRange, r.required, r.optional, r.jarjar, r.classCount, r.hits.tacz, r.hits.superbwarfare, r.hits.simpleenemy, r.hits.zombieawareness, r.hits.attributefix, r.hits.clanginghowl, r.dataTacz.length].map(esc).join(","));
writeFileSync(outFile.replace(/\.json$/, ".csv"), csv.join("\n"), "utf8");
console.log("analyzed", rows.length);

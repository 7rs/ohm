import { unzipSync } from "fflate";
import { readFileSync, writeFileSync } from "node:fs";

type Jar = { label: string; path: string };
const specs: Jar[] = process.argv.slice(2).map((a) => {
  const i = a.indexOf("=");
  return { label: a.slice(0, i), path: a.slice(i + 1) };
});
const dec = new TextDecoder("utf-8");

const provided = new Map<string, Set<string>>();
const files = new Map<string, Record<string, Uint8Array>>();
for (const j of specs) {
  const z = unzipSync(new Uint8Array(readFileSync(j.path)));
  files.set(j.label, z);
  const set = new Set<string>();
  for (const name of Object.keys(z)) {
    const m = name.match(/^assets\/([^/]+)\/\.?jsondefs\/(?:.+\/)?([^/]+)\.json$/);
    if (m) set.add(`${m[1]}:${m[2]}`);
    const s = name.match(/^assets\/([^/]+)\/sounds\/(.+)\.ogg$/);
    if (s) set.add(`${s[1]}:${s[2]}`);
  }
  provided.set(j.label, set);
}

const ref = /"([a-z0-9_.\-]+):([a-z0-9_.\-]+)(?::[^"\s]*)?"/g;
const out: string[] = [];
for (const j of specs) {
  const z = files.get(j.label)!;
  const own = new Set<string>();
  for (const k of provided.get(j.label)!) own.add(k.split(":")[0]);
  const used = new Map<string, number>();
  for (const [name, data] of Object.entries(z)) {
    if (!/jsondefs\/.*\.json$/.test(name)) continue;
    const txt = dec.decode(data);
    for (const m of txt.matchAll(ref)) {
      let ns = m[1];
      let nm = m[2];
      if (ns === "mts" && nm.includes(".")) {
        const i = nm.indexOf(".");
        ns = nm.slice(0, i);
        nm = nm.slice(i + 1);
      }
      const key = `${ns}:${nm}`;
      if (own.has(ns) || ns === "minecraft" || ns === "tags" || ns.startsWith("terrain_blockname")) continue;
      used.set(key, (used.get(key) ?? 0) + 1);
    }
  }
  out.push(`## ${j.label}`);
  out.push(`own pack ids: ${[...own].sort().join(", ")}`);
  out.push(`distinct external refs: ${used.size}`);
  const byNs = new Map<string, { n: number; resolved: Map<string, number>; unresolved: string[] }>();
  for (const [key, cnt] of used) {
    const ns = key.split(":")[0];
    if (!byNs.has(ns)) byNs.set(ns, { n: 0, resolved: new Map(), unresolved: [] });
    const e = byNs.get(ns)!;
    e.n++;
    let where = "";
    for (const o of specs) {
      if (o.label === j.label) continue;
      if (provided.get(o.label)!.has(key)) { where = o.label; break; }
    }
    if (where) e.resolved.set(where, (e.resolved.get(where) ?? 0) + 1);
    else e.unresolved.push(`${key}(${cnt})`);
  }
  for (const [ns, e] of [...byNs].sort((a, b) => b[1].n - a[1].n)) {
    const res = [...e.resolved].map(([w, c]) => `${w}:${c}`).join(" ");
    out.push(`- ns=${ns} distinct=${e.n} resolved-by[${res}] unresolved=${e.unresolved.length}${e.unresolved.length ? " e.g. " + e.unresolved.slice(0, 12).join(", ") : ""}`);
  }
  out.push("");
}
const text = out.join("\n");
console.log(text);

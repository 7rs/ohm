import { readFileSync } from "node:fs";

const cand: any[] = JSON.parse(readFileSync(process.argv[2], "utf8"));
const inst: any[] = JSON.parse(readFileSync(process.argv[3], "utf8"));

type Entry = { jar: string; target: string; method: string; kind: string; ats: string[]; mixin: string };

function entries(top: any, j: any, out: Entry[]) {
  for (const m of j.mixins) {
    for (const t of m.targets) {
      for (const h of m.handlers) {
        for (const me of h.methods.length ? h.methods : [""]) {
          out.push({ jar: top.file, target: t, method: me, kind: h.ann, ats: h.ats ?? [], mixin: m.cls });
        }
      }
    }
  }
  for (const n of j.nested ?? []) entries(top, n, out);
}

const exclusive = new Set(["Redirect", "ModifyConstant"]);
const instE: Entry[] = [];
for (const j of inst) entries(j, j, instE);
const idx = new Map<string, Entry[]>();
for (const e of instE) {
  const k = e.target + "#" + e.method;
  if (!idx.has(k)) idx.set(k, []);
  idx.get(k)!.push(e);
}
const short = (f: string) => f.replace(/\.jar$/, "").replace(/-?(forge|FORGE|mc1\.20\.1|1\.20\.1).*$/i, "").slice(0, 30);
const norm = (s: string) => s.replace(/^L/, "").replace(/;/, ".").replace(/\s+/g, "");

for (const c of cand) {
  const ce: Entry[] = [];
  entries(c, c, ce);
  const hard = new Set<string>();
  const ow = new Set<string>();
  for (const e of ce) {
    if (!e.method) continue;
    for (const o of idx.get(e.target + "#" + e.method) ?? []) {
      if (o.jar === c.file) continue;
      if (exclusive.has(e.kind) && e.kind === o.kind && e.ats.length && o.ats.length) {
        const same = e.ats.filter((a) => o.ats.some((b) => norm(a) === norm(b)));
        if (same.length) hard.add(`${e.target.split(".").pop()}#${e.method} ${e.kind} on ${same[0]} <-> ${short(o.jar)}`);
      }
      if (e.kind === "Overwrite" || o.kind === "Overwrite") ow.add(`${e.target.split(".").pop()}#${e.method} [${e.kind} vs ${o.kind}] <-> ${short(o.jar)}`);
    }
  }
  console.log("=== " + c.file + "  hard conflicts (same exclusive hook on same call): " + hard.size + "  overwrite pairs: " + ow.size);
  [...hard].forEach((x) => console.log("   HARD " + x));
  [...ow].forEach((x) => console.log("   OVERWRITE " + x));
}

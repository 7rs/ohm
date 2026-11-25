import { readFileSync } from "node:fs";

const cand: any[] = JSON.parse(readFileSync(process.argv[2], "utf8"));
const inst: any[] = JSON.parse(readFileSync(process.argv[3], "utf8"));
const only = process.argv[4]?.toLowerCase();

function collect(j: any, acc: Map<string, Set<string>>) {
  for (const m of j.mixins) for (const t of m.targets) {
    const set = acc.get(t) ?? new Set<string>();
    for (const h of m.handlers) for (const me of h.methods) set.add(h.ann + ":" + me);
    acc.set(t, set);
  }
  for (const n of j.nested ?? []) collect(n, acc);
}
const instIdx = new Map<string, Map<string, Set<string>>>();
for (const j of inst) {
  const acc = new Map<string, Set<string>>();
  collect(j, acc);
  for (const [t, ms] of acc) {
    const e = instIdx.get(t) ?? new Map<string, Set<string>>();
    e.set(j.file, ms);
    instIdx.set(t, e);
  }
}
const short = (f: string) => f.replace(/\.jar$/, "").replace(/-?(forge|FORGE|mc1\.20\.1|1\.20\.1).*$/i, "").slice(0, 26);
for (const c of cand) {
  if (only && !c.file.toLowerCase().includes(only)) continue;
  const acc = new Map<string, Set<string>>();
  collect(c, acc);
  console.log("=== " + c.file + " targets=" + acc.size);
  let shared = 0;
  const rows: string[] = [];
  for (const [t, ms] of acc) {
    const o = instIdx.get(t);
    if (!o) continue;
    const overlapM: string[] = [];
    const by: string[] = [];
    for (const [jf, oms] of o) {
      const same = [...ms].filter((x) => oms.has(x));
      if (same.length) { overlapM.push(...same); by.push(short(jf)); }
    }
    if (overlapM.length) {
      shared++;
      rows.push("  " + t.split(".").pop() + " :: " + [...new Set(overlapM)].slice(0, 4).join(", ") + " <- " + [...new Set(by)].slice(0, 6).join(", "));
    }
  }
  console.log("  classes whose same methods are also hooked by installed mods: " + shared);
  rows.slice(0, 60).forEach((r) => console.log(r));
}

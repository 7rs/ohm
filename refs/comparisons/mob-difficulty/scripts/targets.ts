import { readFileSync } from "node:fs";

const cand: any[] = JSON.parse(readFileSync(process.argv[2], "utf8"));
const inst: any[] = JSON.parse(readFileSync(process.argv[3], "utf8"));

function collect(top: any, j: any, out: Map<string, Set<string>>) {
  for (const m of j.mixins) {
    for (const t of m.targets) {
      if (!out.has(t)) out.set(t, new Set());
      for (const h of m.handlers) for (const me of h.methods) out.get(t)!.add(me.split("(")[0]);
    }
  }
  for (const n of j.nested ?? []) collect(top, n, out);
}

const instIdx = new Map<string, Map<string, Set<string>>>();
for (const j of inst) {
  const mm = new Map<string, Set<string>>();
  collect(j, j, mm);
  for (const [t, ms] of mm) {
    if (!instIdx.has(t)) instIdx.set(t, new Map());
    instIdx.get(t)!.set(j.file, ms);
  }
}
const short = (f: string) => f.replace(/\.jar$/, "").replace(/[-_]?(forge|FORGE|mc1\.20\.1|1\.20\.1).*$/i, "").slice(0, 22);

for (const c of cand) {
  const mm = new Map<string, Set<string>>();
  collect(c, c, mm);
  console.log(`=== ${c.file}  targets: ${mm.size}`);
  for (const [t, ms] of [...mm].sort()) {
    const others = instIdx.get(t);
    const sameMethod: string[] = [];
    if (others) {
      for (const [f, oms] of others) {
        const both = [...ms].filter((x) => oms.has(x));
        if (both.length) sameMethod.push(`${short(f)}[${both.join(",")}]`);
      }
    }
    const cls = t.split(/[./]/).slice(-1)[0];
    console.log(`  ${cls} {${[...ms].join(",")}}${sameMethod.length ? "  SAME-METHOD: " + sameMethod.join(" ") : ""}`);
  }
}

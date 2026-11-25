import { readFileSync } from "node:fs";
const files = process.argv[2].split(",");
const jarFilter = process.argv[3].toLowerCase();
const clsFilter = (process.argv[4] ?? "").toLowerCase();
function walk(x: any, top: string) {
  for (const m of x.mixins) {
    for (const t of m.targets) {
      if (clsFilter && !t.toLowerCase().includes(clsFilter)) continue;
      for (const h of m.handlers) console.log(`${top.slice(0, 28)} | ${t.split(".").pop()} | ${h.ann} ${h.methods.join(",")} @ ${(h.ats ?? []).join(" ; ")}`);
    }
  }
  for (const n of x.nested ?? []) walk(n, top);
}
for (const f of files) {
  const j: any[] = JSON.parse(readFileSync(f, "utf8"));
  for (const x of j) if (x.file.toLowerCase().includes(jarFilter)) walk(x, x.file);
}

import { readFileSync } from "node:fs";

const file = process.argv[2];
const jars: any[] = JSON.parse(readFileSync(file, "utf8"));

function flat(j: any, acc: any[] = []) {
  acc.push(j);
  for (const n of j.nested ?? []) flat(n, acc);
  return acc;
}

for (const j of jars) {
  console.log("=== " + j.file);
  if (j.error) console.log("  ERROR " + j.error);
  console.log("  mods: " + j.mods.map((m: any) => m.id + "@" + m.version).join(", "));
  for (const [owner, ds] of Object.entries<any[]>(j.deps)) {
    const rows = ds.filter((d) => !["forge", "minecraft"].includes(d.modId));
    if (rows.length === 0) continue;
    console.log("  deps[" + owner + "]: " + rows.map((d) => `${d.modId}${d.mandatory ? "(" + d.mandatory + ")" : ""} ${d.versionRange}${d.side && d.side !== "BOTH" ? " side=" + d.side : ""}`).join(" ; "));
  }
  const fm = Object.values<any[]>(j.deps).flat().filter((d) => d.modId === "forge" || d.modId === "minecraft");
  console.log("  platform: " + fm.map((d) => d.modId + " " + d.versionRange).join(" ; "));
  if (j.jarjar.length) console.log("  jarjar: " + j.jarjar.join(", "));
  const all = flat(j);
  const tc = all.reduce((a, x) => a + x.mixins.length, 0);
  console.log("  mixin classes (incl. nested): " + tc);
}

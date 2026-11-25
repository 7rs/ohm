import { unzipSync } from "fflate";
import { readFileSync } from "node:fs";

const jar = process.argv[2];
const needles = process.argv[3].split(",");
const pathRe = process.argv[4] ? new RegExp(process.argv[4], "i") : null;
const files = unzipSync(new Uint8Array(readFileSync(jar)));
const dec = new TextDecoder("latin1");
const hits: Record<string, Set<string>> = {};
for (const [name, data] of Object.entries(files)) {
  if (name.endsWith(".jar")) continue;
  if (!/\.(class|json|toml|mcmeta|cfg|properties)$/.test(name)) continue;
  const s = dec.decode(data).toLowerCase();
  for (const n of needles) {
    if (s.includes(n.toLowerCase())) {
      (hits[n] ??= new Set()).add(name);
    }
  }
}
for (const n of needles) {
  const set = hits[n];
  console.log("## " + n + " -> " + (set ? set.size : 0));
  if (set) [...set].slice(0, 12).forEach((x) => console.log("   " + x));
}
if (pathRe) {
  console.log("## paths matching " + process.argv[4]);
  Object.keys(files).filter((n) => pathRe.test(n)).slice(0, 60).forEach((n) => console.log("   " + n));
}

import { unzipSync } from "fflate";
import { readFileSync, readdirSync } from "node:fs";
import { join } from "node:path";

const dir = process.argv[2];
const pat = process.argv[3].toLowerCase();
const re = new RegExp(process.argv[4] ?? ".", "i");
const show = process.argv[5] ?? "";
const dec = new TextDecoder("utf-8");
for (const f of readdirSync(dir).filter((x) => x.endsWith(".jar") && x.toLowerCase().includes(pat))) {
  const files = unzipSync(new Uint8Array(readFileSync(join(dir, f))), { filter: (x) => !x.name.endsWith(".png") && !x.name.endsWith(".ogg") && !x.name.endsWith(".class") });
  console.log("=== " + f);
  const names = Object.keys(files).filter((n) => re.test(n));
  console.log(names.length + " entries match");
  for (const n of names.slice(0, 120)) console.log("  " + n);
  if (show) for (const n of Object.keys(files).filter((x) => x.includes(show))) { console.log("--- " + n); console.log(dec.decode(files[n]).slice(0, 3000)); }
}

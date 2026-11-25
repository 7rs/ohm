import { unzipSync } from "fflate";
import { readFileSync } from "node:fs";

const jar = process.argv[2];
const files = unzipSync(new Uint8Array(readFileSync(jar)));
const dec = new TextDecoder();
const names = Object.keys(files);
const toml = files["META-INF/mods.toml"];
console.log("# " + jar + " entries=" + names.length);
if (toml) {
  const t = dec.decode(toml).split("\n").filter((l) => !l.trim().startsWith("#") && l.trim() !== "");
  console.log(t.slice(0, 80).join("\n"));
} else console.log("no mods.toml");
const nested = names.filter((n) => n.endsWith(".jar"));
console.log("nested jars: " + nested.join(" | "));
const top: Record<string, number> = {};
for (const n of names) {
  const p = n.split("/").slice(0, 3).join("/");
  top[p] = (top[p] ?? 0) + 1;
}
const topK = Object.entries(top).sort((a, b) => b[1] - a[1]).slice(0, 25);
console.log("top paths: " + topK.map(([k, v]) => k + "=" + v).join(" ; "));

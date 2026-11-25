import { unzipSync } from "fflate";
import { readFileSync } from "node:fs";

const dec = new TextDecoder("utf-8");
for (const a of process.argv.slice(2)) {
  const i = a.indexOf("=");
  const label = a.slice(0, i);
  const z = unzipSync(new Uint8Array(readFileSync(a.slice(i + 1))));
  let total = 0;
  let withRecipe = 0;
  let noGeneral = 0;
  const empty: string[] = [];
  const costs: number[] = [];
  for (const [name, data] of Object.entries(z)) {
    if (!/jsondefs\/vehicles\/.*\.json$/.test(name)) continue;
    total++;
    const txt = dec.decode(data);
    const g = txt.lastIndexOf('"general"');
    const seg = g >= 0 ? txt.slice(g) : "";
    if (!seg) noGeneral++;
    const ml = seg.match(/"materialLists"\s*:\s*\[\s*\[([\s\S]*?)\]\s*\]/);
    const items = ml ? [...ml[1].matchAll(/"([^"]+)"/g)].map((m) => m[1]) : [];
    if (items.length > 0) {
      withRecipe++;
      let c = 0;
      for (const it of items) {
        const n = Number(it.split(":").pop());
        if (Number.isFinite(n)) c += n;
      }
      costs.push(c);
    } else if (empty.length < 6) empty.push(name.split("/").pop()!);
  }
  costs.sort((x, y) => x - y);
  const med = costs.length ? costs[Math.floor(costs.length / 2)] : 0;
  console.log(`${label}: vehicle jsons=${total} with non-empty first materialList=${withRecipe} (no general block=${noGeneral}) median total item count=${med}; e.g. no recipe: ${empty.join(", ")}`);
}

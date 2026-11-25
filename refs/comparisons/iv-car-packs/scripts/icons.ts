import { unzipSync } from "fflate";
import { readFileSync } from "node:fs";

const dec = new TextDecoder("utf-8");
for (const a of process.argv.slice(2)) {
  const i = a.indexOf("=");
  const label = a.slice(0, i);
  const z = unzipSync(new Uint8Array(readFileSync(a.slice(i + 1))));
  const names = new Set(Object.keys(z));
  let models = 0;
  let refs = 0;
  let missing = 0;
  const sample: string[] = [];
  const dirs = new Map<string, number>();
  for (const [name, data] of Object.entries(z)) {
    if (!/^assets\/[^/]+\/models\/.*\.json$/.test(name)) continue;
    models++;
    let j: any;
    try {
      j = JSON.parse(dec.decode(data));
    } catch {
      continue;
    }
    const tex = j.textures ?? {};
    for (const v of Object.values(tex)) {
      if (typeof v !== "string") continue;
      refs++;
      const m = v.includes(":") ? v.split(":") : ["minecraft", v];
      if (m[0] === "minecraft") continue;
      const p = `assets/${m[0]}/textures/${m[1]}.png`;
      const d = m[1].split("/")[0];
      dirs.set(d, (dirs.get(d) ?? 0) + 1);
      if (!names.has(p)) {
        missing++;
        if (sample.length < 3) sample.push(`${name} -> ${p}`);
      }
    }
  }
  console.log(`${label}: model jsons=${models} texture refs=${refs} missing=${missing} dirs=${[...dirs].map(([k, v]) => `${k}:${v}`).join(",")}`);
  for (const s of sample) console.log("   e.g. " + s);
}

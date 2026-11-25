import { unzipSync } from "fflate";
import { readFileSync, readdirSync } from "node:fs";
import { join } from "node:path";

const dir = process.argv[2];
const pat = (process.argv[3] ?? "").toLowerCase();
const filter = process.argv[4] ? new RegExp(process.argv[4], "i") : null;
const max = Number(process.argv[5] ?? "400");
const dec = new TextDecoder("utf-8");

for (const f of readdirSync(dir).filter((x) => x.endsWith(".jar") && x.toLowerCase().includes(pat))) {
  const files = unzipSync(new Uint8Array(readFileSync(join(dir, f))), { filter: (x) => /\/lang\/en_us\.json$/i.test(x.name) });
  console.log("=== " + f);
  let n = 0;
  for (const [name, data] of Object.entries(files)) {
    let j: Record<string, string>;
    try { j = JSON.parse(dec.decode(data).replace(/^﻿/, "")); } catch { continue; }
    console.log("-- " + name + " keys=" + Object.keys(j).length);
    for (const [k, v] of Object.entries(j)) {
      if (filter && !filter.test(k + " " + v)) continue;
      if (n++ >= max) break;
      console.log(k + " = " + String(v).replace(/\s+/g, " ").slice(0, 220));
    }
  }
}

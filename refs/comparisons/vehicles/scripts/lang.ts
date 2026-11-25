import { unzipSync } from "fflate";
import { readFileSync } from "node:fs";

const jar = process.argv[2];
const prefixes = (process.argv[3] ?? "entity,item,block").split(",");
const files = unzipSync(new Uint8Array(readFileSync(jar)), { filter: (f) => /assets\/[^/]+\/lang\/en_us\.json$/.test(f.name) });
const dec = new TextDecoder();
for (const [name, data] of Object.entries(files)) {
  const j = JSON.parse(dec.decode(data).replace(/^﻿/, ""));
  console.log("# " + name + " keys=" + Object.keys(j).length);
  for (const pre of prefixes) {
    const ks = Object.keys(j).filter((k) => k.startsWith(pre + ".") && k.split(".").length === 3);
    console.log("## " + pre + " (" + ks.length + ")");
    console.log(ks.map((k) => j[k]).join(" | "));
  }
}

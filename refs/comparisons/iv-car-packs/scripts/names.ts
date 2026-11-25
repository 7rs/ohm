import { unzipSync } from "fflate";
import { readFileSync, writeFileSync } from "node:fs";

const dec = new TextDecoder("utf-8");
const outDir = process.argv[2];
for (const a of process.argv.slice(3)) {
  const i = a.indexOf("=");
  const label = a.slice(0, i);
  const z = unzipSync(new Uint8Array(readFileSync(a.slice(i + 1))));
  const rows: string[] = [];
  for (const [name, data] of Object.entries(z)) {
    const m = name.match(/^assets\/([^/]+)\/\.?jsondefs\/vehicles\/(.+)\.json$/);
    if (!m) continue;
    const txt = dec.decode(data);
    const d = txt.indexOf('"definitions"');
    let vname = "";
    let variants = 0;
    if (d >= 0) {
      const tail = txt.slice(d);
      const nm = tail.match(/"name"\s*:\s*"([^"]*)"/);
      vname = nm ? nm[1] : "";
      const end = tail.indexOf("]\n", 20);
      const block = end > 0 ? tail.slice(0, end) : tail.slice(0, 20000);
      variants = (block.match(/"subName"/g) ?? []).length;
    }
    const type = (txt.match(/"type"\s*:\s*"([^"]*)"/) ?? [])[1] ?? "";
    rows.push(`${m[1]}\t${m[2]}\t${vname}\t${variants}\t${type}`);
  }
  rows.sort();
  writeFileSync(`${outDir}/names-${label}.tsv`, "pack\tfile\tname\tvariants\ttype\n" + rows.join("\n") + "\n");
  console.log(`${label}: ${rows.length}`);
}

import { unzipSync } from "fflate";
import { readFileSync, readdirSync } from "node:fs";
import { join } from "node:path";

const dir = process.argv[2];
const pat = process.argv[3].toLowerCase();
const clsRe = new RegExp(process.argv[4] ?? "config", "i");
const strRe = new RegExp(process.argv[5] ?? "^.{12,}$", "i");
const max = Number(process.argv[6] ?? "120");
const dec = new TextDecoder("utf-8");

function cpStrings(buf: Uint8Array): string[] {
  const dv = new DataView(buf.buffer, buf.byteOffset, buf.byteLength);
  let p = 8;
  const n = dv.getUint16(p); p += 2;
  const out: string[] = [];
  for (let i = 1; i < n; i++) {
    const tag = buf[p++];
    switch (tag) {
      case 1: { const l = dv.getUint16(p); p += 2; out.push(dec.decode(buf.subarray(p, p + l))); p += l; break; }
      case 3: case 4: p += 4; break;
      case 5: case 6: p += 8; i++; break;
      case 7: case 8: case 16: case 19: case 20: p += 2; break;
      case 9: case 10: case 11: case 12: case 17: case 18: p += 4; break;
      case 15: p += 3; break;
      default: return out;
    }
  }
  return out;
}

for (const f of readdirSync(dir).filter((x) => x.endsWith(".jar") && x.toLowerCase().includes(pat))) {
  const files = unzipSync(new Uint8Array(readFileSync(join(dir, f))), { filter: (x) => x.name.endsWith(".class") && clsRe.test(x.name) });
  console.log("=== " + f + " (" + Object.keys(files).length + " classes match)");
  let n = 0;
  const seen = new Set<string>();
  for (const [name, data] of Object.entries(files)) {
    let ss: string[] = [];
    try { ss = cpStrings(data); } catch { continue; }
    for (const s of ss) {
      if (!strRe.test(s) || seen.has(s)) continue;
      seen.add(s);
      if (n++ >= max) break;
      console.log("[" + name.split("/").pop() + "] " + s.replace(/\s+/g, " ").slice(0, 240));
    }
  }
}

import { unzipSync } from "fflate";
import { readFileSync } from "node:fs";

const jar = process.argv[2];
const classes = process.argv[3].split(",");
const files = unzipSync(new Uint8Array(readFileSync(jar)));
const dec = new TextDecoder("utf-8");

function utf8s(buf: Uint8Array): string[] {
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
      default: throw new Error("bad tag " + tag);
    }
  }
  return out;
}
for (const c of classes) {
  const e = files[c];
  if (!e) { console.log("missing " + c); continue; }
  console.log("### " + c);
  const s = utf8s(e).filter((x) => x.length > 2 && !/^\(|^L.*;$|^<|^[A-Z][A-Za-z]*$/.test(x));
  console.log(s.join(" | "));
}

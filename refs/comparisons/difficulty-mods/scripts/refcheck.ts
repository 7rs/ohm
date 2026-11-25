import { unzipSync } from "fflate";
import { readFileSync } from "node:fs";

const candPath = process.argv[2];
const taczPath = process.argv[3];
const prefix = process.argv[4] ?? "com/tacz/";
const dec = new TextDecoder("utf-8");

function cpClassNames(buf: Uint8Array): string[] {
  const dv = new DataView(buf.buffer, buf.byteOffset, buf.byteLength);
  let p = 8;
  const n = dv.getUint16(p); p += 2;
  const utf: Record<number, string> = {};
  const cls: number[] = [];
  for (let i = 1; i < n; i++) {
    const tag = buf[p++];
    switch (tag) {
      case 1: { const l = dv.getUint16(p); p += 2; utf[i] = dec.decode(buf.subarray(p, p + l)); p += l; break; }
      case 3: case 4: p += 4; break;
      case 5: case 6: p += 8; i++; break;
      case 7: cls.push(dv.getUint16(p)); p += 2; break;
      case 8: case 16: case 19: case 20: p += 2; break;
      case 9: case 10: case 11: case 12: case 17: case 18: p += 4; break;
      case 15: p += 3; break;
      default: return [];
    }
  }
  return cls.map((c) => utf[c]).filter(Boolean);
}

const cand = unzipSync(new Uint8Array(readFileSync(candPath)), { filter: (x) => x.name.endsWith(".class") });
const tacz = unzipSync(new Uint8Array(readFileSync(taczPath)), { filter: (x) => x.name.endsWith(".class") });
const refs = new Set<string>();
for (const d of Object.values(cand)) for (const c of cpClassNames(d)) { const b = c.replace(/^\[+L?/, "").replace(/;$/, ""); if (b.startsWith(prefix)) refs.add(b); }
let ok = 0;
const missing: string[] = [];
for (const r of refs) { if (tacz[r + ".class"]) ok++; else missing.push(r); }
console.log(candPath.split(/[\\/]/).pop() + " vs " + taczPath.split(/[\\/]/).pop() + ": refs=" + refs.size + " resolved=" + ok + " missing=" + missing.length);
missing.slice(0, 15).forEach((m) => console.log("  MISSING " + m));

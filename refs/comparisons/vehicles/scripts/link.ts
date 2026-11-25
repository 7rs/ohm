import { unzipSync } from "fflate";
import { readFileSync } from "node:fs";

const addonPath = process.argv[2];
const prefixes = process.argv[3].split(",");
const targets = process.argv.slice(4);
const dec = new TextDecoder();

type Cls = { name: string; sup: string; ifs: string[]; fields: Set<string>; methods: Set<string> };
type Refs = { classes: Set<string>; members: { cls: string; name: string; desc: string; kind: string }[] };

function parseClass(buf: Uint8Array): { cls: Cls; refs: Refs } {
  const dv = new DataView(buf.buffer, buf.byteOffset, buf.byteLength);
  let p = 8;
  const n = dv.getUint16(p); p += 2;
  const utf: Record<number, string> = {};
  const cl: Record<number, number> = {};
  const nt: Record<number, [number, number]> = {};
  const mr: { tag: number; c: number; nt: number }[] = [];
  for (let i = 1; i < n; i++) {
    const tag = buf[p++];
    switch (tag) {
      case 1: { const l = dv.getUint16(p); p += 2; utf[i] = dec.decode(buf.subarray(p, p + l)); p += l; break; }
      case 3: case 4: p += 4; break;
      case 5: case 6: p += 8; i++; break;
      case 7: cl[i] = dv.getUint16(p); p += 2; break;
      case 8: p += 2; break;
      case 9: case 10: case 11: mr.push({ tag, c: dv.getUint16(p), nt: dv.getUint16(p + 2) }); p += 4; break;
      case 12: nt[i] = [dv.getUint16(p), dv.getUint16(p + 2)]; p += 4; break;
      case 17: case 18: p += 4; break;
      case 15: p += 3; break;
      case 16: case 19: case 20: p += 2; break;
      default: throw new Error("tag " + tag);
    }
  }
  p += 2;
  const thisC = utf[cl[dv.getUint16(p)]]; p += 2;
  const supI = dv.getUint16(p); p += 2;
  const sup = supI ? utf[cl[supI]] : "";
  const ic = dv.getUint16(p); p += 2;
  const ifs: string[] = [];
  for (let i = 0; i < ic; i++) { ifs.push(utf[cl[dv.getUint16(p)]]); p += 2; }
  const skipAttrs = () => { const ac = dv.getUint16(p); p += 2; for (let i = 0; i < ac; i++) { p += 2; const len = dv.getUint32(p); p += 4 + len; } };
  const fields = new Set<string>();
  const fc = dv.getUint16(p); p += 2;
  for (let i = 0; i < fc; i++) { const name = utf[dv.getUint16(p + 2)]; const d = utf[dv.getUint16(p + 4)]; p += 6; skipAttrs(); fields.add(name + d); }
  const methods = new Set<string>();
  const mc = dv.getUint16(p); p += 2;
  for (let i = 0; i < mc; i++) { const name = utf[dv.getUint16(p + 2)]; const d = utf[dv.getUint16(p + 4)]; p += 6; skipAttrs(); methods.add(name + d); }
  const classes = new Set<string>(Object.values(cl).map((x) => utf[x]));
  const members = mr.map((m) => {
    const [ni, di] = nt[m.nt];
    return { cls: utf[cl[m.c]], name: utf[ni], desc: utf[di], kind: m.tag === 9 ? "field" : "method" };
  });
  return { cls: { name: thisC, sup, ifs, fields, methods }, refs: { classes, members } };
}

function readJarClasses(path: string, into: Map<string, Cls>, depth = 0) {
  const files = unzipSync(new Uint8Array(readFileSync(path)), { filter: (f) => f.name.endsWith(".class") });
  for (const [name, buf] of Object.entries(files)) {
    try { const pc = parseClass(buf); into.set(pc.cls.name, pc.cls); } catch {}
  }
}

const world = new Map<string, Cls>();
for (const t of targets) readJarClasses(t, world);

const addonFiles = unzipSync(new Uint8Array(readFileSync(addonPath)), { filter: (f) => f.name.endsWith(".class") });
const missingClass = new Map<string, Set<string>>();
const missingMember = new Map<string, Set<string>>();
let checked = 0;
function resolve(cls: string, key: string, kind: string, seen = new Set<string>()): boolean | null {
  if (seen.has(cls)) return false;
  seen.add(cls);
  const c = world.get(cls);
  if (!c) return null;
  if ((kind === "field" ? c.fields : c.methods).has(key)) return true;
  let unknown = false;
  for (const parent of [c.sup, ...c.ifs]) {
    if (!parent) continue;
    const r = resolve(parent, key, kind, seen);
    if (r === true) return true;
    if (r === null) unknown = true;
  }
  return unknown ? null : false;
}
for (const [name, buf] of Object.entries(addonFiles)) {
  let pc;
  try { pc = parseClass(buf); } catch { continue; }
  for (const c of pc.refs.classes) {
    if (prefixes.some((p) => c.startsWith(p)) && !world.has(c) && !(addonFiles[c + ".class"])) {
      if (!missingClass.has(c)) missingClass.set(c, new Set());
      missingClass.get(c)!.add(pc.cls.name);
    }
  }
  for (const m of pc.refs.members) {
    if (!prefixes.some((p) => m.cls.startsWith(p))) continue;
    if (addonFiles[m.cls + ".class"]) continue;
    checked++;
    if (!world.has(m.cls)) continue;
    const r = resolve(m.cls, m.name + m.desc, m.kind);
    if (r === false) {
      const k = `${m.cls}.${m.name}${m.desc}`;
      if (!missingMember.has(k)) missingMember.set(k, new Set());
      missingMember.get(k)!.add(pc.cls.name);
    }
  }
}
console.log(`addon classes: ${Object.keys(addonFiles).length}, member refs checked: ${checked}`);
console.log(`missing classes: ${missingClass.size}`);
for (const [c, by] of missingClass) console.log(`  ${c}  (from ${[...by].slice(0, 3).join(", ")})`);
console.log(`missing members: ${missingMember.size}`);
for (const [k, by] of missingMember) console.log(`  ${k}  (from ${[...by].slice(0, 3).join(", ")})`);

import { unzipSync } from "fflate";
import { readFileSync, statSync } from "node:fs";

const dec = new TextDecoder("utf-8");

type Cls = { name: string; sup: string; abstract: boolean; names: Set<string>; strs: string[] };

function parseHeader(buf: Uint8Array): Cls | null {
  const dv = new DataView(buf.buffer, buf.byteOffset, buf.byteLength);
  let p = 8;
  const n = dv.getUint16(p); p += 2;
  const utf: Record<number, string> = {};
  const clsIdx: Record<number, number> = {};
  const strs: string[] = [];
  for (let i = 1; i < n; i++) {
    const tag = buf[p++];
    switch (tag) {
      case 1: { const l = dv.getUint16(p); p += 2; const s = dec.decode(buf.subarray(p, p + l)); utf[i] = s; strs.push(s); p += l; break; }
      case 3: case 4: p += 4; break;
      case 5: case 6: p += 8; i++; break;
      case 7: clsIdx[i] = dv.getUint16(p); p += 2; break;
      case 8: case 16: case 19: case 20: p += 2; break;
      case 9: case 10: case 11: case 12: case 17: case 18: p += 4; break;
      case 15: p += 3; break;
      default: return null;
    }
  }
  const access = dv.getUint16(p); p += 2;
  const thisIdx = dv.getUint16(p); p += 2;
  const supIdx = dv.getUint16(p); p += 2;
  const names = new Set<string>();
  for (const k of Object.values(clsIdx)) if (utf[k]) names.add(utf[k]);
  return { name: utf[clsIdx[thisIdx]] ?? "", sup: supIdx ? utf[clsIdx[supIdx]] ?? "" : "", abstract: (access & 0x0400) !== 0 || (access & 0x0200) !== 0, names, strs };
}

const nonMob = /^net\/minecraft\/world\/entity\/(Entity$|projectile\/|item\/|vehicle\/|decoration\/|AreaEffectCloud|LightningBolt|ExperienceOrb|Marker|FlyingBlock)/;

export function analyse(path: string) {
  const files = unzipSync(new Uint8Array(readFileSync(path)), { filter: (x) => x.name.endsWith(".class") || x.name.endsWith("en_us.json") || x.name.endsWith(".nbt") || /^data\/[^/]+\/(worldgen\/(structure|biome)|dimension|tags\/entity_types)\/.*\.json$/.test(x.name) });
  const classes = new Map<string, Cls>();
  for (const [n, d] of Object.entries(files)) {
    if (!n.endsWith(".class")) continue;
    try { const c = parseHeader(d); if (c) classes.set(c.name, c); } catch {}
  }
  const memo = new Map<string, boolean>();
  const isMob = (name: string, depth = 0): boolean => {
    if (depth > 12) return false;
    if (memo.has(name)) return memo.get(name)!;
    const c = classes.get(name);
    let r = false;
    if (c) {
      const s = c.sup;
      if (s.startsWith("net/minecraft/world/entity/")) r = !nonMob.test(s);
      else r = isMob(s, depth + 1);
    }
    memo.set(name, r);
    return r;
  };
  const bossMemo = new Map<string, boolean>();
  const isBoss = (name: string, depth = 0): boolean => {
    if (depth > 12) return false;
    if (bossMemo.has(name)) return bossMemo.get(name)!;
    const c = classes.get(name);
    let r = false;
    if (c) r = c.names.has("net/minecraft/server/level/ServerBossEvent") || c.sup === "net/minecraft/world/entity/boss/wither/WitherBoss" || c.sup === "net/minecraft/world/entity/boss/enderdragon/EnderDragon" || isBoss(c.sup, depth + 1);
    bossMemo.set(name, r);
    return r;
  };
  const mobs: string[] = [];
  const bosses: string[] = [];
  for (const [name, c] of classes) {
    if (c.abstract || !isMob(name)) continue;
    const simple = name.split("/").pop()!.replace(/\$.*$/, "");
    if (name.includes("$")) continue;
    mobs.push(simple);
    if (isBoss(name)) bosses.push(simple);
  }
  const structs = Object.keys(files).filter((n) => /\/worldgen\/structure\/.*\.json$/.test(n)).length;
  const biomes = Object.keys(files).filter((n) => /\/worldgen\/biome\/.*\.json$/.test(n)).length;
  const dims = Object.keys(files).filter((n) => /\/dimension\/.*\.json$/.test(n)).length;
  const nbt = Object.keys(files).filter((n) => n.endsWith(".nbt")).length;
  let langEntities = 0;
  for (const [n, d] of Object.entries(files)) {
    if (!n.endsWith("en_us.json")) continue;
    try { const j = JSON.parse(dec.decode(d).replace(/^﻿/, "")); for (const k of Object.keys(j)) if (/^entity\.[a-z0-9_]+\.[a-z0-9_]+$/.test(k)) langEntities++; } catch {}
  }
  return { mobs: [...new Set(mobs)], bosses: [...new Set(bosses)], structs, biomes, dims, nbt, langEntities, mb: Math.round((statSync(path).size / 1048576) * 10) / 10 };
}

if (import.meta.main) {
  const list = process.argv.slice(2);
  console.log("file|MB|mob classes|boss classes|entity lang keys|structures json|structure nbt|biomes|dimensions");
  for (const f of list) {
    try {
      const r = analyse(f);
      console.log([f.split(/[\\/]/).pop(), r.mb, r.mobs.length, r.bosses.length, r.langEntities, r.structs, r.nbt, r.biomes, r.dims].join("|"));
      if (process.env.SHOW) console.log("   BOSSES: " + r.bosses.slice(0, 60).join(", "));
    } catch (e) { console.log(f + " ERROR " + String(e).slice(0, 80)); }
  }
}

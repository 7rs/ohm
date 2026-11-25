import { readFileSync, writeFileSync } from "node:fs";

const [candAn, instAn, libAn, candScan, out] = process.argv.slice(2);
const cand: any[] = JSON.parse(readFileSync(candAn, "utf8"));
const inst: any[] = JSON.parse(readFileSync(instAn, "utf8"));
const libs: any[] = libAn && libAn !== "-" ? JSON.parse(readFileSync(libAn, "utf8")) : [];
const scan: any[] = JSON.parse(readFileSync(candScan, "utf8"));

const mixinCount = new Map<string, number>();
function count(j: any): number { return j.mixins.length + (j.nested ?? []).reduce((a: number, n: any) => a + count(n), 0); }
for (const s of scan) mixinCount.set(s.file, count(s));

const instIds = new Set<string>();
for (const j of inst) for (const id of String(j.modIds).split(",")) if (id) instIds.add(id);
const libById = new Map<string, any>();
for (const l of libs) for (const id of String(l.modIds).split(",")) if (id) libById.set(id, l);
const builtin = new Set(["forge", "minecraft", "javafml", "lowcodefml"]);

const esc = (v: any) => '"' + String(v ?? "").replace(/"/g, "'") + '"';
const rows = [["file", "sizeMB", "loaders", "modIds", "modLoader", "forgeRange", "mcRange", "required_not_installed", "required_installed", "lib_status", "optional_installed", "mixin_classes", "tacz_refs", "dataTacz"].join(",")];
for (const c of cand) {
  const reqs = String(c.required).split(" ; ").filter(Boolean).map((x) => x.split(" ")[0]).filter((x) => !builtin.has(x));
  const notInst = reqs.filter((x) => !instIds.has(x));
  const inst2 = reqs.filter((x) => instIds.has(x));
  const libStatus = notInst.map((x) => x + ":" + (libById.has(x) ? "lib " + libById.get(x).file : "NOT DOWNLOADED")).join(" | ");
  const opts = String(c.optional).split(" ; ").filter(Boolean).map((x) => x.split(" ")[0]).filter((x) => instIds.has(x) && !builtin.has(x));
  rows.push([c.file, c.sizeMB, c.loaders, c.modIds, c.modLoader, c.forgeRange, c.mcRange, notInst.join(";"), inst2.join(";"), libStatus, opts.join(";"), mixinCount.get(c.file) ?? 0, c.hits?.tacz ?? "", c.dataTacz?.length ?? ""].map(esc).join(","));
}
writeFileSync(out, rows.join("\n"), "utf8");
console.log("rows", rows.length - 1);

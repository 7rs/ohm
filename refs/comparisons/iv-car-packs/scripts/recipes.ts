import { unzipSync } from "fflate";
import { readFileSync } from "node:fs";

const dec = new TextDecoder("utf-8");
const specs = process.argv.slice(2).map((a) => {
  const i = a.indexOf("=");
  return { label: a.slice(0, i), rest: a.slice(i + 1) };
});
for (const s of specs) {
  const [jar, ...pats] = s.rest.split("|");
  const z = unzipSync(new Uint8Array(readFileSync(jar)));
  for (const p of pats) {
    const re = new RegExp(p);
    for (const [name, data] of Object.entries(z)) {
      if (!/jsondefs\/vehicles\/.*\.json$/.test(name) || !re.test(name)) continue;
      const txt = dec.decode(data);
      const g = txt.lastIndexOf('"general"');
      const seg = g >= 0 ? txt.slice(g) : txt;
      const ml = seg.match(/"materialLists"\s*:\s*\[\s*\[([\s\S]*?)\]\s*\]/);
      const items = ml ? [...ml[1].matchAll(/"([^"]+)"/g)].map((m) => m[1]) : [];
      const tot = new Map<string, number>();
      for (const it of items) {
        const parts = it.split(":");
        const count = Number(parts[parts.length - 1]);
        const key = it.startsWith("mts:") ? parts.slice(0, 2).join(":") : parts.slice(0, 2).join(":");
        tot.set(key, (tot.get(key) ?? 0) + (Number.isFinite(count) ? count : 0));
      }
      const hp = (seg.match(/"health"\s*:\s*(\d+)/) ?? [])[1] ?? "?";
      console.log(`${s.label} ${name.replace(/^assets\//, "")}: ${[...tot].map(([k, v]) => `${k} x${v}`).join(", ")}`);
    }
  }
}

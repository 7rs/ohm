#!/usr/bin/env python3
"""List the keys jtrans 1.9.1 holds for given namespaces (its 1.20.1 pack stores a hash stub, the keys sit in a JTD2 block).

usage: jtrans_keys.py JTRANS_JAR ENCH_TSV OUT.md NAMESPACE [NAMESPACE ...]

Format (read in an earlier comparison, refs/comparisons/japanese-localization): META-INF/jtrans/db/v1/<hash>.bin,
magic 'JTD2', u32 count, then count entries of u32 length + UTF-8 key (quoted, JSON-escaped). Values are not read.
ENCH_TSV is enchant_lang.py's *_enchantments.tsv: every enchantment name key is checked as <key>.desc / <key>.description.
"""
import sys, zipfile, re, struct, csv, json

jar, tsv, out = sys.argv[1:4]
namespaces = sys.argv[4:]
z = zipfile.ZipFile(jar)

def db_keys(ns):
    n = f"resourcepacks/jtrans_1201/assets/{ns}/lang/ja_jp.json"
    try:
        txt = z.read(n).decode("utf-8")
    except KeyError:
        return None
    m = re.search(r'__jtrans_db_v1__"\s*:\s*"([0-9a-f]{64})/([0-9a-f]{64})"', txt)
    if not m:
        try:
            return set(json.loads(txt))
        except Exception:
            return set()
    try:
        b = z.read(f"META-INF/jtrans/db/v1/{m.group(1)}.bin")
    except KeyError:
        return set()
    if b[:4] != b"JTD2":
        return set()
    count = struct.unpack_from(">I", b, 4)[0]
    pos = 8; keys = set()
    for _ in range(count):
        if pos + 4 > len(b): break
        l = struct.unpack_from(">I", b, pos)[0]; pos += 4
        if l < 0 or pos + l > len(b): break
        k = b[pos:pos + l].decode("utf-8", "replace"); pos += l
        if len(k) >= 2 and k[0] == '"' and k[-1] == '"': k = k[1:-1]
        keys.add(k.replace('\\"', '"').replace("\\\\", "\\"))
    return keys

dbs = {ns: db_keys(ns) for ns in namespaces}
rows = list(csv.DictReader(open(tsv), delimiter="\t"))
lines = ["# jtrans 1.9.1 keys for selected namespaces (1.20.1 pack)\n", "| Namespace | In jtrans' 1.20.1 pack | Keys held |", "|---|---|---|"]
for ns in namespaces:
    k = dbs[ns]
    lines.append(f"| {ns} | {'no' if k is None else 'yes'} | {0 if k is None else len(k)} |")
lines += ["", "Enchantment description keys (`<name key>.desc` or `.description`) in the namespace's jtrans block:", "",
          "| Namespace | Enchantments | Desc key in en_us (jar) | Desc key in jtrans | Name key in jtrans |", "|---|---|---|---|---|"]
agg = {}
for r in rows:
    ns = r["namespace"]; base = r["key"]
    d = agg.setdefault(ns, [0, 0, 0, 0])
    d[0] += 1
    if r["desc_en"] != "-": d[1] += 1
    ks = db_keys(ns) if ns not in dbs else dbs[ns]
    dbs[ns] = ks
    if ks and (base + ".desc" in ks or base + ".description" in ks): d[2] += 1
    if ks and base in ks: d[3] += 1
for ns, d in agg.items():
    lines.append(f"| {ns} | {d[0]} | {d[1]} | {d[2]} | {d[3]} |")
# the enchdesc namespace: vanilla description keys
k = dbs.get("enchdesc")
if k:
    lines += ["", f"enchdesc block: {len(k)} keys; vanilla `.desc` keys among them: {sum(1 for x in k if x.startswith('enchantment.minecraft.') and x.endswith('.desc'))}"]
open(out, "w").write("\n".join(lines) + "\n")
print("\n".join(lines))

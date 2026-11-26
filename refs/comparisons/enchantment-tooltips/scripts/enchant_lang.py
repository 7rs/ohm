#!/usr/bin/env python3
"""Which enchantments of the installed jars have a description key that Enchantment Descriptions can read?

usage: enchant_lang.py JARS_DIR ED_JAR OUT_PREFIX [EXTRA_ZIP ...]

JARS_DIR holds <slug>/<file>.jar (as written by dl_installed.py). Nested jars (META-INF/jarjar) are read.
Lang files are assets/<ns>/lang/*.json. Keys are read as text, nothing is run.

Enchantment Descriptions (DescriptionManager.get) reads, for an enchantment with description id
`enchantment.<ns>.<path>`, the key `<id>.desc`, then `<id>.description`, in the game's active language
(I18n.exists), and falls back to Component.translatable of `<id>.desc` (shown as the raw key).

Outputs:
  OUT_PREFIX_enchantments.tsv : one row per enchantment name key found in any jar's en_us.json
      cols: namespace, key, jar, has_desc_en(source), has_desc_ja(source), name_ja
  OUT_PREFIX_summary.md       : counts per namespace
"""
import sys, os, io, json, zipfile, re, collections

jars_dir, ed_jar, out = sys.argv[1:4]
extra = sys.argv[4:]

def load_json(zf, name):
    try:
        raw = zf.read(name).decode("utf-8-sig")
        return json.loads(raw, strict=False)
    except Exception:
        # tolerate comments / trailing commas: strip // and /* */ crudely
        try:
            raw = re.sub(r"^\s*//.*$", "", raw, flags=re.M)
            raw = re.sub(r",\s*([}\]])", r"\1", raw)
            return json.loads(raw, strict=False)
        except Exception:
            return None

# lang[(lang_code)][key] -> list of (source_label)
lang = collections.defaultdict(lambda: collections.defaultdict(list))
ench_names = {}  # key -> set(jar labels) from en_us

def scan(zf, label):
    for n in zf.namelist():
        m = re.match(r"assets/([^/]+)/lang/([a-z_]+)\.json$", n)
        if m:
            code = m.group(2)
            if code not in ("en_us", "ja_jp"):
                continue
            d = load_json(zf, n)
            if not isinstance(d, dict):
                continue
            for k, v in d.items():
                if not isinstance(v, str):
                    continue
                if k.startswith("enchantment.") or k.endswith(".desc") or k.endswith(".description"):
                    lang[code][k].append(label)
        elif n.startswith("META-INF/jarjar/") and n.endswith(".jar"):
            try:
                scan(zipfile.ZipFile(io.BytesIO(zf.read(n))), label + "!" + os.path.basename(n))
            except Exception:
                pass

paths = []
for root, _, files in os.walk(jars_dir):
    for f in files:
        if f.lower().endswith(".jar"):
            paths.append(os.path.join(root, f))
for p in sorted(paths):
    try:
        scan(zipfile.ZipFile(p), os.path.basename(os.path.dirname(p)))
    except Exception as e:
        print("skip", p, e, file=sys.stderr)

# split: the ED jar's own strings are tracked apart
ed_lang = collections.defaultdict(dict)
zf = zipfile.ZipFile(ed_jar)
for code in ("en_us", "ja_jp"):
    d = load_json(zf, f"assets/enchdesc/lang/{code}.json") or {}
    ed_lang[code] = {k: v for k, v in d.items() if isinstance(v, str)}

extra_lang = collections.defaultdict(dict)
for ez in extra:
    z = zipfile.ZipFile(ez)
    for n in z.namelist():
        m = re.match(r"assets/([^/]+)/lang/([a-z_]+)\.json$", n)
        if m and m.group(2) in ("en_us", "ja_jp"):
            d = load_json(z, n) or {}
            for k, v in d.items():
                if isinstance(v, str):
                    extra_lang[m.group(2)][k] = os.path.basename(ez)

def has_desc(code, base):
    srcs = []
    for suffix in (".desc", ".description"):
        k = base + suffix
        if k in lang[code]:
            srcs.append("jar:" + "/".join(sorted(set(lang[code][k]))))
        if k in ed_lang[code]:
            srcs.append("ED")
        if k in extra_lang[code]:
            srcs.append("pack:" + extra_lang[code][k])
    return srcs

rows = []
for k, labels in lang["en_us"].items():
    if not k.startswith("enchantment.") or k.endswith(".desc") or k.endswith(".description"):
        continue
    parts = k.split(".")
    if len(parts) < 3:
        continue
    # skip level keys such as enchantment.level.1
    if parts[1] == "level":
        continue
    ns = parts[1]
    rows.append((ns, k, "/".join(sorted(set(labels)))))

with open(out + "_enchantments.tsv", "w") as f:
    f.write("namespace\tkey\tjar\tdesc_en\tdesc_ja\tname_ja\n")
    for ns, k, j in sorted(rows):
        en = has_desc("en_us", k)
        ja = has_desc("ja_jp", k)
        nj = "yes" if k in lang["ja_jp"] or k in extra_lang["ja_jp"] else "no"
        f.write(f"{ns}\t{k}\t{j}\t{';'.join(en) or '-'}\t{';'.join(ja) or '-'}\t{nj}\n")

by = collections.OrderedDict()
for ns, k, j in sorted(rows):
    d = by.setdefault(ns, {"n": 0, "en": 0, "ja": 0, "namej": 0, "jars": set()})
    d["n"] += 1
    d["en"] += 1 if has_desc("en_us", k) else 0
    d["ja"] += 1 if has_desc("ja_jp", k) else 0
    d["namej"] += 1 if (k in lang["ja_jp"] or k in extra_lang["ja_jp"]) else 0
    d["jars"].add(j.split("/")[0])
with open(out + "_summary.md", "w") as f:
    f.write("| Namespace | Enchantment name keys (en_us) | With a .desc or .description key (en_us) | ... in ja_jp | Name key in ja_jp | Jar |\n|---|---|---|---|---|---|\n")
    for ns, d in by.items():
        f.write(f"| {ns} | {d['n']} | {d['en']} | {d['ja']} | {d['namej']} | {', '.join(sorted(d['jars']))} |\n")
print(len(rows), "enchantment name keys in", len(by), "namespaces")

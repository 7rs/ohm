#!/usr/bin/env python3
"""Merge Modrinth search JSON files, keep projects whose title/slug/description mention a keyword.
usage: mr_merge.py DATADIR OUT.csv"""
import sys, json, glob, csv, re
data, out = sys.argv[1], sys.argv[2]
kw = re.compile(r"screen\s?shot|panorama|360|hi-?res|high[- ]res|resolution|supersampl|gigapixel|poster|photo|stitch|tiled|\b[48]k\b|16k|capture|snapshot|camera|render\s?scale|framebuffer|upscal|downscal|image export", re.I)
proj = {}
for fn in glob.glob(data + "/mr_search_*.json"):
    d = json.load(open(fn))
    for h in d["hits"]:
        p = proj.setdefault(h["project_id"], {"h": h, "terms": set()})
        p["terms"].add(d["term"])
rows = []
for pid, p in proj.items():
    h = p["h"]
    txt = " ".join([h["title"], h["slug"], h["description"]])
    if not kw.search(txt):
        continue
    cats = h.get("categories", []) + h.get("additional_categories", [])
    loaders = sorted(set(c for c in h.get("display_categories", []) + cats if c in ("forge", "fabric", "neoforge", "quilt", "liteloader", "rift")))
    vers = h.get("versions", [])
    rows.append({"slug": h["slug"], "title": h["title"], "downloads": h["downloads"], "follows": h["follows"],
                 "loaders": "/".join(loaders), "has_1.20.1": "1.20.1" in vers, "date_modified": h["date_modified"][:10],
                 "client_side": h.get("client_side"), "server_side": h.get("server_side"),
                 "desc": h["description"].replace("\n", " "), "terms": ";".join(sorted(p["terms"])), "pid": pid})
rows.sort(key=lambda r: -r["downloads"])
with open(out, "w", newline="") as f:
    w = csv.DictWriter(f, fieldnames=list(rows[0].keys()))
    w.writeheader(); w.writerows(rows)
print(len(proj), "projects total;", len(rows), "keyword-relevant")

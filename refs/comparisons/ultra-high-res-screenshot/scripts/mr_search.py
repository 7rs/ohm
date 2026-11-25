#!/usr/bin/env python3
"""Search Modrinth for mods by term; save raw hits per term; print compact rows.
usage: mr_search.py OUTDIR term1 term2 ...
Each term is searched with project_type in (mod, modpack excluded), unfiltered by loader/version,
so Fabric-only and other-version projects are recorded too (the filter is applied later)."""
import sys, json, urllib.request, urllib.parse, os, time
out = sys.argv[1]
os.makedirs(out, exist_ok=True)
UA = "mod-researcher/1.0 (modpack research)"
def get(url):
    req = urllib.request.Request(url, headers={"User-Agent": UA})
    with urllib.request.urlopen(req, timeout=40) as r:
        return json.load(r)
for term in sys.argv[2:]:
    hits = []
    offset = 0
    while True:
        q = urllib.parse.urlencode({"query": term, "limit": 100, "offset": offset,
                                    "facets": json.dumps([["project_type:mod"]])})
        d = get("https://api.modrinth.com/v2/search?" + q)
        hits += d["hits"]
        offset += 100
        if offset >= min(d["total_hits"], 300):
            break
        time.sleep(0.3)
    fn = os.path.join(out, "mr_search_" + term.replace(" ", "_") + ".json")
    json.dump({"term": term, "total_hits": d["total_hits"], "hits": hits}, open(fn, "w"))
    print(f"{term!r}: total_hits={d['total_hits']} fetched={len(hits)}", file=sys.stderr)

#!/usr/bin/env python3
"""Search Modrinth for Forge 1.20.1 mods by term. usage: mr_search.py OUT.tsv TERM [TERM ...]
One row per hit: term, slug, title, downloads, updated, client_side, server_side, categories, description."""
import sys, json, urllib.request, urllib.parse
out = sys.argv[1]; terms = sys.argv[2:]
facets = json.dumps([["categories:forge"], ["versions:1.20.1"], ["project_type:mod"]])
rows = {}
for t in terms:
    url = "https://api.modrinth.com/v2/search?" + urllib.parse.urlencode({"query": t, "facets": facets, "limit": 25, "index": "relevance"})
    req = urllib.request.Request(url, headers={"User-Agent": "mod-research-client"})
    d = json.load(urllib.request.urlopen(req, timeout=60))
    for h in d["hits"]:
        r = rows.setdefault(h["slug"], {"terms": set(), **h})
        r["terms"].add(t)
with open(out, "w") as f:
    f.write("slug\ttitle\tdownloads\tupdated\tclient\tserver\tterms\tdescription\n")
    for s, h in sorted(rows.items(), key=lambda x: -x[1]["downloads"]):
        f.write("\t".join([s, h["title"], str(h["downloads"]), h["date_modified"][:10], h["client_side"], h["server_side"], "|".join(sorted(h["terms"])), h["description"].replace("\t", " ").replace("\n", " ")[:160]]) + "\n")
print(len(rows), "projects")

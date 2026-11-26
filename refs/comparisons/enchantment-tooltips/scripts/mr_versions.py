#!/usr/bin/env python3
"""Latest Forge 1.20.1 version of Modrinth projects, with dependencies. usage: mr_versions.py OUT.tsv DOWNLOAD_DIR SLUG [SLUG ...]
Downloads the newest Forge 1.20.1 file of each slug into DOWNLOAD_DIR/<slug>/ (sha512 checked against the API)."""
import sys, json, os, hashlib, urllib.request, urllib.parse
out, dest = sys.argv[1:3]; slugs = sys.argv[3:]
UA = {"User-Agent": "mod-research-client"}
def get(url): return json.load(urllib.request.urlopen(urllib.request.Request(url, headers=UA), timeout=60))
rows = []
for s in slugs:
    p = get(f"https://api.modrinth.com/v2/project/{s}")
    q = urllib.parse.urlencode({"loaders": json.dumps(["forge"]), "game_versions": json.dumps(["1.20.1"])})
    vs = get(f"https://api.modrinth.com/v2/project/{s}/version?{q}")
    if not vs:
        rows.append((s, p["title"], p["downloads"], p["updated"][:10], "no forge 1.20.1 version", "", "", "", "", "", p["client_side"], p["server_side"], p.get("source_url") or "", p["license"]["id"])); continue
    v = vs[0]; f = [x for x in v["files"] if x["primary"]][0] if any(x["primary"] for x in v["files"]) else v["files"][0]
    d = os.path.join(dest, s); os.makedirs(d, exist_ok=True)
    path = os.path.join(d, f["filename"])
    data = urllib.request.urlopen(urllib.request.Request(f["url"], headers=UA), timeout=120).read()
    ok = hashlib.sha512(data).hexdigest() == f["hashes"]["sha512"]
    open(path, "wb").write(data)
    deps = ";".join(f'{x["project_id"]}:{x["dependency_type"]}' for x in v["dependencies"])
    rows.append((s, p["title"], p["downloads"], p["updated"][:10], v["version_number"], v["date_published"][:10], f["filename"], f["size"], "ok" if ok else "HASH-MISMATCH", deps, p["client_side"], p["server_side"], p.get("source_url") or "", p["license"]["id"]))
with open(out, "w") as fh:
    fh.write("slug\ttitle\tdownloads\tproject_updated\tversion\tpublished\tfile\tsize\tsha512\tdeps\tclient\tserver\tsource\tlicense\n")
    for r in rows: fh.write("\t".join(map(str, r)) + "\n")
    print("\n".join("\t".join(map(str, r)) for r in rows))

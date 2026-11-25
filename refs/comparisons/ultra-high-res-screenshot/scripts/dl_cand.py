#!/usr/bin/env python3
"""Download Forge 1.20.1 files of Modrinth projects (all versions that list forge + 1.20.1) into DEST/<slug>/<version>/<file>, plus sha512 check.
usage: dl_cand.py DATADIR DEST slug..."""
import sys, os, json, urllib.request, hashlib
data, dest = sys.argv[1], sys.argv[2]
UA = "mod-researcher/1.0 (modpack research)"
for s in sys.argv[3:]:
    d = json.load(open(f"{data}/mr_proj_{s}.json"))
    for v in d["versions"]:
        if "forge" in v["loaders"] and "1.20.1" in v["game_versions"]:
            for f in v["files"]:
                out = os.path.join(dest, s, v["version_number"].replace("/", "_"))
                os.makedirs(out, exist_ok=True)
                path = os.path.join(out, f["filename"])
                if not os.path.exists(path):
                    b = urllib.request.urlopen(urllib.request.Request(f["url"], headers={"User-Agent": UA}), timeout=120).read()
                    open(path, "wb").write(b)
                h = hashlib.sha512(open(path, "rb").read()).hexdigest()
                print(s, v["version_number"], f["filename"], os.path.getsize(path), "sha512 ok" if h == f["hashes"]["sha512"] else "HASH MISMATCH")

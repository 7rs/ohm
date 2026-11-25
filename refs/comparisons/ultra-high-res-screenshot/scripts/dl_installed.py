#!/usr/bin/env python3
"""Download the jars of the installed mods listed in the metafiles into DEST/<slug>/<filename>.
Modrinth metafiles have a url; CurseForge ones are built from file-id and filename on the CDN.
usage: dl_installed.py REPO_MODS_DIR DEST"""
import sys, os, glob, tomllib, urllib.request, urllib.parse, hashlib
from concurrent.futures import ThreadPoolExecutor
mods, dest = sys.argv[1], sys.argv[2]
UA = "mod-researcher/1.0 (modpack research)"
def job(fn):
    slug = os.path.basename(fn)[:-8]
    d = tomllib.load(open(fn, "rb"))
    name = d["filename"]
    url = d["download"].get("url")
    if not url:
        fid = d["update"]["curseforge"]["file-id"]
        url = f"https://mediafilez.forgecdn.net/files/{fid // 1000}/{fid % 1000}/{urllib.parse.quote(name)}"
    out = os.path.join(dest, slug); os.makedirs(out, exist_ok=True)
    path = os.path.join(out, name)
    if os.path.exists(path) and os.path.getsize(path) > 0:
        return slug, "cached", 0
    try:
        data = urllib.request.urlopen(urllib.request.Request(url, headers={"User-Agent": UA}), timeout=120).read()
        h = hashlib.new(d["download"]["hash-format"], data).hexdigest()
        ok = h == d["download"]["hash"]
        open(path, "wb").write(data)
        return slug, "ok" if ok else "HASH-MISMATCH", len(data)
    except Exception as e:
        return slug, f"ERR {e}", 0
with ThreadPoolExecutor(8) as ex:
    res = list(ex.map(job, sorted(glob.glob(mods + "/*.pw.toml"))))
bad = [r for r in res if r[1] not in ("ok", "cached")]
print(len(res), "metafiles;", sum(1 for r in res if r[1] == "ok"), "ok;", sum(r[2] for r in res) // 1024 // 1024, "MB;", "problems:", bad)

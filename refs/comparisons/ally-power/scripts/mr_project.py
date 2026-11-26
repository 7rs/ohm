#!/usr/bin/env python3
"""Fetch Modrinth project + versions for slugs; save raw JSON; print summary of Forge 1.20.1 versions.
usage: mr_project.py OUTDIR slug..."""
import sys, json, urllib.request, os
out = sys.argv[1]; os.makedirs(out, exist_ok=True)
UA = "mod-researcher/1.0 (modpack research)"
def get(u):
    return json.load(urllib.request.urlopen(urllib.request.Request(u, headers={"User-Agent": UA}), timeout=40))
for s in sys.argv[2:]:
    try:
        p = get(f"https://api.modrinth.com/v2/project/{s}")
        v = get(f"https://api.modrinth.com/v2/project/{s}/version")
    except Exception as e:
        print(s, "ERR", e); continue
    json.dump({"project": p, "versions": v}, open(f"{out}/mr_proj_{s}.json", "w"))
    print(f"== {s}: {p['title']} | dl={p['downloads']} | updated={p['updated'][:10]} | client={p['client_side']} server={p['server_side']} | src={p.get('source_url')} | status={p['status']}")
    print("   loaders:", p["loaders"], " versions(last5):", p["game_versions"][-5:])
    f = [x for x in v if "forge" in x["loaders"] and "1.20.1" in x["game_versions"]]
    print(f"   forge 1.20.1 versions: {len(f)} (of {len(v)} total)")
    for x in f[:4]:
        print("    ", x["version_number"], x["date_published"][:10], x["version_type"], x["loaders"], [d["dependency_type"]+":"+str(d.get("project_id")) for d in x["dependencies"]], [(ff["filename"], ff["size"]) for ff in x["files"]][:2], "dl=", x["downloads"])

#!/usr/bin/env python3
"""Query api.cfwidget.com for CurseForge mc-mods slugs; save raw JSON; print summary and Forge/1.20.1 files.
usage: cf_widget.py OUTDIR slug..."""
import sys, json, urllib.request, os
out = sys.argv[1]; os.makedirs(out, exist_ok=True)
UA = "mod-researcher/1.0 (modpack research)"
for s in sys.argv[2:]:
    try:
        d = json.load(urllib.request.urlopen(urllib.request.Request(f"https://api.cfwidget.com/minecraft/mc-mods/{s}", headers={"User-Agent": UA}), timeout=40))
    except Exception as e:
        print(f"== {s}: ERR {e}"); continue
    json.dump(d, open(f"{out}/cf_{s}.json", "w"))
    dl = d.get("downloads", {})
    print(f"== {s}: {d.get('title')} id={d.get('id')} | total={dl.get('total')} monthly={dl.get('monthly')} | updated={str(d.get('last_fetch'))[:10]} | created={str(d.get('created_at'))[:10]} | members={[m.get('username') for m in d.get('members',[])][:2]}")
    print("   summary:", (d.get("summary") or "")[:130])
    vs = d.get("versions", {})
    print("   versions keys:", [k for k in vs.keys()][:25])
    f = vs.get("1.20.1", [])
    for x in f:
        print("    1.20.1:", x.get("name"), str(x.get("uploaded_at"))[:10], x.get("type"), x.get("version"), x.get("id"), x.get("filesize"))

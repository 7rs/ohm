#!/usr/bin/env python3
"""Summarise saved Modrinth project JSON (mr_proj_<slug>.json) and CurseForge widget JSON (cf_<slug>.json) into one CSV.
usage: project_summary.py DATADIR OUT.csv slug [slug ...]"""
import sys, json, csv, os
data, out = sys.argv[1:3]
rows = [["slug", "title", "modrinth_project_downloads", "forge_1.20.1_files", "forge_1.20.1_file_downloads", "last_forge_1.20.1_version", "last_forge_1.20.1_date", "last_type", "first_forge_1.20.1_date", "modrinth_updated", "modrinth_client_side", "modrinth_server_side", "license", "source_url", "curseforge_total_downloads", "curseforge_latest_1.20.1_file", "curseforge_latest_1.20.1_date"]]
for s in sys.argv[3:]:
    p = os.path.join(data, f"mr_proj_{s}.json")
    if not os.path.exists(p): continue
    d = json.load(open(p)); pr = d["project"]
    f = sorted([v for v in d["versions"] if "forge" in v["loaders"] and "1.20.1" in v["game_versions"]], key=lambda v: v["date_published"], reverse=True)
    cfp = os.path.join(data, f"cf_{s}.json"); cft = cfv = cfd = ""
    if os.path.exists(cfp):
        c = json.load(open(cfp)); cft = c["downloads"]["total"]
        fl = c["versions"].get("1.20.1", [])
        fl = [x for x in fl if "forge" in x["name"].lower() or "Forge" in x["name"]] or fl
        if fl: cfv = fl[0]["name"]; cfd = str(fl[0]["uploaded_at"])[:10]
    rows.append([s, pr["title"], pr["downloads"], len(f), sum(v["downloads"] for v in f), f[0]["version_number"] if f else "", f[0]["date_published"][:10] if f else "", f[0]["version_type"] if f else "", f[-1]["date_published"][:10] if f else "", pr["updated"][:10], pr["client_side"], pr["server_side"], (pr.get("license") or {}).get("id", ""), pr.get("source_url") or "", cft, cfv, cfd])
csv.writer(open(out, "w", newline="")).writerows(rows)
print(len(rows) - 1, "projects")

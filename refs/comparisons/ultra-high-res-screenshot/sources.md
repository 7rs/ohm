# Sources

All consulted on 2026-11-25. Types: platform API (P), source repository (S), jar or zip read locally (J), issue tracker (T), web search (W), vendor file (V).

## Platforms

| Source | Type | Use |
| --- | --- | --- |
| https://api.modrinth.com/v2/search and /project/{slug}, /version | P | 76 search terms (see `coverage_report.md`), project data, versions, downloads, loaders, sides, hashes |
| https://api.cfwidget.com/minecraft/mc-mods/{slug} | P | CurseForge project downloads and files for known slugs (CurseForge search itself returns 403 behind Cloudflare, so it was not crawled) |
| Web searches restricted to curseforge.com and modrinth.com (5 queries) and on the open web (8 queries, English, Japanese, Chinese) | W | find CurseForge-only and fork projects: Picture Mode, ReForgedPlay, Recordium, Screenshot Plus, Nicephore, Resolution Control family |

## Source repositories (cloned, branch noted in `comparison.md`)

- https://github.com/DHJComical/HiResShot (branch Forge-1.20.1)
- https://github.com/AstraCoders/Forgeshot (commit 855835d, 2024-01-19)
- https://github.com/xkball/PanoramicScreenshot (branch 1.20.1)
- https://github.com/Fuzss/pixelshot (branch 1.20.1)
- https://github.com/jaredlll08/bigshot (main, the 1.20.1 initial commit)
- https://github.com/forkiesassds/PictureMode (branch rewrite; the jar was used for the 1.20.1 facts)
- https://github.com/shuntilettuce/photographica (branch forge-1.20.1)
- https://github.com/Zolo101/RenderScale (README and gametest)
- https://github.com/ramidzkh/fabrishot (reference design only)

## Jars and zips read (each extracted into its own empty directory outside the repository, nothing executed)

- Candidate jars from the Modrinth CDN (sha512 checked): BigShot 1.0.1, Forgeshot 1.0, Pixelshot v20.1.0, HiResShot 0.0.1, Power Screenshot 1.0.0 and 1.0.1, Snapmatica 1.3.2 to 1.3.5, Picture Mode 1.0.0 to 1.1.8, Panoramica 1.2.1.
- All 136 installed mod jars (Modrinth CDN or the CurseForge CDN, hash checked against the metafile) for the Mixin scan; Oculus 1.8.0, Distant Horizons 3.3.3, Embeddium 0.3.31, Punchy! 3.2b read in detail.
- The five installed shader pack zips (BSL 10.1, Complementary Reimagined r5.10, I Like Vanilla 1.5.0b, Mellow 3.5, Solas 3.9).
- Minecraft 1.20.1 client.jar and Mojang mappings (https://piston-meta.mojang.com/v1/packages/65758d280ac7a6cf0e47bd6439a130e30b357117/1.20.1.json) for vanilla `Screenshot`, `RenderTarget`, `GameRenderer.renderZoomed`, `Minecraft.grabHugeScreenshot`.
- https://maven.minecraftforge.net/net/minecraftforge/javafmllanguage/1.20.1-47.4.28/javafmllanguage-1.20.1-47.4.28.jar for the mod constructor rule of FML 47.4.28.

## Issue trackers

See `gh_issues.md`. GitLab API (public issues only): https://gitlab.com/api/v4/projects/distant-horizons-team%2Fdistant-horizons/issues?search=...

## Project files read

`CLAUDE.md`, `refs/comparisons/index.md`, `refs/notes.md`, `refs/issues.md`, `refs/list.md`, `config/defaultoptions/options.txt`, `config/defaultoptions/extra/config/oculus.properties`, the metafiles under `mods/` and `shaderpacks/`.

## Reproduction

`scripts/` has the collectors: `mr_search.py`, `mr_merge.py`, `mr_project.py`, `cf_widget.py`, `dl_installed.py`, `dl_cand.py`, `mixin_scan.py`, `mixin_overlap.py`, `keyscan.py`, `memory_estimate.py`, `project_summary.py`. Run Python with `-I` and point them at an empty scratch directory. The comparison skill's `compare.py` was not present, so no scores or tiers were computed.

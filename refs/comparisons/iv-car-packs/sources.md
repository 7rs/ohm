# Sources (2026-11-24)

## Inventories used for discovery

| Source | Type | Use |
| --- | --- | --- |
| IV CurseForge page description (via `api.cfwidget.com/minecraft/mc-mods/minecraft-transport-simulator`) | maker's list, 60 names | pack list, FAQ (crash-listed packs, 1.16 packs on 1.20) |
| "A complete guide to Immersive Vehicles packs" Google Sheet (linked from the IV page): `https://docs.google.com/spreadsheets/d/1iyEYftJvWJ37N84DUiUtkDFwO008e32btZXp6kdsFrg` (tab gid 0) | community list by IV pack authors, 75 rows | status, abandoned, per-version support, contents, pros and cons |
| Modrinth search API, Forge and 1.20.1, queries "immersive vehicles", "MTS content pack", "IV/MTS", "immersive vehicles cars" | platform index, 36 projects | Modrinth-hosted packs |
| Web searches: JDM, American and European IV packs; standalone Forge 1.20.1 car mods | search | unlisted packs (Sungradsk, New Cars, GAM, Asphalt 8, The Cars), standalone car mods |
| MetaMods add-on list of IV (`metamods.net/en/mods/minecraft-transport-simulator/addons`) | third-party index, held back | Step 7 check |
| ModpackIndex IV page | third-party index | same pack list as the IV page |

## Per-pack data

- CurseForge file lists and descriptions through `api.cfwidget.com` (a public mirror of the CurseForge project pages; no key): GT CRAFT 952948, KMW 427473, Craftspeed 513881, SVMP 706496, R.A.G.E 583103, OCP 292217, OAmP 1387229, Sungradsk 1424981, AVP 1326201, Blue Seoul 978100, Mock GoGo 1494707. Saved in `data/meta/`.
- CurseForge project pages read through a web fetch: GT CRAFT, KMW, Craftspeed (files tab), IV 23.0.0 file page.
- Modrinth API: projects and 1.20.1 Forge versions of `gt-craft-ivmts`, `immersive-vehicles-r.a.g.e`, `svmp`, `saltyfish-vehicle`, `repaircarpack`, `immersive-vehicles-official-automobile-pack`, `immersive-vehicles-official-content-pack`, `truckers-pack-immersive-vehiclesivmts`, `trin-civil-pack`, `cmatransportpack`. Saved in `data/meta/mr-*-versions.json`.
- Jars downloaded from the CurseForge CDN and Modrinth CDN (hash-checked for Modrinth files): `gtcraft-2.1.2.jar` (same file on both platforms), `gtcraft-2.0.1(1.20.1).jar`, `Kaminari Motor Work 2.6.1 16-20.jar`, `Craftspeed 1.7.5 (1.16+).jar`, `SVMP3.7.3 1.16+.jar`, `R.A.G.E 3.0_beta2_1.16.5-26.1.jar`, `MTS Official Pack-1.20.1-V29.jar`, `OAmP-1.20.1-V3.jar`; IV core `Immersive Vehicles-1.20.1-24.0.0.jar` (the installed one).
- IV 24.0.0 release notes (CurseForge file page, via a web search): no change aimed at pack formats. IV 23.0.0 notes (CurseForge file page 7423733) include "Made part order in internal lists align with JSON" and "Fixed placed parts from choosing first slot defined over closest slot".

## Not read

CurseForge API returned 404 for `mts-iv-immersive-pokers-garage`, `asphalt-8-minecraft-mts-iv` and the old KMW slug `mts-generals-general-vehicles-pack`. Discord servers of the packs and IV were not read.

# Sources

All consulted on 2026-11-23.

## Enumeration (Modrinth search API, `index=downloads`, 100 per page)

| Query facets | Hits | 100,000 downloads or more | Use |
| --- | --- | --- | --- |
| `project_type:shader`, `versions:1.20.1`, `categories:iris` | 730 | 106 | The market (the user's filter) |
| `project_type:shader`, `versions:1.20.1` | 757 | 109 | Cross-check: what the Iris tag drops |
| `project_type:shader`, `categories:iris` | 1,099 | 112 | Cross-check: what the 1.20.1 tag drops |
| `project_type:shader` | 1,193 | 119 | Cross-check: all shaders |

URL pattern: `https://api.modrinth.com/v2/search?facets=<json>&limit=100&offset=<n>&index=downloads`.

## Per project

| Source | Type | URL pattern |
| --- | --- | --- |
| Project description, tags, downloads, followers | Modrinth API | `https://api.modrinth.com/v2/projects?ids=[...]` |
| Version list for 1.20.1 and Iris, changelogs, file sizes | Modrinth API | `https://api.modrinth.com/v2/project/<slug>/version?loaders=["iris"]&game_versions=["1.20.1"]` |
| Shader zip of the latest 1.20.1 Iris release (106 files, 262 MB) | Download from `cdn.modrinth.com`, read in memory with .NET `ZipFile` (never extracted) | `files[].url` of the version above |

## Mods and platform pages

| Source | Used for | URL |
| --- | --- | --- |
| Oculus 1.8.0 jar (the file in `mods/oculus.pw.toml`) | `FeatureFlags` class: supported Iris features | `https://cdn.modrinth.com/data/GchcoXML/versions/iQ1SwGc3/oculus-mc1.20.1-1.8.0.jar` |
| Oculus project and 1.20.1 changelogs | 1.8.0 = Iris 1.7.0 parity and DH 2.2 fix | `https://api.modrinth.com/v2/project/oculus` |
| Colorwheel project page | Official, patcher and fallback shader lists | `https://modrinth.com/mod/colorwheel` |
| Distant Horizons project page and 1.20.1 changelogs | Shader support rules, Oculus fix in 3.3.2 | `https://modrinth.com/mod/distanthorizons` |
| Euphoria Patches project | Project type check | `https://modrinth.com/mod/euphoria-patches` |

## The user's three pages (read as text)

- `https://modrinth.com/shader/bsl-shaders?g=1.20.1&l=iris`
- `https://modrinth.com/shader/complementary-reimagined?g=1.20.1&l=iris`
- `https://modrinth.com/shader/complementary-unbound?g=1.20.1&l=iris`
- `https://www.complementary.dev/shaders/` (the two styles differ only in default settings)
- `https://www.complementary.dev/changelogs` (headings only; r5.10 is dated 2026-11-18)
- `https://github.com/ComplementaryDevelopment/ComplementaryReimagined` (landing page only, no README text)
- `https://capttatsu.com/bslshaders/` (landing page only; its tabs load by script, and the FAQ and changelog paths returned 404)

## Second round (2026-11-23): lightness, Colorwheel Patcher, TACZ

- https://themodhunter.com/mods/minecraft-26-3-shader-packs-ranked/ and https://themodhunter.com/mods/ultra-realistic-minecraft-26-3/ (third-party FPS of 13 packs, Minecraft 26.3)
- https://vervecode.dev/en/games/minecraft-iris-shaders/ (third-party FPS of 3 packs)
- https://modrinth.com/shader/i-like-vanilla and https://modrinth.com/shader/bloop-shaders (author tables)
- https://modrinth.com/mod/colorwheel-patcher (project, version list); its 1.0.5 jar `colorwheel_patcher-forge-1.0.5+mc1.20.1.jar` (sha512 equal to `mods/colorwheel-patcher.pw.toml`) read in memory: `config.json`, `mods.toml`, the list of patch zips, class strings
- BSL 10.1 (`https://cdn.modrinth.com/data/Q1vvjJYV/versions/3WGx0wKu/BSL_v10.1.zip`) compared file by file with 10.1.8
- Modrinth API: `timeless-and-classics-zero` (1.20.1 versions and changelogs), `tacza`, `shader-carry`, `lr-tactical`, and Forge 1.20.1 mod searches for "tacz shader", "tacz scope", "tacz oculus", "tacz iris", "tacz compat"
- GitHub: `MCModderAnchor/TACZ` issues 662 and 755 (read in full), search for "Oculus scope", "shader scope", "Iris scope"; `Asek3/Oculus` issues 797 and 678 (read in full)
- Web search: "TACZ scope rendering shader compatibility fix mod 1.20.1"; two searches for shader benchmark tables found no cross-pack table beyond the sources above

## Issue trackers (GitHub search API, issues)

- `Asek3/Oculus` searched for: BSL, Complementary, Photon, Solas, Bliss, Rethinking Voxels, MakeUp, Noble, Lumina, Mellow. Issues read in full: 868, 355, 592, 833, 858, 797, 678.
- `sixthsurge/photon`: "Oculus", "1.20.1".
- `Septonious/Solas-Shader`: "Oculus", "1.20.1".
- `X0nk/Bliss-Shader`: "Oculus", "1.20.1".
- `ComplementaryDevelopment/ComplementaryReimagined`: "Oculus", "1.20.1".
- `gri573/rethinking-voxels`: "Oculus". `javiergcim/MakeUpUltraFast`: "Oculus".

Only titles, states and dates of the tracker search results were read, apart from the issues listed above.

## Local files read

`mods/oculus.pw.toml`, `mods/embeddium.pw.toml`, `mods/distanthorizons.pw.toml`, `config/defaultoptions/extra/config/oculus.properties`, `refs/notes.md`, `refs/issues.md`, `refs/settings.md`, `refs/list.md`.

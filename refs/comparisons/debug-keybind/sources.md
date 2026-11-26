# Sources

All consulted on 2026-11-26. Types: API (platform JSON), jar (downloaded file, read with `javap`, never run), repo (GitHub), web (search result or page).

## Round 1: the candidate and its library

| Source | Type | URL |
| --- | --- | --- |
| Modrinth project and version list, Debug Keybind | API | https://api.modrinth.com/v2/project/debug-keybind and /version |
| Modrinth project and version list, BoxLib | API | https://api.modrinth.com/v2/project/boxlib and /version |
| Debug Keybind 9.1.1 Forge jar | jar | https://cdn.modrinth.com/data/DX9ioka8/versions/ITjGkv0o/DebugKeybind-forge-9.1.1.jar |
| Debug Keybind 5.0.0 jar (BoxLib 9.0.0 inside) | jar | https://cdn.modrinth.com/data/DX9ioka8/versions/shVxcsKM/DebugKeybind-5.0.0.jar |
| BoxLib 11.3.2 Forge jar | jar | https://cdn.modrinth.com/data/HAE5KvTA/versions/rXxdW1JV/Boxlib-forge-11.3.2.jar |
| CurseForge page, Debug Keybind | web | https://www.curseforge.com/minecraft/mc-mods/debug-keybind |
| CurseForge file lists through the CFWidget mirror | API | https://api.cfwidget.com/minecraft/mc-mods/debug-keybind and /boxlib |
| GitHub Boxadactle/DebugKeybind: repo, branches, commits, releases, 21 issues | repo | https://github.com/Boxadactle/DebugKeybind |
| GitHub Boxadactle/BoxLib: repo, branches, releases, 9 issues | repo | https://github.com/Boxadactle/BoxLib |

## Round 2: similar mods

| Source | Type | URL |
| --- | --- | --- |
| Modrinth search, Forge and 1.20.1 facets, 24 queries (listed in `coverage_report.md`) | API | https://api.modrinth.com/v2/search |
| Modrinth projects read: DebugUtils, KeyBindSlots, XYZ Copy, no f3, Better Gamemode, simpler keybinds, Modifier Keybinds, RebindMyKeys, Thorough Keybindings, F3 CHANGER | API | https://api.modrinth.com/v2/project/<slug> |
| Web search: Minecraft mod rebind F3 debug key combinations Forge | web | result list names Debug Keybind, F3 Changer, Rebind All The Keys, ReBind, Legacy Rebindable Keys, Thorough Keybindings |
| Web search: F3 menu keys hard-coded cannot rebind Minecraft | web | result list names Debug Keybind, RebindMyKeys, a Mojang feedback post, speedrun.com threads |

## Round 3: conflicts with installed mods

| Source | Type | Note |
| --- | --- | --- |
| 138 installed jars from the `mods/` metafiles (CDN URLs in `data/installed_jar_urls.tsv`; hashes verified against the metafiles) | jar | extracted into the session scratchpad, outside the repository |
| Forge 47.4.28 patched client and SRG-named Minecraft 1.20.1 client from the Prism libraries folder | jar | used to check mixin targets and member references |
| GitHub issue search for Debug Keybind in BetterF3, Key Binding Patch, Controlling | repo | found BetterF3 issue 185 and Controlling issue 237 (`gh_issues.md`) |

The scripts under `scripts/` are the ones that produced the data. Their paths point at the session scratchpad of this run and need adapting before a re-run. Raw extracts are under `data/`.

# Sources consulted

## Round 1: discovery

| Source | Type | What was used |
| --- | --- | --- |
| https://api.modrinth.com/v2/search (19 queries, project type mod, no loader filter) | Platform search API | 75 unique hits. Queries: experimental, experimental warning, experimental settings, experimental world, worldgen warning, world creation warning, custom worlds advice, disable experimental, skip experimental, experimental menu, experimental screen, world warning, confirm screen, experimental features, no experimental, hide warning, experimental disabler, optimizing world, datapack warning |
| Web search (earlier in the session) | Search engine | Found Shutup Experimental Settings!, No Worldgen Warning, Hide Experimental Warning, Experimental Settings Disabler |

## Round 2: expansion

| Source | Type | What was used |
| --- | --- | --- |
| https://api.modrinth.com/v2/search (17 queries, filter forge + 1.20.1) | Platform search API | 404 unique hits; no new relevant mod. Queries: warning, popup, prompt, screen, skip, disable, world load, custom world, modded world, yeet, dismiss, confirm, experimental, worldgen, lifecycle, nag, annoying |
| https://api.github.com/search/repositories (4 queries) | Code host search | Serilum/Hide-Experimental-Warning, naritanara/DisableCustomWorldsAdvice and one aggregator mirror; no new relevant mod |
| Exa search for CurseForge pages | Search engine | CurseForge pages of Experimental Settings Disabler, Hide Experimental Warning, Shutup Experimental Settings!, Experimentalist; Yeetus Experimentus listings on aggregator sites (mineuniverse, 9minecraft, ftb wiki) |
| https://api.cfwidget.com/minecraft/mc-mods/<slug> | Third-party CurseForge mirror | Download counters and file dates for the CurseForge projects |

## Round 3: snowball and verification

| Source | Type | What was used |
| --- | --- | --- |
| Modrinth project and version JSON of the six Modrinth candidates | Platform API | Downloads, dates, dependencies, README text |
| GitHub: nanite/Yeetus-Experimentus, Serilum/Hide-Experimental-Warning, pajicadvance/experimentalist, rdvdev2/DisableCustomWorldsAdvice, Seikai-Takenawa/DirectEntry | Source repositories | READMEs, file trees, mixin sources of the main branches |
| Jars downloaded from Modrinth (sha512 matched the listed hash for Yeetus, Experimentalist, Experimental Settings Disabler): Yeetus 2.3.1 and 2.3.0-build.4, Experimental Settings Disabler 3.0, Hide Experimental Warning 1.3, Collective 8.87, Experimentalist 2.0.3 | Binaries | `mods.toml`, mixin configs, refmaps, bytecode via `javap` |
| Forge 47.4.28 universal, client and SRG client jars from the local Prism libraries | Binaries | Forge config keys; existence of every mixin target in the patched classes |
| Installed ModernFix 5.27.91 and The Aether 1.5.2 jars from the local Prism instance | Binaries | Existing handlers for the same screens |
| https://github.com/rdvdev2/DisableCustomWorldsAdvice README | README | Pointer to the Fabric origin of the Forge port |

# Sources (2026-11-24)

## APIs and pages

| Source | Type | Used for |
| --- | --- | --- |
| https://api.modrinth.com/v2/search (facets Forge, 1.20.1; about 40 queries) | marketplace index | enumeration |
| https://api.modrinth.com/v2/project/{slug} and `/version` | marketplace data | builds, dates, downloads, dependencies |
| https://www.curseforge.com/minecraft/mc-mods/clanging-howl (and `/files`, `/relations/dependencies`) | marketplace page (fetched) | Clanging Howl features, files, file id 8175977 |
| Web search: Infernal Mobs 1.20.1, TaCZ enemy NPC add-ons, blood moon mods | search | CurseForge-only candidates (Infernal Mobs, Command Soldiers, Project TaCZ, CNPC TaCZ Fire, Bloodmoon Update) |
| https://edge.forgecdn.net (Clanging Howl jar) and Modrinth CDN (other jars) | files | jar reading |

## Repositories

| Repository | Read |
| --- | --- |
| https://github.com/CrychicTeam/Champions | issue list (50), issues 65, 72, 92, 94, 145 with comments; branch `1.20.1`: `DampeningAffix`, `AdaptableAffix`, `ShieldingAffix` |
| https://github.com/CorgiTaco/Enhanced-Celestials | issue list (182), issues 198, 214, 233, 237, 252, 258 with comments |
| https://github.com/NekoYuni/Simple-Enemy-Mod-Public | issue list (11) |
| https://github.com/NeoAlive/tacz-simple-enemies-vehicular-warfare | issue list (6) |
| https://github.com/Polarice3/ClangingHowl | issue list (13), `MobUtil.java`, `CHEvents.java`, `CHCapHelper.java` on `master` |
| https://github.com/MCModderAnchor/TACZ | `ModDamageTypes.java` on `1.20.1` |

## Jars read

Champions Unofficial 20.1.1.6, Architectury API 9.2.14, Enhanced Celestials 5.0.3.3, Enhanced Celestials 2 Core 1.0.3.4, Default Lunar Events 1.0.0.7, Shader Support 1.0.0.5, Data Anchor 1.0.0.24, CorgiLib 4.0.3.6, TaCZ NPCs 2.1.0, Simple Enemy 0.1.6-beta-hotfix, TaCZ Combined Arms 0.1.7, Clanging Howl 1.1.0, In Control 9.5.1; installed: TaCZ 1.1.8-hotfix2, Zombie Awareness 1.13.1, Touhou Little Maid 1.5.3, and the 124 pack jars for the Mixin scan.

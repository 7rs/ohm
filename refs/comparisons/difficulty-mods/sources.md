# Sources (2026-11-25)

## APIs and pages

| Source | Type | Used for |
| --- | --- | --- |
| https://api.modrinth.com/v2/search (facets mod, 1.20.1, Forge; 205 queries of 40 hits in 3 rounds) | marketplace index | enumeration (`enumerated.csv` holds the 591 keyword-matched projects with 5,000 or more downloads) |
| https://api.modrinth.com/v2/project/{slug} and `/version` (loaders forge, game version 1.20.1) | marketplace data | builds, channel, dates, downloads, side, dependencies (`candidates_detail.csv`, `libs.csv`) |
| Modrinth project pages (body text) of 43 finalists and near-finalists | marketplace text | features, config notes (Hostility, Improved Mobs, First Aid, TaCZ compat, No Mindless Shooting and others) |
| Web search: Infernal Mobs Forge 1.20.1, Eldritch Mobs 1.20.1, TaCZ Bleeding | search | CurseForge-only candidates (no 1.20.1 Forge file found for Infernal Mobs or Eldritch Mobs); TaCZ Bleeding version history |
| https://edge.forgecdn.net (Clanging Howl jar, file 8175977) and Modrinth CDN | files | jar reading |

## Repositories (issue lists, first 200 of all states, sorted by update; `gh_issues.md`)

L2Hostility, Majrusz's Progressive Difficulty, Scaling Health, Improved Mobs, Mob AI Tweaks, Custom Entity Attributes, Dungeon Difficulty (PowerScale repository), Tough As Nails, Cold Sweat, Thirst Was Taken, Thirst Was Reclaimed, Homeostatic, Legendary Survival Overhaul, First Aid, IguanaTweaks Reborn, Hardcore Survival, No Mindless Shooting, Sculk Horde, Bosses of Mass Destruction, EEEAB's Mobs, Mutant Monsters, Illager Invasion, Meet Your Fight, Aquamirae, The Graveyard, Undead Nights, The Hordes, Zombie Apocalypse Addon, Raided. Not readable: Mowzie's Mobs (404 on the path used), Variants and Ventures, Immersive Pillagers, Cataclysm (403 rate limit). No repository listed: TaCZ Bleeding, Brutal Nightmare, Undead Unleashed.

## Jars read

119 candidate jars and 45 libraries (`jar_summary.csv`; `mods.toml` fields, loader files, Mixin classes, `tacz`, `superbwarfare`, `simpleenemy`, `zombieawareness`, `attributefix`, `clanginghowl` string hits). Read in detail: L2Hostility 2.5.19 (language file, trait and difficulty data, `LHConfig` key names), TaCZ Bleeding 1.7 (language file), No Mindless Shooting 2.3.0 (config key names, TaCZ class references). TaCZ class references were checked against the installed 1.1.8-hotfix2 and against 1.2.0-hotfix (downloaded as a dependency of TaCZ NPCs and TaCZ More Level) for No Mindless Shooting, TaCZ Bleeding, Peak Stamina, TaCZ First Aid Compat, TaCZ First Aid New Compat, Vantage TaCZ Compat, Simple Enemy, TaCZ More Level, Zombie Game Reborn and Insurgents: every class resolves (class level only, members not checked). Installed set: 135 jars (`mixin_conflicts.txt` and `mixin_shared.txt` compare against it).

## Not used

- CurseForge pages and comments (not fetched).
- Modrinth comments and reviews.
- Any ranking or "best of" list.

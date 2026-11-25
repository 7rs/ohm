# Coverage report (2026-11-25)

The result in `comparison.md` is provisional. The convergence test of the comparison skill (Step 1.4: at least 3 rounds, the last adding 0 new companies, two reconciled third-party inventories) was not met.

## Discovery counts

| Round | Queries | Unique projects in the round | New against earlier rounds | Keyword-matched with 5,000 or more downloads (new) |
| --- | --- | --- | --- | --- |
| 1 | 65 | 1,257 | 1,257 | 406 |
| 2 | 80 | 1,211 | 1,033 | 85 |
| 3 | 60 | 903 | 662 | 100 |

Total unique projects seen: 2,952. Round 3 still found relevant new mods (Meet Your Fight, Qliphoth Awakening, Threateningly Mobs, The Graveyard, Mob AI Tweaks, Danger Close, Nyctophobia), so a fourth round would add more. The ledger is a sample.

## Ledger

| Item | Count |
| --- | --- |
| `enumerated.csv` (light record: slug, downloads, date, matched queries, description) | 591 |
| `products.csv` (jar downloaded, read by script) | 121 (scaling 24, survival 29, content 32, enemy 36) |
| finalists / reviewed / excluded | 17 / 97 / 7 |
| Libraries downloaded | 45 (`libs.csv`) |
| Installed jars scanned | 135 |

Exclusions (reason in `products.csv`): Custom Entity Attributes, Mob AI Tweaks, Mebahel's Zombie Horde, Mebahel's Dwarven Automatons, Eldritch End (d: no Forge `mods.toml`); Advent of Ascension and DivineRPG (a: total conversion, not downloaded). Not found on Modrinth under the slug used: Simple Hunger. In Control! was first looked up as `incontrol` (404); its slug is `in-control` (read in the 2026-11-25 follow-up, `followup_products.csv`).

## Evidence levels

- Measured: Modrinth API data (dates, downloads, builds, dependencies) for all 121 rows; jar reading for all 121; Mixin scan for all 121.
- Evaluated: none (no independent reviewer or benchmark was found or used).
- Claimed: feature descriptions from Modrinth pages; GitHub issues are third-party claims.
- Not available for any candidate: in-game behavior, TPS, FPS, shader or Distant Horizons rendering. There is no independent measurement of "how hard" any mod makes the game.

## Spot check (Step 7.2, no held-back inventory existed)

Unfamiliar projects from the light list that were checked for presence in the ledger: Armor Curve (13.6 k, armor formulas for mobs and players, 3.0 on 2026-02-01), Extreme Horde Moon (24 k, add-on of Enhanced Celestials, 1.1 on 2025-11-07; whether it targets version 1 or 2 was not checked), Mutants Plus (19 k, buffs Mutant Monsters), Tiny Foes (15.8 k), Variable Spawner Hardness (22 k). All five are in `enumerated.csv`; none was downloaded or read. Armor Curve and Extreme Horde Moon are the two most likely to matter.

## Not covered

- CurseForge-only mods (Infernal Mobs, Eldritch Mobs and others): web search found no 1.20.1 Forge file; no CurseForge page was read.
- About 2,360 of the 2,952 projects seen (those without a filter word in title or description, or under 5,000 downloads) were not looked at one by one.
- Any mod whose description does not use the filter words.
- The `Brutal Nightmare Config Integration` add-on (settings through a config screen) was seen in the page text and not looked up.
- Mixin scan covers class, method and hooked call. It misses behavior clashes (two mods changing the same mob or damage), registry id clashes and world-generation overlaps.
- L2Hostility's Common config defaults, trait enable switches and the config file name were not read; only key names and data files were.

# Why Alex's Mobs is called heavy (2026-11-25)

Question from the user: the weight of Alex's Mobs is not just a matter of how much content it has. Evidence below comes from the GitHub issue tracker of AlexModGuy/AlexsMobs (search for "lag", "TPS", "performance", comments read for 7 issues), the changelog of Alex's Mobs Continued, and one web search. Nothing was profiled here.

## Causes named in the reports

| Cause | Evidence |
| --- | --- |
| A mob's AI goal searches for something every tick | #437 (1.16.5, Spark profile with 13 elephants): `EntityElephant.tick()` took about 71 % of the ticking time, mostly `CreatureAITargetItems`. #1483 (open, reports from 1.18.2 to 1.21.1): crows, `Mob.serverAiStep()` at 58 % of server ticks; the usual workaround is to kill or blacklist crows. #1309: Potoo "ticking way too long". Alex's Mobs Continued 2.1.14 (2026-09-15): "Crows circling crops look for a new path twice a second instead of every tick" |
| A path or block search over a long distance | #1472 (1.19.2): a leafcutter ant queen moved far from a nest block causes lag spikes while it searches for the nearest free nest block; one queen walked over 1000 blocks with hiccups all the way. #496: bald eagle stuck in the entity collision functions (1.16.5) |
| Population that keeps growing | #839 and #1107: leafcutter anthills spawn ants without limit, TPS cut in half (one report: more than 65 % of tick time). #1664 (open): cachalot whales swarm the ocean, tick time over 500 ms (TPS about 2); a commenter says passive mobs do not despawn unless the player is more than 128 blocks away. #1567 (open): pupfish over-population. Same cause for catfish |
| World data | #1475 (1.19.2): with Citadel and Alex's Mobs, `level.dat` nests recursively after repeated saves; terrain generation gets slow until the file is fixed by hand |
| Third-party fix exists | "Alex's Mobs: Tweaks" (CurseForge): a Forge test with 372 entities, mean MSPT 10.58 to 8.08 (vendor result, not verified); its text says the original sorted a whole candidate list to find the nearest valid mob |

## Dates and versions

- Most reports are 1.16 to 1.19. Open ones that mention 1.20.1 or newer builds: #1483 (crows), #1877 (crows, 2024-08), #2021 (catfish, 2024-04), #2176 (pupfish chunk causes a TPS crash, updated 2025-11-25), #1567 (pupfish).
- Several mob-specific TPS issues (gorilla, bison, snow leopard: #1858, #1875, #1847, #1876, #2080) were closed on 2024-09-06, the date of Alex's Mobs 1.22.9, the last 1.20.1 build of the original.
- The maintained line for 1.20.1 is Alex's Mobs Continued 2.3.0 (2026-11-07, 380 k downloads, release channel, 39 Forge 1.20.1 builds; page says nothing was redesigned or rebalanced).

## Mitigations already in the pack (not measured)

Let Me Despawn (tweaks despawn rules), AI Improvements (performance improvements for vanilla AI), Immersive Optimization (entity tick scheduler).

## Same kind of report for the candidates

Strict title search (lag, TPS, MSPT, performance, freeze, spike, hang, deadlock, memory leak) over the first 200 issues of each repository in `gh_issues.md` (raw lists were kept in the scratchpad):

| Mod | Reports |
| --- | --- |
| Dungeon Difficulty | #36 open: server freeze loading one chunk region (structure checks); #53 closed: serious performance problems |
| Improved Mobs | #354 open: deadlock while saving |
| Mutant Monsters | #116 open: server TPS hang (2025-10) |
| The Hordes | #189 open: "1.20.1 TPS Fix"; two closed TPS reports |
| Scaling Health | #456 open: server lag with all blights |
| Cold Sweat | #671 closed (1.20.1 Forge, severe lag), #716 closed (chunk deadlock from structure checks), #677 and #557 closed (memory leaks) |
| IguanaTweaks Reborn | #319 and #330 closed: wall-collision code in MSPT |
| Sculk Horde | #41, #54 closed TPS reports; #117 closed suggestion to expire infection cursors |
| Majrusz's Progressive Difficulty | #124, #125, #81 closed (2022 to 2023): spawned groups pile up and lag |
| none found in the first 200 issues | L2Hostility, Champions, Tough As Nails, Homeostatic, Thirst Was Reclaimed, First Aid, Meet Your Fight (one 1.18 hang), Aquamirae, The Graveyard, Undead Nights |
| not readable | Cataclysm, Mowzie's Mobs (repository 403 or 404), Legendary Monsters, Born in Chaos, EEEAB's Mobs, No Mindless Shooting (no repository or 2 issues) |

An empty list means fewer reports, not a lighter mod.

# Coverage report

Status: provisional. The convergence test of the comparison method was only partly met (see "Gaps").

## Counts

| Round | Source types used | Relevant mods found | New relevant mods |
| --- | --- | --- | --- |
| 1 | Modrinth search, web search | 12 (Yeetus Experimentus, Disable Custom Worlds Advice, Hide Experimental Warning, Skip Backup Screen, Experimental Settings Disabler, Experimentalist, Here Be No Dragons, I Know What I'm Doing, DirectEntry, DeclutterUI, Shutup Experimental Settings!, No Worldgen Warning) | 12 |
| 2 | Modrinth (Forge + 1.20.1 filter), GitHub search, Exa on CurseForge, cfwidget | same 12 | 0 |
| 3 | READMEs, jars, local pack jars | plus Collective as a dependency of Hide Experimental Warning | 0 (1 dependency) |

The last two rounds added no new candidate.

## Result of the ledger

- 12 mods listed in `products.csv`, 4 researched in full (Forge 1.20.1 build exists and the function matches), 1 dependency researched (Collective), 7 excluded with a reason (wrong loader, no 1.20.1 build, or a different function).
- Evidence level of every researched product: downloads and dates measured; README claimed; source measured by reading. Nothing was run in the game.

## Gaps (why this is provisional)

- CurseForge has no search API that could be used here. CurseForge-only mods were found only through web search and aggregator pages, so a CurseForge-only candidate could be missing.
- The CurseForge page of Yeetus Experimentus could not be fetched, so its CurseForge downloads are unknown.
- No third, held-back inventory was available, so the spot check against an unused inventory was not done.
- `cfwidget` per-file counters differ strongly from Modrinth's (Hide Experimental Warning 1.2: 30,395 against 399,461). They were recorded but not used for the comparison.
- The Yeetus Experimentus and Experimentalist GitHub default branches do not hold the 1.20.1 Forge code, so for them the jar is the source of truth.
- Mixin targets were checked for existence in the Forge-patched 47.4.28 classes, not by launching the game.

## Corrections to earlier statements in this session

- Shutup Experimental Settings! was listed as a Forge 1.20.1 candidate. It has no 1.20.1 build.
- No Worldgen Warning was listed as a candidate. It silences a log message and does not touch the screen.
- Hide Experimental Warning was described as not covering the creation screen. Its own jar only has `LevelSummaryMixin`, but the creation-screen hooks are in Collective and are enabled when Hide Experimental Warning is loaded.

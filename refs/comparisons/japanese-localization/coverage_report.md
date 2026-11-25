# Coverage report

Status: provisional. The convergence test of the comparison method was not met (see "Gaps").

## Counts

| Round | Source types used | Relevant candidates found | New in the round |
| --- | --- | --- | --- |
| 1 | CurseForge page, vendor site, wiki, Modrinth API, web search | jtrans, Japanese Language Pack, Sodium 日本語訳, EUJT, Sodium Japanese Localization, MOD Japanese translation, AutoTranslation, craft-palette, ykpiece, Twister716, DEN2 | 11 |
| 2 | Modrinth API (597 unique projects), CurseForge pages through web search, site catalogues, articles | E.B.K.N. pack, suthibu, Mya's masady mods, More ja_jp, and the exclusions in `products.csv` | 4 relevant plus about 25 excluded (other mods' packs, Chinese tools) |
| 3 | AutoTranslation pages, GitHub search | AutoTranslation AI fork (yuefdev), Craft to Exile 2 pack | 1 relevant, 1 excluded |

The last round still added one candidate (the AutoTranslation fork), so the market list is not closed.

## Result of the ledger

- 16 candidates and 4 exclusion groups in `products.csv`.
- Researched with measurements: 3 (jtrans, Japanese Language Pack, their combination). AutoTranslation by page only. Others by catalogue text only (Bounded or Unverified).
- Evidence levels of the three measured ones: coverage measured (key level, against the 91 installed jars), maintenance measured (dates, counts), quality evaluated by my own reading (not independent), runtime risk read from the jar (inference, not run).

## Gaps (why this is provisional)

- CurseForge has no usable search here. CurseForge-only projects were found only through web search and aggregators, so a candidate could be missing.
- No second or held-back third-party inventory was available, so the spot check against an unused inventory (Step 7.2) was not done. The Minecraft Japan Wiki list was used in round 1, so it is not held back.
- Single-mod packs (craft-palette 342 packs, ykpiece 185 packs, Twister716, and others) were not downloaded or measured. Their catalogues were read only for names of the mods that remain uncovered after jtrans and Japanese Language Pack (Punchy! Moves, Remove Reloading Screen, Bedrockoid); no match was confirmed.
- Coverage counts key presence in `assets/<namespace>/lang/(en_us|ja_jp).json`. Patchouli books, quests, advancements and lang files nested deeper in jars (TaCZ default gun pack: official `ja_jp.json` exists, checked) were not counted.
- Nothing was run in the game: the performance cost and the load order of jtrans are inferences from the jar and from Mixin targets.
- jtrans values were read as unique value tables; the key-to-value index in the database was not decoded, so "same text as official" is by value set overlap, not by key.
- The jar of jtrans 1.9.1 differs from the site's "latest" (v1.9.0 on the guide page; CurseForge lists 1.9.1). The jar is the source of truth here.

## Corrections to earlier statements in this session

- The first search snapshot said jtrans supports 2,317 mods for 1.20.1; the live page now lists 3,268 and the jar has 3,533 namespaces for 1.20.1. The older number came from a cached copy of the site.
- Early reading of the jtrans jar suggested translations were plain `ja_jp.json` files. They are stubs that point to a database block (`JTD2`), decoded by a Mixin at load time.

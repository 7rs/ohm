# Coverage report (2026-11-24)

## Counts

| Item | Count |
| --- | --- |
| Rows of the community pack list | 75 data rows (sheet rows 6 to 81 without separators); 24 tagged "Cars" |
| Names in the IV CurseForge page pack list | about 60 |
| Modrinth search hits (Forge, 1.20.1) | 36 projects |
| Rows of `products.csv` | 34 IV packs (P01 to P35, with some grouped) + 4 standalone mods (N01 to N04) |
| Jars downloaded and scanned | 8 pack jars (GT CRAFT 2.1.2 and 2.0.1, KMW, Craftspeed, SVMP, R.A.G.E 3.0b2, OCP, OAmP) + the installed IV core |
| Finalists | 3 (GT CRAFT, KMW, Craftspeed) |

Rounds: round 1 the IV page list and the community list; round 2 the Modrinth search and web searches (added Sungradsk, New Cars, GAM, The Cars, Asphalt 8, Repair Car Pack, SaltyFish, Truckers Pack); round 3 the MetaMods list and the standalone-mod search (added Russian Dream and four standalone mods). A fourth round found no new 1.20.1 real-brand car pack. The skill's convergence test also asks for 3 independent inventories reconciled and a held-back one: done below.

## Reconciliation

- Every pack of the community list with the "Cars" tag is in `products.csv` (P01 to P05, P07, P09, P11, P22 to P26, P31) or in the grouped rows P21, P31, P35.
- Every 1.20.1 pack of the community list that is not tagged "Cars" and has no tag (IAV parts, Imperium, VEB IAV improved) is parts, a 1900s car or parts.
- Modrinth hits that are cars and not in the community list: Repair Car Pack (P10), SaltyFish Vehicle (P27), Truckers Pack (P28), Trin Civil Pack (P21). All were read through the Modrinth API.
- Held-back inventory (MetaMods list): New Cars (P12), GT CRAFT (P01), KMW (P02), VEB (P25), R.A.G.E (P05), Russian Dream (P34), OCP (P06), Vell's Modern Warfare (outside category). All are in the ledger.

## Evidence-level coverage of the finalists

| Pack | Measured | Evaluated | Claimed |
| --- | --- | --- | --- |
| GT CRAFT | vehicles, brands, dependencies, icons, recipes, language, releases | community list row | download counts, "43 models" text |
| KMW | same | community list row (not updated, abandoned) | download counts |
| Craftspeed | same | community list row | download counts, README text |

## Cut items

- Packs without a 1.20.1 build, with fictional brands, or outside the category were not scanned (reasons in `products.csv`). They stay in the ledger.
- Sungradsk RP Cars 90's (638.5 MB), Repair Car Pack, Blue Seoul, AVP, R.A.G.E 2.3 and The Cars were not downloaded (size or scope). Poker's Garage and Asphalt 8 Cars were not readable (CurseForge API 404).
- No scores or tiers: the candidates differ in kind (JDM depth against regional balance against catalogue size), and the strongest evidence for upkeep is a community list (Evaluated), not a measurement.

## Checks that failed or were limited

- The community list is a Google Sheet; the pack name column is mostly images, so names were taken from the download links.
- The `.class` and `jar` counts of the pack jars were checked: only `ForgePackLoader` stubs.

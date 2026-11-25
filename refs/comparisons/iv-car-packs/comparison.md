# Comparison: Immersive Vehicles content packs for JDM, American and European cars

Date: 2026-11-24. Status: **decided** (Craftspeed plus GT CRAFT, see the end). Completeness: the field was enumerated from three inventories (the community list of pack authors, the IV page list, a Modrinth search) plus web searches. It is not a crawl of all CurseForge projects, so unlisted packs may exist (see `00_scope.md`, `coverage_report.md`).

## Result

- Craftspeed is the only pack found that covers all three regions in a 1.20.1 build: 38 JDM, 18 American and 39 European vehicle definitions (20 of 97 are police liveries). It is still updated (4 releases in 2026), needs no other pack, and has cheap recipes. It is CurseForge only.
- GT CRAFT is the best JDM-only pack among the candidates: 42 JDM of 57, only 5 American and 9 European. It is still updated (3 releases on 2026-10-13 to 15), is on Modrinth, ships a Japanese language file, and needs the Official Content Pack (OCP). Its recipes are the most expensive (a GT-R takes 29 emeralds and 12 diamonds).
- KMW is the biggest catalogue (199 definitions, 180 cars: 107 JDM, 28 American, 29 European), but the pack authors' community list marks it "not updated, abandoned" (last release 2025-05-20), it is a 176 MB jar, CurseForge only, and needs OCP. It was built before IV 22.18, 23 and 24.
- No better JDM, American or European pack exists on the 1.20.1 community list. The rest is fictional-brand, not cars, 1.12.2/1.16 only, or on IV's crash list (New Cars).
- Standalone car mods (Kuruma, DragN's Valiant Vehicles, Ultimate Car Mod, [ST]Drive, Automobility) have no real-brand JDM, American or European sets, so they do not replace IV plus a pack.

## Fact table (1.20.1 builds)

| | GT CRAFT 2.1.2 | Kaminari Motor Works 2.6.1 | Craftspeed 1.7.5 |
| --- | --- | --- | --- |
| Platforms | Modrinth, CurseForge | CurseForge | CurseForge |
| File for 1.20.1 | multi-version jar (1.16.5 to 26.1), 52.5 MB | "16-20" jar (1.16.5 to 1.20.1), 176.3 MB | multi-version jar (1.16.5 to 26.1), 101.6 MB |
| Last release | 2026-10-15 | 2025-05-20 | 2026-08-08 |
| Pack authors' list (Evaluated) | not abandoned | not updated, abandoned | updated, not abandoned |
| Vehicle JSONs | 57 | 199 (180 cars) | 97 (20 police) |
| JDM / US / EU / other | 42 / 5 / 9 / 1 | 107 / 28 / 29 / 16 | 38 / 18 / 39 / 2 |
| Needs | IV 22.6.0 or newer; OCP | IV 22.6.0 or newer; OCP | IV only (1 horn sound is in OCP) |
| Item icons missing | 0 of 1,584 | 2 of 1,643 | 4 of 6,822 |
| Vehicles with a recipe | 57 of 57 | 192 of 199 | 84 of 97 |
| R34 GT-R recipe | iron 39, gold 60, diamond 12, emerald 29, OCP plating 36, screws 48, tube 12, hydraulics 3 | parts chain (unibody, engine, gearbox, suspension, wheels...) + OCP headlights and plastic + iron 72 | iron blocks 18, redstone 10, leather 5, glass panes 5 |
| Japanese language file | yes (ja_jp) | no | no |
| Jar entries | 6,173 | 9,088 | 31,724 |
| Authors' pros (Evaluated) | original models, detail, good physics | huge quantity, engine sound, best handling in IV | performance-friendly, customization, arcade-ish good handling, Discord support |
| Authors' cons (Evaluated) | very realistic, breaks the Minecraft look | high poly count; content removals | 1:1 scale, small bugs, weak instruments, unbalanced recipes |

Measured values come from the downloaded jars (`measurements.csv`). Region split is by the brand in the vehicle name, so police liveries and colour variants count as separate definitions.

## What the packs need

- GT CRAFT and KMW use OCP's crafting materials (plating, screws, plastic, headlights, circuits) and OCP's sounds: 55 of 56 and 11 of 11 external references resolve in OCP V29. Modrinth lists OCP as a required dependency of GT CRAFT, and the community list says KMW requires OCP. Without OCP their recipes cannot be crafted. OCP is 67.7 MB and brings 17 vehicles of its own (8 planes and helicopters, a tank, trucks and cars) plus the bombs, rockets and turrets named on the community list.
- KMW also references two sounds (gear shifts, 28 uses) of a pack `potatpacc` that is not installed.
- Craftspeed is self-contained. Its only OCP reference is one horn sound. IV core itself references one OCP sound.
- None of the pack jars holds code beyond one `ForgePackLoader` stub per pack id, so Mixin conflicts with the installed mods cannot occur. Conflicts with the pack come only from IV itself (see `refs/issues.md`).

## Excluded or not a fit

| Reason | Packs |
| --- | --- |
| No 1.20.1 build | Generic American Motoring, Dripler's Garage, Mackrel Automotive Industries, Poker's Garage (hiatus), GustNov's Motorsport, Cactus's Vehicle Pack, Sk8torad3's Simple Vehicles, Alice Motors, Imperium |
| On IV's crash list | New Cars (BeautyDriveHome). The IV page FAQ says packs labelled BeautyDriveHome or CMA must be removed for startup crashes. The match of New Cars to BeautyDriveHome rests on its Modrinth versions being named BDH. |
| Fictional brands or themed | UNU, Trin, Belroft, Mock GoGo, WayneTech Garage, Kadwin's Jurassic Park pack |
| Not cars or outside the three regions | military, aircraft, signs, decor, parts, buses, trucks, ground equipment, Blue Seoul (Korean), VEB (Soviet-era), Russian Dream |
| Scanned, small or unfinished | SVMP (48 definitions, no American cars, includes tanks), R.A.G.E 3.0 beta 2 (2 vehicles; the stable 2.3 was not scanned), OAmP (8 mostly fictional-name cars) |
| Not scanned | Sungradsk RP Cars 90's (638.5 MB, not on the community list; BMW E36/E38/E39/E46, VW Passat/Golf/Transporter, Mercedes W124, Skoda Octavia), Repair Car Pack (one car family: Lancer Evolution VIII), The Cars (feat. Ashminggu), Asphalt 8 Cars |

## Risks and unknowns

- Nothing was run. Whether each pack loads without errors on IV 24.0.0 with this pack's Embeddium, Oculus and Distant Horizons is untested. Shader fragility of IV is already recorded in `refs/issues.md`.
- KMW predates IV 22.18, 23.0.0 and 24.0.0. IV 23.0.0 changed part ordering and slot choice ("part order in internal lists align with JSON", "placed parts from choosing first slot defined over closest slot"). Whether that changes KMW's behaviour is unverified; GT CRAFT 2.1 and Craftspeed 1.7.5 were released after IV 24.0.0.
- A search snippet (third party, not on the pages read) said a GT CRAFT 2.0.x note warned that its suspension setter did not work on IV 23.0.0. GT CRAFT 2.1 replaced the suspension system.
- Craftspeed's jar README calls it an in-development version with possible missing icons, glitches and unwanted behaviour. 13 of its 97 vehicles have no recipe list (for example the AE86, 997 and AMG GT), so they cannot be built in survival through the bench.
- Entity and render cost of many detailed cars with Immersive Optimization and Entity Culling is untested (already recorded for IV).
- Download size (not measured in play): GT CRAFT 52.5 MB, Craftspeed 101.6 MB, KMW 176.3 MB, plus OCP 67.7 MB for GT CRAFT and KMW.
- The three packs overlap in models (R32/R33/R34, S13/S14/S15, AE86, Supra, Civic EK9, Evo, FD RX-7, GT-R R35). Installing two of them gives duplicates, not conflicts. The community list says GT CRAFT's parts "fit well" with KMW; no such statement exists for Craftspeed with GT CRAFT.

## Conditional recommendation

- All three regions, fewest dependencies, still maintained: Craftspeed.
- JDM depth and detail, Modrinth source, Japanese names, accepts OCP and the expensive recipes: GT CRAFT (adds OCP as a dependency).
- Largest catalogue, accepts an abandoned pack, a 176 MB jar and OCP: KMW. It is not the first choice on this evidence.
- If the user wants both depth and balance: Craftspeed plus GT CRAFT (OCP comes with GT CRAFT).

The decision belongs to the user. Adding any of them needs the project steps in `CLAUDE.md` (Modrinth first, side `both`, dependencies, settings, records).

## Decision

2026-11-24: the user chose Craftspeed plus GT CRAFT. Added: GT CRAFT 2.1.2 (Modrinth `gt-craft-ivmts`), Official Content Pack V29 (Modrinth `immersive-vehicles-official-content-pack`, pulled in by packwiz as GT CRAFT's required dependency) and Craftspeed 1.7.5 (CurseForge, file 8605108). All `side = "both"`. The metafile hashes equal the hashes of the jars analysed here. KMW was not added.

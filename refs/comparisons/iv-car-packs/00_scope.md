# Scope: Immersive Vehicles content packs for JDM, American and European cars

Date of research: 2026-11-24. Status: the user chose Craftspeed plus GT CRAFT (OCP came as a dependency). KMW was not added.

## Request

Immersive Vehicles 24.0.0 is installed and has no content pack (decided on 2026-11-24: "choose later"). The user now wants JDM, American and European cars and named two candidates, GT CRAFT [IV/MTS] and Kaminari Motor Works (KMW). They asked whether these are good and whether something better exists.

## Candidates named by the user

| Candidate | Where | What the page says |
| --- | --- | --- |
| GT CRAFT [IV/MTS] (VellEagle) | CurseForge `gt-craft-iv-mts`; Modrinth `gt-craft-ivmts` | 90's sports cars, "43 models / 57 variants", mostly JDM |
| Kaminari Motor Works [KMW] (Nax) | CurseForge `kaminari-motor-works` | Real-life cars with realistic drive characteristics and sound |

## Market definition

The market is the set of Immersive Vehicles (IV) content packs that add real-brand cars. Standalone car mods were checked only to see whether any of them replaces the IV plus pack route (see `comparison.md`). Packs only work with IV, and IV is already installed, so a pack is the unit of comparison. "No pack" is the baseline: IV alone has no vehicles, and the official pack (OCP) has few real-brand cars.

## Hard constraints

- A build for Minecraft 1.20.1 on Forge (project rule). IV 24.0.0 for 1.20.1 is installed.
- Real-brand cars of the three regions (JDM, American, European). A pack with only fictional-brand cars is outside the market, not a worse candidate.
- Not on the "remove it" list of the IV page (see `comparison.md`, New Cars).

Hard constraints stay the same for every pack. Preferences (survival crafting cost, scale, Japanese names) are shown as columns and not as filters.

## Evidence levels

| Level | What |
| --- | --- |
| Measured | Read from the downloaded jars: vehicle JSON count and brand split, declared and referenced dependencies, item icon references, recipe lists, file sizes, language files, code stubs. Release dates and file lists from the CurseForge and Modrinth APIs. |
| Evaluated | The pack authors' community list "A complete guide to Immersive Vehicles packs" (status, pros and cons, per-version support), written by IV pack authors. |
| Claimed | Pack pages (counts such as "43 models", feature lists), download counts, author text. |

No weights and no scores. The result is a fact table plus a conditional recommendation.

## Sources used for discovery

1. The pack list in the description of the IV CurseForge page (about 60 names).
2. The community list (Google Sheet linked from the IV page): 75 data rows (`data/community-pack-list.csv`, `data/approved-list.csv`).
3. Modrinth search, Forge and 1.20.1, four queries over three result pages: 36 projects (`data/meta/modrinth-iv-search.json`).
4. Web searches for JDM, American and European IV packs (CurseForge results).
5. The MetaMods add-on list of IV (held back and used as the Step 7 check).
6. A web search for standalone Forge 1.20.1 car mods.

## What was not done

- Nothing was run in the game. All findings are static readings of jars and web pages.
- A CurseForge crawl of all IV dependents was not done (the site is client-rendered and the API needs a key). Discord channels were not read.
- Whether IV 24.0.0 loads each pack without errors was not tested. Pack JSON keys were not checked against IV 24.0.0.
- Sungradsk RP Cars 90's (638.5 MB), Blue Seoul, Aero's Vehicle Pack, SaltyFish Vehicle, Repair Car Pack, R.A.G.E 2.3 (the stable 1.20.1 build) and the packs without a 1.20.1 build were not downloaded.
- Mixin conflicts do not apply: every scanned pack jar holds only a one-class `ForgePackLoader` stub per pack id and no Mixin config.
- Brand classification of vehicles is by the name in the pack JSON (first definition). Nismo, Efini and Mazda3 names were moved to JDM by hand. Police liveries count as separate vehicles.

## Scripts

`scripts/` (Bun with `fflate`): `packrefs.ts` (cross-pack references), `icons.ts` (item model texture references), `names.ts` (vehicle names), `recipes.ts` and `recipes-all.ts` (material lists). The jars were not kept.

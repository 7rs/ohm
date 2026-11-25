# Async Locator and the other locating mods (Forge 1.20.1)

Status: provisional. Research date: 2026-11-23. Nothing was run in the game; every behavior below comes from reading the jar and the platform pages.

Decision (2026-11-23, user): Async Locator was added to the pack.

## Headline

Async Locator is the only mod on Forge 1.20.1 that moves structure searching off the main thread. Risk is low (no dependency, no client code, hooks only vanilla locating code), but the effect is unmeasured and the 1.20.1 build is frozen at 2023-06. Reasonable to add if locate lag is a real problem; otherwise skippable.

## Fact table

| | Async Locator | BiomeSpy |
| --- | --- | --- |
| Approach | Runs the search asynchronously | Rewrites the search algorithm (author: 97% less time) |
| Covers | `/locate`, villager explorer maps, dolphin treasure, chest exploration maps, Eyes of Ender (jar mixins) | `/locate` and Nature's Compass (per its description) |
| Downloads, Modrinth (all versions) | 6,882,159 | 1,440,488 |
| Downloads, Modrinth (Forge 1.20.1 files) | 3,177,443 (1 file) | 1,295,881 (4 files) |
| Latest Forge 1.20.1 release | 1.20-1.3.0, 2023-06-22 | 1.3.3, 2026-01-19 |
| Repository | thebrightspark/AsyncLocator, 16 stars, last commit 2023-09-07 | MoePus/BiomeSpy (same author as installed Flerovium and CreateBetterFPS) |
| Side (Modrinth) | server required, client unsupported (singleplayer needs it too) | server required, client unsupported |
| Dependencies | none | none |
| Evidence of the effect | claim only | author's number only |

## Source, read (Async Locator jar 1.20-1.3.0)

- Mixins into `LocateCommand`, `EnderEyeItem`, `EyeOfEnder`, `TreasureMapForEmeralds` (villager trades), `ExplorationMapFunction` (loot), `DolphinSwimToTreasureGoal`, `SetNameFunction`, `Slot`, plus accessors. No `defaultRequire`.
- `displayTest = IGNORE_SERVER_VERSION`. No network API references in the jar.
- The platform text says other mods must integrate it to benefit, and lists Structure Essentials (CurseForge) as incompatible.

## Observations for this pack

- ModernFix `faster_structure_location` hooks `StructureCheck` and `ServerLevel`; Async Locator hooks the command, item and loot sites. Different classes, expected to coexist (not run).
- It would be `side = "both"`, like Immersive Optimization, so single-player worlds use it.
- BiomeSpy covers biomes. It is not a replacement for Async Locator and was not read.

## Excluded

| Mod | Reason |
| --- | --- |
| Nature's Compass, Explorer's Compass, Structure Compass | Items that use their own search; not lag fixes |
| Locate Fixer | Fixes a message; 2,482 downloads |
| Async Locator Refined | 1.21+ port |

## Coverage

- Market from Modrinth only.
- Evidence levels: downloads and dates Measured, hooks Measured by reading, effect Claimed.

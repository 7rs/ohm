# Quick Pack and the other pack loading mods (Forge 1.20.1)

Status: provisional. Research date: 2026-11-23. Nothing was run in the game; every behavior below comes from reading the jar and the platform pages.

Decision (2026-11-23, user): Quick Pack was added to the pack.

## Headline

Quick Pack is the best-evidenced and most active mod of its kind, but its gain in this pack is likely small: it speeds up zip packs read through `FilePackResources`, and the pack ships one zip resource pack (Fluid & Foolish). Mod jars and TaCZ gun packs do not go through that path (inference, not run). Low priority; add only if players load large zip packs.

## Fact table

| | Quick Pack | PackForge | 0Pack2Reload (installed) |
| --- | --- | --- | --- |
| Downloads, Modrinth (all versions) | 2,420,395 | 41,760 | 1,186,492 |
| Downloads, Modrinth (Forge 1.20.1 files) | 423,678 (9 files) | 2,156 (6 files) | not collected |
| Latest Forge 1.20.1 release | 1.5.2, 2026-11-20 | 1.4.2-beta.1, 2026-11-13 | not collected |
| Repository | DrexHD/quick-pack, 15 stars, last commit 2026-11-20 | Teenkung123/packforge | Nova-Committee/0Pack2Reload |
| Open issues | 1: #18 "Instant Reload conflict" (delays when moving around the world) | not checked | not checked |
| Side (Modrinth) | client and server optional | client required | not collected |
| Evidence of the effect | author's test: a 44.3 MiB zip with 60,369 entries loads in 2 s against 36 s in vanilla | claim only | n/a |

## Source, read (Quick Pack jar forge-1.5.2+1.20.1)

- Mixins (all `defaultRequire = 1`): `FilePackResourcesMixin` (wraps `ZipFile.entries()`), `FileResourcesSupplierMixin` (`FolderRepositorySource`, hands the opened zip and a list to `QuickPack`), accessors for `FilePackResources` and `SharedZipFileAccess`; client: `SpriteLoaderMixin` (wraps a sprite loading step; parallel mipmap generation), `LoadingOverlayMixin` (wraps `fadeIn`), `GuiMixin` (`TitleScreen.<init>(Z)`), `FontManagerMixin`, `FontSetMixin`.
- Config `quick-pack.json` with two keys: `removeLoadingOverlayFadeOut` and `parallelMipmapGeneration`.
- MixinExtras 0.5.3 is bundled through Jar-in-Jar (Punchy! Moves bundles MixinExtras too).
- No network API references in the jar.

## Observations for this pack

- The pack sets `mipmapLevels:0`, so `parallelMipmapGeneration` has nothing to do.
- ModernFix's `faster_texture_stitching` (on by default, read from the pinned jar) hooks `Stitcher`. Quick Pack hooks `SpriteLoader` and `FilePackResources`. These are different classes, so they are expected to coexist. Not run.
- Issue #18 names a mod called Instant Reload, which is not installed.

## Excluded

| Mod | Reason |
| --- | --- |
| PAXI | Loads packs from a folder; not a speed mod |
| ResourcePackCached | Keeps server resource packs cached for rejoin; different goal |
| Lightload, RDPL, Resource Reload Guard, Hot-Reload Resource Packs forked | Under 3,000 downloads, different goals or tiny |
| 0Pack2Reload, ModernFix | Installed |

## Coverage

- Market from Modrinth only. PackForge was listed from platform data only.
- Evidence levels: downloads and dates Measured, hooks Measured by reading, load time Claimed.

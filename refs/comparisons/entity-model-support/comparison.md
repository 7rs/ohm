# EMF, ETF, ESF and EntityModelShaderFix for the planned entity packs (Forge 1.20.1)

Status: provisional. Research date: 2026-11-23. Nothing was run in the game; every behavior below comes from reading the jars, the pack files and the platform pages.

Decision (2026-11-23, user): EMF, ETF (as the EMF dependency), EntityModelShaderFix and all six packs plus Melody's Cute Girl Traders were added. ESF was left out. Flerovium stays (glowing eyes accepted as lost). Pack order: Melody's Witches above Iron Girl, and the girl packs above Fresh Animations.

## Headline

- Needed: Entity Model Features (EMF) and Entity Texture Features (ETF). EMF requires ETF, so they come as a pair. Five of the six packs (all but Piglin-Chan) need them.
- Not needed by the packs' files: Entity Sound Features (ESF). The pack sounds are plain `.ogg` replacements. ESF requires both EMF and ETF.
- Worth considering because Oculus is installed: EntityModelShaderFix (brings ETF's shader patch to Oculus).
- CEM is a format, not a mod.
- Known risk: Flerovium (installed) breaks emissive entity textures from resource packs (Flerovium issue 56, open).

## Fact table: mods

| | EMF | ETF | ESF | EntityModelShaderFix |
| --- | --- | --- | --- | --- |
| Downloads, Modrinth (all versions) | 107,101,068 | 112,971,706 | 3,093,020 | 41,519 |
| Latest Forge 1.20.1 release | 3.3.12, 2026-10-15 | 7.2.7, 2026-11-03 | 0.8.2, 2026-09-01 | 1.2.0, 2026-10-26 |
| Side | client | client | client | client |
| Required mods | ETF 7.2 or newer | none | ETF 7.2 or newer, EMF 3.3 or newer | none (ETF, EMF, Oculus optional) |
| Adds | OptiFine CEM models and animations | Random, emissive, blinking textures, player skin features | Entity sound variation, sound utilities for ETF and EMF | Fix for ETF/EMF parts missing under Oculus shaders |
| Mixins | 282 classes: `ModelPart`, `ModelPart$Cuboid`, `EntityRenderer`, `GameRenderer`, `EntityRenderDispatcher`, player and banner and item frame renderers and others | 268 classes: `ModelPart`, `RenderType` multi-phase, `LevelRenderer`, `EntityRenderDispatcher`, skin texture and others | `ClientLevel`, `ResourceReload`, `SoundManager`, `WeighedSoundEvents` | `FullyBufferedMultiBufferSource`, wrapped `RenderType` (MixinExtras bundled) |
| Authors' note | Recommends Entity Culling (installed) for animation-heavy packs | n/a | n/a | The patch is in ETF but enabled only for Fabric with Iris |

All four use `defaultRequire = 1`.

## Fact table: packs (read from the zips)

| Pack | Version | Downloads | `pack_format` | What it changes | Needs |
| --- | --- | --- | --- | --- | --- |
| Fresh Animations | 1.11.2 | 52,876,394 | 15 (supported 15 to 75) | About 100 mobs through CEM (villager, iron golem, witch, pillager, vindicator, evoker, illusioner, ravager, wandering trader, zombie villager, piglin, piglin brute, zombified piglin and more) | EMF and ETF (author), Entity Culling recommended |
| Melody's Cute Girl Villagers | 1.11.1 | 73,713 | 10 (supported 10 to 9999) | Villager: 18 CEM models, about 2,300 random-entity files, blink textures, 4,067 files in total | EMF and ETF (author); ESF and Entity Culling recommended |
| Melody's Cute Girl Witches | 1.0.1 | 26,638 | 10 (10 to 9999) | Witch: 2 CEM models, biome random skins, blink textures, 12 sounds | EMF and ETF; ESF recommended |
| Melody's Cute Girl Illagers | 1.0.1 | 21,598 | 10 (10 to 9999) | Pillager, vindicator, evoker, illusioner: 4 CEM models, random skins | EMF and ETF; ESF recommended |
| Piglin-Chan | v2.0 | 113,157 | 15 | Piglin, piglin brute, zombified piglin: 3 textures only | none |
| Iron Girl | v2.0 | 38,325 | 32 (shows as made for a newer version on 1.20.1) | Iron golem CEM model and 7 sounds; also ships a `witch.jem` and a stray `iron_golem - copia.jem` | EMF and ETF |

## Overlaps between the packs (same file paths)

- Fresh Animations overlaps every other pack: villager (`villager.jem`, `villager.png`, `villager.properties`), witch (`witch.jem`, `witch.png`), pillager, vindicator, evoker, illusioner, piglin, piglin brute, zombified piglin textures, iron golem and witch models. The pack listed higher wins per file. Fresh Animations' own page says its extension packs go above it. Its page lists these mobs as animated, so the girl packs replace that animation for those mobs.
- Iron Girl's `witch.jem` and `cem/witch.png` collide with Melody's Cute Girl Witches. Whichever is higher decides which witch appears.
- `optifine/emissive.properties` is identical in all four packs that carry it (`suffix.emissive=_e`).
- Piglin-Chan's textures are 64x64 like Fresh Animations' piglin textures and models (`textureSize` 64x64). Whether the UV layouts match was not compared.

## Mob coverage of the six packs

- Covered: villager (all professions), witch, pillager, vindicator, evoker, illusioner, piglin, piglin brute, zombified piglin, iron golem.
- Vanilla neutral mobs are piglin, zombified piglin, iron golem, enderman, wolf, bee and similar. Villager and wandering trader are passive. Witch and illagers are hostile. So the list is village-related humanoids, not the neutral class.
- Not covered by the six: wandering trader (Melody's Cute Girl Traders exists, 16,366 downloads, has a 1.20.1 build, not read), zombie villager, ravager, vex, snow golem. Fresh Animations animates these with vanilla looks.

## Fresh Moves against Punchy! Moves

- Fresh Moves is a resource pack that animates the player model through EMF and ETF (original: 15,846,628 downloads, last update 2025-01-20, needs EMF 2.0.2 and ETF 6.0.1 or newer, plus skin transparency and "prevent first person hand animation" settings; Fresh Moves+ continuation: 9,858 downloads, 2026-09-20). It also adds face features through extra skin pixels.
- Punchy! Moves is a mod with its own animation engine and camera. It ships no animations; Fluid & Foolish (installed) supplies idle, walk, run, strafe, jump, fall, swim, fly, attack, mining and use actions.
- The body animation overlaps, but the engines differ. Both rewrite player poses, so running both is not advisable (inference; both hook the player model). Fresh Moves' face features have no counterpart in Fluid & Foolish's list.

## Observations for this pack

- Installed mods that also mix into `ModelPart`: Embeddium, Flerovium, Oculus, Punchy!, Punchy! Moves, ParCool, TaCZ, LR Tactical, Shoulder Surfing Reloaded, Optimized Block Entities, Xaero's Minimap. Into `EntityRenderDispatcher`: BadOptimizations, Chloride, Embeddium, Entity Culling, Oculus, Punchy!, Punchy! Moves. Same class does not mean conflict; nothing was run.
- Flerovium issue 56 (open, 2026-02-25): emissive mobs from resource packs do not work with Flerovium enabled on 1.20.1. The Flerovium author reproduced the loss of emission with only EMF, ETF, Embeddium and Oculus, and suspects a mixin priority below 500 on `ModelPart`. The Melody packs use `_e` emissive textures.
- EMF has open crash reports on 1.20.1 with mods that are not installed here (issue 159 The Hordes, issue 334 Straw Statues). Issue 337 was not read.
- The Melody Cute Girl Villagers page lists a known EMF bug: the level 5 profession texture shows for all profession levels.
- Colorwheel (installed) has a `FullyBufferedMultiBufferSourceMixin`, and EntityModelShaderFix has a `MixinFullyBufferedMultiBufferSource`. Their target classes were not compared.

## Excluded

| Mod | Reason |
| --- | --- |
| OptiFine | Not compatible with Forge mods such as Oculus and Embeddium; EMF states it is not compatible with it |
| MoreMcMeta, MoreMcMeta Emissive | Texture animation through OptiFine files; the packs' `anim` files are for OptiFine, and ETF handles blinking through `_blink` textures |
| Fresh Moves, Fresh Moves+, Fresh Animations Player Extension | Player animation overlaps Punchy! Moves |

## Coverage

- Market from Modrinth only. The packs were read from the latest version that lists 1.20.1.
- Evidence levels: downloads and dates Measured, pack contents and mixin targets Measured by reading, requirements and effects Claimed.

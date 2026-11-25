# Comparisons index

One-page summary of every comparison in `refs/comparisons/`. Read this first. Open a topic folder only when the evidence behind a result is needed. Install state was checked against `mods/`, `resourcepacks/` and `shaderpacks/` on 2026-11-25 (136 mod metafiles). Where the table here and a `comparison.md` differ, the later date wins; `refs/notes.md` holds the decisions made after each comparison.

## How to use

- Before adding, removing or replacing a mod, find its topic below. If a row covers the candidate, the comparison was done: do not redo it, and do not add the mod without the user's approval (see CLAUDE.md, Mod Addition).
- A result is a recommendation plus the user's decision. Status says which one holds now.
- Every comparison is provisional: research dates are 2026-11-22 to 2026-11-25 and nothing was run in the game. Facts come from reading jars, zips, source and platform pages. Evidence levels used in the files: Measured (counts, dates, hashes), Measured by reading (mixin targets, config keys, zip contents), Claimed (an author's statement), inference (reasoned, not checked).
- A "hard conflict" in the mixin scans means two mods hook the same call with `@Redirect` or `@ModifyConstant`, or one uses `@Overwrite` on a method the other hooks. Two plain injects on the same method are shared, not a conflict. A scan says nothing about behavior, registries or world generation.

## Folder layout

Each topic is `refs/comparisons/<topic>/`.

| File | Content |
| --- | --- |
| `comparison.md` | The result. Always present |
| `00_scope.md` | Question, market, criteria, weights |
| `products.csv`, `measurements.csv` | Ledger of candidates and measured values |
| `sources.md`, `coverage_report.md` | Sources and what was not covered |
| `gh_issues.md`, `gh_raw_*.txt` | Third-party problem reports |
| `scripts/`, `data/` | Scripts that collected the data and the raw extracts |

Topics with `comparison.md` only: `create-flywheel`, `enum-values-memory`, `flywheel-shader-compat`, `mixin-library`, `pack-format-warning`, `tacz-scope-shaders`.

## Overview

| Topic | Date | Outcome | Status |
| --- | --- | --- | --- |
| [borderless-fullscreen](#borderless-fullscreen) | 11-23 | Cubes Without Borders | Added |
| [boss-bar](#boss-bar) | 11-23 | Enhanced Boss Bars | Added |
| [item-rendering](#item-rendering) | 11-23 | Fast Items yes, Fast Item Frames no | Decided |
| [igpu-culling](#igpu-culling) | 11-23 | Opticores not recommended | Pending, not added |
| [opengl-context](#opengl-context) | 11-23 | ThreatenGL not recommended | Pending, not added |
| [shader-packs](#shader-packs) | 11-23 | Complementary Reimagined, BSL, then Mellow, I Like Vanilla, Solas | Added |
| [tacz-scope-shaders](#tacz-scope-shaders) | 11-23 | No mod fixes it; TACZ 1.2.0 untested | Pending |
| [entity-model-support](#entity-model-support) | 11-23 | EMF, ETF, EntityModelShaderFix and six packs | Added |
| [create-flywheel](#create-flywheel) | 11-23 | Create 6.0.8 (brings Flywheel) | Added |
| [flywheel-shader-compat](#flywheel-shader-compat) | 11-23 | Iris & Oculus Flywheel Compat: never add | Rule stands |
| [experimental-warning](#experimental-warning) | 11-22 | Yeetus Experimentus | Added |
| [pack-format-warning](#pack-format-warning) | 11-23 | NoPackCompatCheck or No Resource Pack Warnings | Pending, not added |
| [resource-loading](#resource-loading) | 11-23 | Quick Pack | Added |
| [structure-locating](#structure-locating) | 11-23 | Async Locator | Added |
| [leaf-decay](#leaf-decay) | 11-23 | Leaves Be Gone | Added |
| [enum-values-memory](#enum-values-memory) | 11-23 | Redirected clashes with Harium | Pending, not added |
| [mixin-library](#mixin-library) | 11-23 | MixinBooster: do not add | Pending, not added |
| [movement-rollback](#movement-rollback) | 11-23 | NoRollback does little; use a game rule | Pending, not added |
| [japanese-localization](#japanese-localization) | 11-24 | jtrans plus Japanese Language Pack | Added |
| [content-additions](#content-additions) | 11-24 | 19 content mods | Mostly added |
| [superb-warfare](#superb-warfare) | 11-24 | Superb Warfare | Added |
| [vehicles](#vehicles) | 11-24 | Five added, Valkyrien Skies held | Decided |
| [iv-car-packs](#iv-car-packs) | 11-24 | Craftspeed plus GT CRAFT | Added |
| [mob-difficulty](#mob-difficulty) | 11-24 | Simple Enemy, Enhanced Celestials 2, Clanging Howl | Added |
| [difficulty-mods](#difficulty-mods) | 11-25 | L2Hostility, Cold Sweat, Cataclysm, No Mindless Shooting | Pending, not added |

## Rendering and display

### borderless-fullscreen

- Question: a borderless fullscreen mode. Candidates: Cubes Without Borders (CWB), Fullscreen Tweaks, True Window. The first review missed that installed Chloride has its own borderless mode (`fullscreen.mode`).
- Result: CWB leads on every axis (30 M downloads, active, 5.0.0). It is opt-in per player.
- Decision 2026-11-24 (user): CWB in, with `fullscreenMode = BORDERLESS` and `useDelayedFullscreen = false` (shipped as `config/defaultoptions/extra/config/cwb.json`). Chloride stays with `fullscreen.mode = BORDERLESS`. With the delayed start off, vanilla `fullscreen` is already true when Chloride checks it, so the two do not fight. `fullscreen` is not set in `options.txt`.
- Open risk: Chloride resets `GLFW_DECORATED`, which may bring the title bar back (`refs/issues.md`). Fallback: remove CWB.
- Constraints: CWB wraps the same `GLFW.glfwWindowHint` call that ThreatenGL redirects; do not add both without a test. Excluded: Concentration (1.20.6+), Windows Titlebar Delete (declared incompatible), Fullscreeno.
- Not covered: CurseForge-only borderless mods.

### boss-bar

- Candidates: Enhanced Boss Bars, Refined Bossbars, Boss Bar Begone.
- Result and decision 2026-11-23 (user): Enhanced Boss Bars added. Client only, needs Cloth Config 11.1.136 (exact minimum, installed), one HUD mixin, designs for Aether and Twilight Forest bosses.
- Open: the default of `enhanced_boss_bars_enabled` was never read; check in the game. The author says all vanilla bars are replaced, so other mods' bars are affected.
- Excluded: mods that add bars for mobs, HUD and health-bar mods, timers.

### item-rendering

- Candidates: Fast Items, Fast Item Frames. Neither has independent measurements.
- Decision 2026-11-23 (user): Fast Items added (with MidnightLib). Fast Item Frames not added: it turns frames into blocks (mechanics change), needs Puzzles Lib (now installed for Leaves Be Gone) plus Forge Config API Port, and must be on the server too.
- Fast Items makes dropped items 2D by default (visual change).

### igpu-culling

- Candidate: Opticores (young aggressive suite, 1.1.2.5, about 3.6 k downloads for 1.20.1). Its only evidence is the author's 1.21.1 table on an Intel UHD laptop.
- Result: not recommended; pending the user. It duplicates Entity Culling, Chloride, Embeddium and the particle mods (entity, particle, item frame and leaf culling, chunk upload pacing). Its crash handler hooks `Minecraft.crash` and opens a GitHub issue URL, and crash hooks can hide the real error.
- Do not add: Particle Core, Cull Leaves, SE LeafCulling (overlap installed mods).

### opengl-context

- Candidate: ThreatenGL (requests an OpenGL 4.6 context; ForceGL20 goes the other way).
- Result: not recommended for the shared pack; pending the user. Benefit depends on each player's driver, nobody measured it, and it redirects `glfwWindowHint` in `Window.<init>` like Cubes Without Borders. A player may install it alone.
- Not checked: behavior of Distant Horizons, shader packs and Colorwheel on a 4.6 context.

### shader-packs

- Question: shader packs with shadows, reflections and a water surface on Oculus 1.8.0. 106 packs read, 54 ranked (gate: shadows, reflections and a water surface found in the code, and fit with Oculus 1.8.0).
- Rules from the user: only packs that support Distant Horizons (zip has `dh_*` programs; DH draws LODs only with such packs; 37 packs were left on that basis, `dh_ranking.md`). Lightness mattered (`lightness.md`).
- Top five under almost every weighting: Photon, Complementary Reimagined, Complementary Unbound, Solas, BSL. Complementary Reimagined and Unbound are one pack: the two r5.10 zips differ in one line (`SHADER_STYLE`). Add one only. Reimagined's default water has no waves; Unbound or "Reimagined + Waves" gives them.
- Decision 2026-11-23 (user): Complementary Reimagined r5.10 and BSL added, plus Colorwheel Patcher. BSL is pinned to 10.1 because the patcher lists exactly that version. Mellow, I Like Vanilla and Solas were added the same day. All client-only. No shader pack is selected at first launch.
- Colorwheel: official support counted as a plus, but Colorwheel 1.3.2 crashes when a pack with `shaders/colorwheel.properties` is selected and no Flywheel is installed. That is why Create was added (see create-flywheel).
- Ranked high but not added (the files give no reason; the user chose): Photon, Bliss, Lumina, Glimmer, Pegasus, Rethinking Voxels, MakeUp. Euphoria Patches is a mod project and was not compared.
- Same stack, open report: scope rendering with TACZ (see tacz-scope-shaders).
- Evidence: `final_scores.csv`, `features.csv`, `dh_ranking.md`, `lightness.md`.

### tacz-scope-shaders

- Problem: a TACZ scope with a shader pack and Distant Horizons shows a black band or rendering errors (TACZ issue 662, Oculus issue 797; out-of-memory with separate entity draws, TACZ issue 755, closed).
- Result: no mod fixes it and no config setting was found. Installed: TACZ 1.1.8-hotfix2, LR Tactical 0.4.3. Closest fix is TACZ 1.2.0 (2026-11-06) and 1.2.0-hotfix, which needs LR Tactical 0.4.4. Whether 1.2.0 clears the band is unknown. It is a content update and an add-on rejected earlier breaks on 1.2.x, so test in a scratch world. Simple Enemy, Combined Arms and Superb Warfare were checked only against 1.1.8-hotfix2 (see mob-difficulty). The user decides.
- Rejected: TaCZ:Accel (performance add-on, no claim of a fix), TACZ PIP (1.21.1 only), [TaCZ] Optimization (targets 1.1.8 `BulletHoleParticle`), CGC Compat: Shader (other gun mod), Shader Carry (Fabric, Carry On).

### entity-model-support

- Question: what the six entity resource packs need. Result: EMF plus ETF (EMF requires ETF) for five packs; Piglin-Chan needs nothing; ESF is not needed (the pack sounds are plain `.ogg`); EntityModelShaderFix is worth having because Oculus is installed.
- Decision 2026-11-23 (user): EMF, ETF, EntityModelShaderFix, the six packs and Melody's Cute Girl Traders added. ESF left out. Pack order: Melody's Witches above Iron Girl, girl packs above Fresh Animations. Flerovium stays; its loss of emissive (glowing) textures is accepted (Flerovium issue 56, open).
- Pack facts: Minecraft 1.20.1 reads only `pack_format`. Iron Girl (32) counts as too new, the Melody packs (10) as too old; Fresh Animations, Piglin-Chan, Fluid & Foolish are 15. Fresh Animations overlaps every other pack by file path; the higher pack wins per file.
- Excluded: OptiFine, MoreMcMeta, Fresh Moves and Fresh Moves+ (both rewrite player poses like Punchy! Moves).

### create-flywheel

- Problem: selecting a shader pack with `colorwheel.properties` crashed with `NoClassDefFoundError ... flywheel/api/material/Transparency`, because Colorwheel's shader hook runs without Flywheel (crash reports 2026-11-23).
- Candidates: Create 6.0.8 (carries Flywheel 1.0.5 as Jar-in-Jar), no mod (remove Colorwheel and Colorwheel Patcher; offered as the recommended option, not chosen), standalone Flywheel (none for 1.20.1 Forge), Create: Nowheel, Iris & Oculus Flywheel Compat.
- Decision 2026-11-23 (user): add Create 6.0.8 (`side = "both"`). Create's own config is not shipped.
- Not verified: Colorwheel's Flywheel backend with Embeddium 0.3.31, Flerovium and Oculus 1.8.0; mixin targets of Create against the other jars.

### flywheel-shader-compat

- Candidate: Iris & Oculus Flywheel Compat. Colorwheel 1.3.2 declares it `incompatible`. Never add it. (Ocuwheel was already checked on 2026-11-22; see `refs/notes.md`.)

## Startup, loading and world

### experimental-warning

- Candidates (hide the experimental-settings warning): Yeetus Experimentus, Experimental Settings Disabler, Hide Experimental Warning (needs Collective), Experimentalist (global feature toggles).
- Decision 2026-11-22 (user): Yeetus Experimentus added. Forge 47.4.28 has no config key for this warning. Yeetus and Experimental Settings Disabler both hook `confirmWorldCreation`: never install both. Yeetus also skips one more prompt when a world is loaded (probably the backup confirmation).
- Excluded: Shutup Experimental Settings (no 1.20.1 build), No Worldgen Warning (log message only), DirectEntry (1.21.1), Fabric-only and NeoForge-only mods.

### pack-format-warning

- Candidates (hide the "made for another version" label): NoPackCompatCheck, No Resource Pack Warnings (Forge port). Nothing added; pending the user.
- Baseline shipped now: the incompatible packs are listed in `incompatibleResourcePacks` in `options.txt` so the game keeps them enabled; the red label and confirm dialog remain. If either mod is added, remove that key.

### resource-loading

- Candidates: Quick Pack, PackForge, 0Pack2Reload (installed). Decision 2026-11-23 (user): Quick Pack added. Expected gain is small (the pack ships one zip resource pack). `parallelMipmapGeneration` does nothing because `mipmapLevels:0`.

### structure-locating

- Candidates: Async Locator, BiomeSpy. Decision 2026-11-23 (user): Async Locator added (`side = "both"`, so single-player uses it). The 1.20.1 build is frozen at 2023-06; effect unmeasured. BiomeSpy covers biomes and was not read.

### leaf-decay

- Candidates: Leaves Be Gone, Rapid Leaf Decay, Tree Harvester. Decision 2026-11-23 (user): Leaves Be Gone added with Puzzles Lib. Convenience, not optimization. Server side, so `side = "both"`.

### enum-values-memory

- Candidate: Redirected against installed Harium (`alloc.enum_values`). Result: do not add. Both redirect `Direction.values()` in at least two piston/redstone methods; two redirects on one call do not both apply, Harium has `defaultRequire = 1`, so the result depends on load order. Pending the user; the earlier decision (not to add) stands. A config-only fix (switching off Harium's group) was not checked.

### mixin-library

- Candidate: MixinBooster (swaps Sponge Mixin for Fabric's fork). Result: do not add. No installed Modrinth mod depends on it (72 checked; six CurseForge mods not checked) and the pack depends heavily on Mixin.

### movement-rollback

- Candidates: NoRollback, Too Fast, Im Fast. NoRollback's 1.20.1 path only sets `disableElytraMovementCheck`, which needs no mod: `/gamerule disableElytraMovementCheck true`. On-foot rollbacks would need Too Fast or Im Fast (unread), which turn off a vanilla anti-speed check on the server. Pending the user; nothing added.

## Localization

### japanese-localization

- Measured on 13,177 text keys, 56 namespaces, 91 jars: official `ja_jp` only 61.3 %; plus jtrans 1.9.1 90.7 %; plus Japanese Language Pack V57 86.2 %; both 98.1 % (251 keys left).
- Decision 2026-11-24 (user): both added. jtrans is a code mod that hooks text drawing (frame-time cost unmeasured), 52.7 MB, one author with fast churn. Japanese Language Pack is a resource pack with no code (covers Punchy!, AsyncParticles, Optimized Block Entities, Cubes Without Borders).
- Placement: jtrans `side = "client"` (packwiz marks it `both`), CurseForge source. Japanese Language Pack `pack_format` 15, enabled at first launch through the `resourcePacks` key (file name `AzukiV57.zip`; update the key when the name changes). A resource pack above jtrans wins per key.
- Not chosen: AutoTranslation (online translation, last 2023-12, unverified) and its fork, single-mod packs.

## Content and gameplay

### content-additions

- 19 content mods proposed 2026-11-24; a mixin scan against the installed mods found no hard conflict.
- Decision 2026-11-24 (user): added Waystones, 3D Skin Layers, Spawn Animations (mod jar, not the data pack), Deeper and Darker, Mekanism, Mekanism Generators, Create Crafts & Additions, Applied Energistics 2, Iron's Spells 'n Spellbooks, Botania, Zombie Awareness, End Remastered, True Ending (data pack wrapped as a mod), Touhou Little Maid, with their libraries (GuideME, GeckoLib, Iron's Lib, playerAnimator, Patchouli, CoroUtil). Second decision the same day: Vanilla Backport (with Platform), Almost Unified, Almost Unify Everything, TACZ-Sound Attracts Zombies, Superb Warfare (with Kotlin for Forge); Bedrockoid `fallenTrees = false` because Vanilla Backport also places fallen trees.
- Not added: Wither Storm (advised against: open reports match this stack, the boss vanishes with Distant Horizons #2505, distant render layers break with Oculus #2293), Ice and Fire (if ever: Community Edition `iceandfire-ce`, not save-compatible with the original; the original has only a beta and an open DH crash #5416), Ars Nouveau (Iron's Spells and Botania were chosen).
- Open risks: Botania shaders under shader packs (`useShaders`), AE2 with FastSuite (check with spark), Touhou Little Maid server crash on long-distance teleports (#1146; Waystones teleports are long-distance), Distant Horizons with new world generation, 20 mods at once make a crash hard to trace.

### superb-warfare

- Result and decision 2026-11-24 (user): added with explosion block destruction left on (`serverconfig/superbwarfare-server.toml` `explosion_destroy`, per world), plus Almost Unified and Almost Unify Everything (lead and steel overlap with Mekanism). Loader: Kotlin for Forge 4.12.0. Its TACZ links all resolve against TACZ 1.1.8-hotfix2.
- It is a second gun system next to TACZ; its real addition is vehicles and heavy weapons. 42 MB. Bundles Flywheel 1.0.5 and Ponder 1.0.91 (same as Create 6.0.8). Do not add GeckoAnimFix (declared incompatible).
- Open: Punchy! draws held items itself, so Superb Warfare guns may hit the same double-render fight as TACZ items; TaCZ gun in the offhand issue #181 (unconfirmed).

### vehicles

- Decision 2026-11-24 (user): added Immersive Vehicles, Immersive Aircraft, Create: Steam 'n' Rails, Man of Many Planes, Small Ships (all `side = "both"`). Held: Valkyrien Skies 2.4.11 (not recommended: open reports on exactly this stack, Distant Horizons and shader packs, Entity Culling and Immersive Optimization suspected, fixes only in the 2.5 playtest; revisit at 2.5; needs an add-on such as Eureka).
- Immersive Vehicles has no vehicles by itself: content packs are chosen in iv-car-packs. Shaders with its renderer are reported fragile.
- Open: Small Ships camera with Shoulder Surfing Reloaded's "replace default perspective" (issue #54); Immersive Aircraft and Small Ships have world-damage settings whose defaults were not read; Steam 'n' Rails with Flywheel backend and cased tracks (#768).

### iv-car-packs

- Question: Immersive Vehicles content packs for JDM, American and European cars. Field enumerated from three inventories plus web searches; not a crawl of CurseForge.
- Decision 2026-11-24 (user): Craftspeed 1.7.5 (CurseForge, the only pack covering all three regions: 38 JDM, 18 American, 39 European; cheap recipes) plus GT CRAFT 2.1.2 (best JDM pack, Modrinth, Japanese names, expensive recipes), with Official Content Pack V29 as GT CRAFT's required dependency. All `side = "both"`.
- Not added: Kaminari Motor Works (largest catalogue, 199 definitions, but abandoned since 2025-05, 176 MB, needs OCP). Not a fit: New Cars (on IV's crash list), fictional-brand and non-car packs. Craftspeed: 13 of 97 vehicles have no recipe list.
- Standalone car mods (Kuruma, Valiant Vehicles, Ultimate Car Mod, [ST]Drive, Automobility) have no real-brand sets.

### mob-difficulty

- Question: make enemies harder (gun enemies, zombie senses, elite mobs, blood moons, scaling).
- Shared fact: TaCZ bullets are indirect damage with one message id (`tacz.bullet`); each hit is split into `tacz:bullet` and `tacz:bullet_ignore_armor`. Anything that reduces indirect, projectile or physical damage works against guns.
- Decision 2026-11-24 (user): added Simple Enemy 0.1.6 (beta) and TaCZ Combined Arms, Enhanced Celestials 2 (Core, Default Lunar Events, Shader Support) with CorgiLib and Data Anchor, Clanging Howl 1.1.0, Guard Villagers 1.6.19. Zombie Awareness config: `wanderingHordes = true`, `awareness_Light_OnlyZombies = false`, `enhancedMobs` extended with spiders and illagers. Simple Enemy's village garrison is switched off (`config/sem-common.toml`, `general_settings.enableVillageGarrison = false`) because it would fight Guard Villagers' guards.
- On hold: Champions Unofficial (four default affixes work against guns, maintainer advises against it with True Ending, needs a shipped server config), In Control! (clashes with Champions on health). Not added: TaCZ NPCs (a second gun-enemy system), Enhanced Celestials 1.
- Constraints: one gun-enemy system only. Enhanced Celestials 1 and 2 never together (two event schedulers). Simple Enemy is beta; Combined Arms is locked to its version. Their TaCZ class references were checked only against TACZ 1.1.8-hotfix2; TACZ 1.2.0 can break TaCZ NPCs, Simple Enemy and Combined Arms.
- Open: Clanging Howl's 50 % damage resistance (day 100, removed by fire); meteor showers and blood moons both block sleeping; Enhanced Celestials 2 issue 258 (fairy spawns on the Fabric port) not tested on Forge.

### difficulty-mods

- Question: a mod that raises difficulty, four directions chosen by the user. 121-row ledger, 17 finalists, 119 candidate jars scanned against 135 installed (0 hard conflicts). A sample, not exhaustive.
- Result by axis (nothing added; pending the user):
  - Scaling: L2Hostility 2.5.19 (needs L2 Library and L2 Complements) is the best fit; its traits Adaptive, Reflect, Repelling, Dementor, Teleport, Undying work against bullets from level 100 to 150. Alternative Improved Mobs 1.13.7 (stats and behavior, no traits). Install at most one of L2Hostility and Champions. Shipping L2Hostility's data would need a data pack channel such as Open Loader.
  - Survival: Cold Sweat 2.4.5 plus one thirst mod (Thirst Was Reclaimed 3.0.5, or Homeostatic). TaCZ Bleeding on hold: the user will try it first (2026-11-25). First Aid turns natural regeneration off and keeps it off after removal; not wanted unless asked.
  - Content: Cataclysm 3.31 (70.5 MB; 97 entity types, 188 structure templates) first; lighter Mowzie's Mobs 1.8.2 and Legendary Monsters 2.2.4. Do not add Block Factory's Bosses (overwrite pair with AllTheLeaks).
  - Enemies: No Mindless Shooting 2.3.0 (TaCZ gunfire spawns mobs; stacks with Zombie Awareness and TACZ-Sound Attracts Zombies, silencer values must be set separately). Not recommended: TaCZ More Level, Insurgents, The Hordes, Undead Nights, Zombie Apocalypse Addon.
- Rules: never both Tough As Nails and Cold Sweat (both temperature); never both Thirst Was Taken and Thirst Was Reclaimed (same mod id `thirst`). Fabric-only jars appear in Forge listings (Custom Entity Attributes, Mob AI Tweaks, Mebahel's mods, Eldritch End): do not add. Alex's Mobs is heavy because of per-tick AI searches and unlimited populations, not content size.
- No installed difficulty mod was found that a candidate clearly beats. Staged adding is suggested: one axis, then measure in the same world.
- Evidence: `followup_alexsmobs_perf.md`, `content_counts.csv`, `mixin_conflicts.txt`.

## Statements in the comparisons that are out of date

- "Create is not installed" (create-flywheel, flywheel-shader-compat, igpu-culling): Create 6.0.8 was added 2026-11-23.
- "The pack has no `defaultconfigs/` folder" (mob-difficulty, difficulty-mods, superb-warfare): the folder exists now (CLAUDE.md, Structure). A global data pack channel is still not in the pack.
- "The Immersive Vehicles content pack is chosen later" (vehicles): chosen in iv-car-packs.
- "The pack's GeckoLib 4.8.5 wins over Superb Warfare's bundled 4.4.6" (superb-warfare, content-additions): it wins, and Superb Warfare 0.8.9.2 then crashes at launch on 4.8.5. The pack pins GeckoLib 4.8.4 (`refs/notes.md`, `refs/issues.md`).
- Jar and metafile counts (91, 111, 118, 124, 132, 135) are snapshots; 136 on 2026-11-25.

## Keeping this index current

- When a comparison is added, add its row, section and folder to this file in the same change.
- When the user decides (add, hold, reject), update Status and Decision here and the matching section of `refs/notes.md`.
- When a mod named here is removed, say so in its section.

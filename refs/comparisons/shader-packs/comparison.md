# Shader packs with shadows, reflections and a water surface (Oculus 1.8.0, Forge 1.20.1)

Status: provisional. Research date: 2026-11-23. Nothing was run in the game. Every effect below was read from the shader zips and the platform pages. Scope, criteria and weights: `00_scope.md`. Gaps: `coverage_report.md`.

Decision (2026-11-23, user): Complementary Reimagined r5.10 and BSL Shaders were added, and Colorwheel Patcher with them. BSL is pinned to 10.1 because the patcher lists exactly that version (`refs/notes.md`). The user also ruled that shader packs without Distant Horizons support are not wanted, and asked for lightness: see `dh_ranking.md` (37 packs left) and `lightness.md`. The TACZ scope problem has its own folder, `refs/comparisons/tacz-scope-shaders/`.

Correction after the third reply (2026-11-23, from the user's crash reports): "official Colorwheel support" counted as a plus (weight 15), but Colorwheel 1.3.2 crashes when a pack with `shaders/colorwheel.properties` is selected and no Flywheel (Create) is installed. Complementary Reimagined, Mellow, I Like Vanilla, Solas and the patched BSL all have that file. The criterion only helps once Create is in the pack; today it is a liability. See `refs/issues.md`, section Colorwheel.

Correction after the first reply: the Reimagined and Unbound zips are the same pack in the stricter sense that the one differing line, `SHADER_STYLE`, is the first entry of the shader's own options screen ("Visual Style"), so Reimagined with Visual Style set to Unbound is Unbound. Style-dependent defaults sit only in `common.glsl` (six references); `shaders.properties` and `en_US.lang` only list the option.

## Headline

- BSL Shaders is fine to add. It passes the feature gate with all five depth signals, ships 14 Distant Horizons programs, and is in tier S (91.1). It is the top pack when Colorwheel is left out of the score (96.6).
- Complementary Reimagined and Unbound are the same pack. The two r5.10 zips have 447 files each and differ in one line: `#define SHADER_STYLE 1` against `4` in `shaders/lib/common.glsl`. The style only changes default settings. Add one of them.
- 53 more packs pass the gate (54 ranked in total, one more, Reverie, was removed for needing Iris 1.8). The top of the ranking is stable across five weightings: Photon, Complementary (either style), Solas, BSL.
- Installed-mod facts that shape the choice: Distant Horizons only renders with shader packs that ship `dh_*` programs, and the pack plans Create (Colorwheel).

## BSL Shaders (the user's required pack)

| Item | Value | Evidence |
| --- | --- | --- |
| Release used | 10.1.8, 2026-09-21 (29 versions tagged 1.20.1 and Iris since 2023-09-09) | Modrinth API |
| Downloads | 32,268,054 | Modrinth API |
| Shadows | Shadow pass present, 43 shadow tokens. Options: realtime shadows, shadow map quality and distance, colored shadows, filtering, entity, block entity, vegetation, cloud and LOD shadows | zip |
| Reflections | 9 SSR/raymarch tokens, 284 reflection tokens. Options: reflection mode, translucent, rough, specular, rain puddles, LOD reflection, skybox | zip, `en_US.lang` |
| Water surface | `gbuffers_water` present; 29 refraction, 28 caustic and 11 wave tokens; refraction option | zip |
| Distant Horizons | 14 `dh_*` programs, LOD shadow and LOD reflection options | zip |
| Iris features | Optional only: `CUSTOM_IMAGES`, `FADE_VARIABLE`. Oculus 1.8.0 lacks `FADE_VARIABLE` (read from its `FeatureFlags` class), so that one stays off. Nothing is required that Oculus lacks | zip, Oculus jar |
| Colorwheel | Not official. Listed under Colorwheel Patcher as "BSL 10.1" (whether 10.1.8 is covered was not checked). Patcher is not installed | Colorwheel page |
| Performance tag | `low` (author) | Modrinth tag |

Known reports (Oculus tracker, searched for "BSL"): vanilla clouds missing (issue 355, 1.19.2; a commenter says the 1.20.1 build 1.6.9 fixed it), flickering white dots at block seams (issue 592; one commenter traced it to the mod Handcrafted, not installed here), and rendering errors with a TACZ scoped weapon on Oculus 1.8.0, Embeddium 0.3.31, Distant Horizons and TACZ, which is this pack's stack (issue 797, open, no reply: BSL keeps the errors until the shader is reloaded; Photon crashes after a few minutes). No report says BSL fails to load on 1.20.1. BSL has no public source repository; the author's site loads its feature and FAQ tabs by script, so only the zip was read.

Result: add. The one planning note is Create: with Colorwheel but without Colorwheel Patcher, BSL runs Create contraptions in fallback mode (rendering flaws).

## Complementary Reimagined against Unbound

Same code, different defaults.

- Both r5.10 zips (2026-11-18): 447 entries, 446 byte-identical, 1 different line (`shaders/lib/common.glsl` line 14: `SHADER_STYLE` 1 or 4).
- The complementary.dev page says "The only difference between these two styles is the default settings." Either style can be switched in-game (Shader Options, "Visual Style").
- Defaults that follow the style (read from `common.glsl` and `en_US.lang`):

| Setting | Reimagined (1) | Unbound (4) |
| --- | --- | --- |
| Water Style | Reimagined (vanilla-like water, no waves; "Reimagined + Waves" is a separate option) | Unbound (wavy realistic water) |
| Cloud Style | Reimagined | Unbound |
| Sun/Moon Style | Reimagined | Unbound |
| Sun/Moon Angle | 0 | -40 |
| Aurora Style | Reimagined | Unbound |
| Rainbow Style | Reimagined | Unbound |
| Glowing Ores | Off | On |

- Both carry shadows (27 shadow tokens), reflections (water and block reflect quality options), water (58 refraction, 24 caustic tokens), 14 Distant Horizons programs, and official Colorwheel files (`colorwheel.properties`, `clrwl_*`). Complementary lists Colorwheel support since r5.7.
- Because the water surface is one of the wanted features: Reimagined's default water has no waves. Pick Unbound, or set Water Style to "Reimagined + Waves", if wavy water is wanted by default.
- Shipping both adds 0.57 MB for no extra code. Ship one, and set the style through the shader's option file if the default needs to change (the option file name follows the zip name, so `packwiz update` can break it; not tested).
- Reports: Oculus issue 868 (open, 2026-08-12): sky wrong with Unbound on Oculus 1.8.0.1 and Embeddium 0.3.31, no log analysis, no reply. Issue 858 (open, 2026-04-09): enchantment glint items turn black with Reimagined and Unbound on Oculus 1.8.0 and Embeddium 0.3.31; the reporter says it also happens with shaders off, so it is probably not shader-specific.

## Ranking (all 54 packs that passed the gate and Oculus fit)

Scores come from `final_scores.csv`. S is 90 or more, A 80 to 89.9, B 65 to 79.9, C below 65. "Score without Colorwheel" drops the criterion and rescales, because the patcher and fallback lists are the Colorwheel author's statements.

| Tier | Pack | Downloads | Latest 1.20.1 release | Score | Without Colorwheel | Colorwheel | Perf tag (claimed) |
| --- | --- | --- | --- | --- | --- | --- | --- |
| S | Photon | 29.6 M | v1.4, 2026-10-19 | 97.3 | 96.8 | official | low/medium/high |
| S | Complementary Reimagined | 73.8 M | r5.10, 2026-11-19 | 94.8 | 93.9 | official | potato to high |
| S | Complementary Unbound | 48.1 M | r5.10, 2026-11-19 | 93.8 | 92.7 | official | potato to high |
| S | Solas Shader | 19.0 M | 3.9, 2026-11-02 | 91.6 | 90.1 | official | low/medium/high |
| S | BSL Shaders | 32.3 M | 10.1.8, 2026-09-21 | 91.1 | 96.6 | patcher | low |
| A | Lumina Shader - Event Horizon | 0.21 M | 1.4.0, 2026-11-17 | 86.5 | 84.1 | official | high/screenshot |
| A | Bliss Shaders | 16.0 M | 2.1.2, 2025-11-23 | 85.4 | 89.9 | patcher | low to high |
| A | Mellow | 8.3 M | 3.5, 2026-10-31 | 84.6 | 81.9 | official | potato |
| A | Pegasus Shaders | 0.97 M | 0.8.1, 2026-10-03 | 84.4 | 81.6 | official | potato to high |
| A | Glimmer | 0.57 M | 1.5.2, 2026-02-25 | 85.2 | 82.5 | official | low |
| A | Rethinking Voxels | 13.9 M | r0.1-beta9, 2025-06-20 | 82.9 | 86.9 | patcher | medium/high |
| A | Noble Shaders | 2.5 M | 1.9.9, 2026-09-29 | 82.4 | 89.9 | fallback tested | potato to high |
| A | MakeUp - Ultra Fast | 14.5 M | 9.6a, 2026-11-22 | 82.2 | 89.7 | fallback tested | potato/low/medium |
| A | I Like Vanilla | 3.0 M | v1.5.0b, 2026-10-07 | 82.0 | 78.9 | official | low/medium |
| B | 18 packs: Sildur's Vibrant, E-LITE, Spooklementary, Bloop, Visual Vibrance, Spring (Chun), Aurora Fantasy, Super Duper Vanilla, DERCODE, BSL Classic, Pyvtron Shaders, Hysteria, Fantasy Shaders Reimagined and Unbound, Vanilletix, ARTShade, Allium, Shrimple | | | 65 to 79.9 | | | |
| C | 22 more packs (see `final_scores.csv`) | | | below 65 | | | |

Sensitivity (top 10 under five weightings, rescored from `features.csv`; weights in the order depth, DH, Colorwheel, popularity, maintenance, fit):

| Weighting | Top 10 (score) |
| --- | --- |
| Base (25, 20, 15, 15, 15, 10) | Photon 97, Complementary Reimagined 95, Unbound 94, Solas 92, BSL 91, Lumina 86, Bliss 85, Glimmer 85, Mellow 85, Pegasus 84 |
| Equal | Photon 97, Reimagined 97, Unbound 95, Solas 93, BSL 90, Mellow 87, Lumina 85, Pegasus 85, I Like Vanilla 85, Bliss 84 |
| Feature-heavy (40, 30, 20, 0, 0, 10) | Lumina 100, Glimmer 100, Photon 100, then Bliss, Rethinking Voxels, Pegasus, Unbound, Solas, Reimagined, BSL at 92, Noble 88 |
| No Colorwheel | Photon 97, BSL 97, Reimagined 94, Unbound 93, Solas 90, Noble 90, Bliss 90, E-LITE 90, MakeUp 90, Rethinking Voxels 87 |
| Popularity-heavy (15, 10, 10, 35, 20, 10) | Reimagined 97, Unbound 94, Photon 94, BSL 90, Solas 89, MakeUp 82, Mellow 82, Bliss 81, Rethinking Voxels 77, I Like Vanilla 76 |

- The top five (Photon, Complementary Reimagined and Unbound, Solas, BSL) are the same set under every weighting except feature-heavy, where Lumina, Glimmer, Bliss, Rethinking Voxels and Pegasus reach the same 92 or more as the five.
- Positions 6 to 10 change with the weighting, so tier A is a group, not an order.
- The conclusion does not depend on claimed-only criteria: performance tags carry weight 0, and the "No Colorwheel" row removes the one criterion that rests partly on another author's statement.

## Notes on the finalists

- Photon (sixthsurge): SSR, soft shadows with variable penumbra, voxel colored lighting (needs Iris, which Oculus is a fork of), 16 DH programs, official Colorwheel files. Not for Apple GPUs. Open reports: DH terrain shows through water (issue 545) and DH water reflection visible through terrain (issue 383). Oculus tracker: a 1.20.1 crash after about five minutes with a TACZ weapon (issue 678, closed; the log was an out-of-memory error and the maintainer said it is not an Oculus bug), and the open TACZ scope report (issue 797, see above).
- Solas (Septonious): procedural waves, caustics, refraction, water reflections, colored lighting, 15 DH programs. 33 releases tagged 1.20.1. Oculus tracker: issue 772 open (Antique Atlas 4 map turns transparent), issues 705 and 703 closed. Solas's own tracker: the Oculus issues 116 and 75 are closed.
- Bliss (X0nk): an edit of Chocapic13 v9, 18 DH programs. Open reports on TACZ: all TACZ workbenches show odd reflections (issue 537), which matters because TACZ is installed. Patcher-only Colorwheel support (2.1.1 to 2.1.2).
- Rethinking Voxels (gri573): an edit of Complementary Reimagined with sharp block-light shadows; the newest build is still a beta (r0.1-beta9, 2025-06-20). Tagged medium/high/screenshot (claimed). Patcher-only Colorwheel support.
- MakeUp - Ultra Fast: tagged potato/low/medium (claimed), 12 DH programs, no caustic code. Tested by the Colorwheel author in fallback mode. Open issue 172: bubble columns and signs in water show the vanilla water texture.
- Glimmer: required features `CUSTOM_IMAGES`, `SSBO`, `SEPARATE_HARDWARE_SAMPLERS`, `BLOCK_EMISSION_ATTRIBUTE`, `HIGHER_SHADOWCOLOR` (all in Oculus 1.8.0); notes say Iris 1.6 or newer and no OptiFine. It was a false negative of the first water check (its water code sits in `lib/water/`, with no `gbuffers_water` program) and was added after that was fixed.
- Mellow, Pegasus, Lumina, I Like Vanilla, Glimmer: official Colorwheel files in the zip and DH programs. Lumina has 35 followers against 210,482 downloads and its first 1.20.1 release is from 2026-03-08, the youngest history of the group. The Oculus tracker search returned nothing for Lumina and Mellow; Pegasus and I Like Vanilla were not searched.
- Reverie was removed at the gate: its notes say "Iris 1.8 or higher" and Oculus 1.8.0 is Iris 1.7.0 parity. DERCODE's notes say 2.2 works on Oculus only with Oculus 1.8.0 (the pack has it).

## Facts about the installed pack that apply to every pack

- Oculus 1.8.0 `FeatureFlags`: `SEPARATE_HARDWARE_SAMPLERS`, `HIGHER_SHADOWCOLOR`, `CUSTOM_IMAGES`, `PER_BUFFER_BLENDING`, `COMPUTE_SHADERS`, `TESSELLATION_SHADERS`, `ENTITY_TRANSLUCENT`, `REVERSED_CULLING`, `BLOCK_EMISSION_ATTRIBUTE`, `SSBO`. Every required feature of all 106 packs is in this list. `FADE_VARIABLE` is missing and is optional in BSL, Complementary, Lumina, Just Colored Lighting and Reverie.
- Distant Horizons: its FAQ says shaders work only with Iris 1.7 or newer and only with shader packs built for DH. DH 3.3.2 added "the same Iris frame buffer depth fix to Oculus for MC 1.20.1". Packs without `dh_*` programs (for example Nostalgia, Kappa, Pastel, Insanity) are expected not to draw the LODs with the shader on (inference from the FAQ; not run). This is why DH support has weight 20.
- Oculus issue 797 (open, 2025-04-15, no reply): on Oculus 1.8.0 and Embeddium 0.3.31, a TACZ scoped weapon causes rendering errors at once; Photon then crashes after a few minutes and BSL keeps the errors until the shader is reloaded. The reporter used DH; the issue does not say whether DH is needed. The pack has this exact stack, so any shader pack should be tested with a TACZ scope.
- The pack ships `maxShadowRenderDistance=16` (chunks). Complementary's default `shadowDistance` is 192 blocks (12 chunks), so it is inside that limit.
- Colorwheel stays idle until Create is added. Packs that need Colorwheel Patcher (BSL, Bliss, Rethinking Voxels) would need it installed then.

## What adding a pack changes in this repository (not done)

- `packwiz modrinth add <URL>` files a shader under `shaderpacks/`. CLAUDE.md has no `shaderpacks/` entry in Structure and no rule for first-launch selection; both need a record when a pack is added.
- First-launch selection would be `shaderPack=<file name>` and `enableShaders=true` in `config/defaultoptions/extra/config/oculus.properties` (the file exists and holds `maxShadowRenderDistance=16`). The zip name changes with every `packwiz update`, so the key must be updated with it, as for `resourcePacks`.
- `refs/list.md`, `README.md`, `refs/settings.md`, `refs/notes.md` and `refs/issues.md` need entries per pack.
- Each shader is client-only. The server needs nothing.

## Excluded from the ranking

| Group | Count | Reason |
| --- | --- | --- |
| Fails the gate (no shadows, reflections or water surface found in the code) | 51 | 28 have no shadow pass at all (for example Vanillaa, CTR VCR, MC VHS, Bad Apple Shaders, Simple Saturation, PSX Shader). 23 have shadows but lack reflections or water code under the thresholds (Just Colored Lighting, Light Shaders, Eclipse, Sundial Lite, Sildur's Enhanced Default, Escheridia, Snowimagined, Epoch, Simply Upscaled, TrueLightFX Lite and others). Just Colored Lighting (15 reflection tokens) and Light Shaders (18) sit just under the reflection threshold of 20 and were not read by hand |
| Fails Oculus fit | 1 | Reverie (needs Iris 1.8 or newer) |
| Outside the user's market filter | 13 | 100,000+ downloads, but no Iris tag or no 1.20.1 tag: No Fog, Arc, ReShaded, Alpha Piscium, Musk Rose, Night Vision Shaders, YoFPS, Emissive Trims, Phoxel PT, Tea Shaders, Boosted Brightness, Creepers Reforged x FA, Fullbright |
| Not in the market (project type) | 1 | Euphoria Patches is a `mod` project on Modrinth (30 M downloads, forge loader, 1.20.1 tagged). It extends Complementary and Colorwheel lists it as officially supported since 1.7.0. It was not compared |

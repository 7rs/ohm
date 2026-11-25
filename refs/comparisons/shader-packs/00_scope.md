# Scope: shader packs with shadows, reflections and a water surface (Oculus 1.8.0, Forge 1.20.1)

Date of research: 2026-11-23.

## Market

Modrinth projects of type `shader`, as the user defined them:

- 100,000 downloads or more (project total).
- Iris loader tag (`categories:iris` in the search API).
- Tagged for Minecraft 1.20.1.
- Not reported as non-working on 1.20.1 (checked in the descriptions, version changelogs, and the GitHub trackers of Oculus and of the finalists).

Search API facets: `project_type:shader`, `versions:1.20.1`, `categories:iris`. Result: 730 projects, of which 106 have 100,000 downloads or more. Those 106 are the whole market for this comparison. CurseForge was not enumerated.

Installed context (read from `mods/`): Oculus 1.8.0 (Iris 1.7.0 parity, plus Distant Horizons 2.2 or newer fix), Embeddium 0.3.31, Distant Horizons 3.3.3, Colorwheel (idle until Create is added), CreateBetterFPS, EntityModelShaderFix. TaCZ and The Aether are installed. No shader pack is installed.

## Goal

1. Check whether BSL Shaders can be added as a required pack.
2. Explain the difference between Complementary Reimagined and Complementary Unbound.
3. Find the other shader packs that contain shadows, reflections and a water surface. Nothing was added. The decision is the user's.

## Comparison type

Product comparison with a hard feature gate, then a scored ranking. "No shader pack" is the baseline (vanilla lighting); it fails the gate by definition.

## Hard constraints (from the user)

- Contains shadows, reflections and a water surface (all three).
- Modrinth, 100,000 downloads or more, Iris, 1.20.1, no report of not working on 1.20.1.

## Feature gate (measured by reading the zip of the latest 1.20.1 Iris release)

The Modrinth tags `shadows` and `reflections` are author claims and have no water tag, so the gate reads the shader code instead.

- Shadows: a `shadow.fsh/vsh/glsl` program exists and the GLSL has 3 or more `shadowtex*`, `shadowcolor*`, `shadow2D*` or `sampler2DShadow` tokens.
- Reflections: 3 or more reflection options in `en_US.lang` or 5 or more SSR/raytrace/raymarch tokens, and 20 or more `reflection` tokens in the GLSL.
- Water surface: a `gbuffers_water` program or a water library file (`water/`, `wave*.glsl`) exists, and 5 or more wave tokens, 5 or more refraction tokens or 3 or more water options.

The thresholds are heuristics. The first water check required a `gbuffers_water` program; hand-checking Visual Vibrance, Glimmer and Sundial Lite showed that some packs draw water elsewhere, so the check was widened and the scan rerun (Glimmer and Visual Vibrance joined). The shadow check was read by hand for 12 packs near the threshold (the first rule missed shadow code in includes and was widened to `shadow2D` and `sampler2DShadow` tokens). Packs near the reflection threshold were not read by hand. The gate does not prove the quality of any effect.

## Criteria, weights and curves (weights were fixed before the first scoring run)

| Criterion | Weight | Evidence | Curve (0 to 100) |
| --- | --- | --- | --- |
| Feature depth | 25 | Measured by reading | 20 points each: shadow map, SSR/raymarch, refraction, wave, caustic |
| Distant Horizons support | 20 | Measured by reading | 100 if 2 or more `dh_*` programs, else 0 |
| Colorwheel (for the planned Create) | 15 | Measured (files in the zip) and Colorwheel's page | official 100, patcher 60, tested in fallback 40, fallback only 20 |
| Popularity | 15 | Measured | log10(downloads): 5.0 scores 0, 7.9 scores 100 |
| Maintenance | 15 | Measured | months since the latest 1.20.1 Iris release: 0 scores 100, 36 scores 0 |
| Oculus 1.8.0 fit | 10 | Measured and claimed | 0 if the author states a newer Iris is required, else 100 |
| Performance class | 0 | Claimed | Qualitative column only (Modrinth tags potato/low/medium/high) |

Reasons: Distant Horizons is installed and works only with shader packs built for it (Distant Horizons FAQ: Iris 1.7 or newer and shaders built with DH support in mind). Create is planned (CreateBetterFPS and Colorwheel are installed), so Colorwheel support matters. Performance has only author tags and no independent measurement, so it cannot decide.

## Tier rules

S: 90 or more. A: 80 to 89.9. B: 65 to 79.9. C: below 65. Round bands chosen when the first scores were seen; the weights were not changed afterward.

## What was not done

- Nothing was run in the game. No FPS, image quality or visual style was judged.
- `compare.py` was not run (no usable Python on this machine). The PowerShell scripts in `scripts/` (`enum.ps1`, `fetch.ps1`, `download.ps1`, `scan.ps1`, `score.ps1`, `ledgers.ps1`) produced every file here. `features.csv` is the raw scan and `final_scores.csv` the scores; the weights above reproduce them.
- Shader code was read as text patterns, not compiled.
- Issue searches covered the Oculus tracker and the trackers of Photon, Solas, Bliss, Complementary, MakeUp and Rethinking Voxels. Discord reports and CurseForge comments were not read.

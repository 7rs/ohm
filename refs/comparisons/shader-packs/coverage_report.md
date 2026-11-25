# Coverage report

Status: provisional. The result is complete for the market the user defined (Modrinth, Iris, 1.20.1, 100,000 downloads or more) and not for shader packs in general.

## Counts

| Step | Count |
| --- | --- |
| Modrinth shader projects with the Iris tag and the 1.20.1 tag | 730 |
| Of those with 100,000 downloads or more (the market) | 106 |
| Shader zips downloaded and scanned | 106 of 106 |
| Pass the feature gate (shadows, reflections, water surface) | 55 |
| Removed for Oculus fit (Reverie) | 1 |
| Ranked | 54 (S 5, A 9, B 18, C 22) |
| Fail the gate | 51 (28 without any shadow pass) |

## Convergence and snowball

The skill's snowball and convergence tests (rounds of company discovery) were not used. The market is a database filter set by the user, so discovery is one query set, not an open search. The three cross-check queries (any loader, any version, all shaders) were run instead. The 13 projects with 100,000 downloads or more that the user's filter drops are listed in `comparison.md` ("Outside the user's market filter"), plus Euphoria Patches, which is a `mod` project and never appears in a shader search.

## Reconciliation and spot checks

- Every one of the 106 market projects is in `products.csv` (status `researched` or `excluded` with a reason).
- Spot check of less familiar packs against the ledger: Lumina Shader - Event Horizon, Pegasus Shaders, Sundial Lite, Pyvtron VX, Butter Shaders are all present with scan rows.
- No inventory held back (no third-party inventory of shader packs was used). `compare.py audit` was not run.

## Evidence levels

| Item | Level | Coverage |
| --- | --- | --- |
| Downloads, release dates, version counts | Measured (Modrinth API) | 106 of 106 |
| Shadows, reflections, water, refraction, caustic, wave, DH programs, declared Iris features | Measured by reading the zip | 106 of 106 |
| Colorwheel support | Measured (files in the zip) for the 13 packs that ship Colorwheel files; the Colorwheel page's statements for the patcher and fallback lists | 106 of 106 (claimed part: patcher 3, fallback tested 7) |
| Oculus 1.8.0 supported features | Measured (class read from the jar) | Yes |
| Iris version required by the pack | Claimed (author notes in the descriptions and changelogs) | Searched for all 106; a version number was found for about a dozen |
| Problem reports | Measured (tracker search) | Oculus tracker for 10 pack names; the packs' own trackers for 6 |
| Performance class | Claimed (Modrinth tags) | 106 of 106, weight 0 |
| Visual quality, FPS | Not collected | None |

No product was cut by an upper-bound rule: every pack got the full code scan, so there is no Bounded group.

## Cut, skipped or weak

- Company dossiers and product cards with prices were not made (free packs by individual authors; no revenue data is meaningful here).
- Reflections and water were detected by token counts and file names, not by compiling the shaders or looking at screenshots. A pack can pass with a weak effect (for example a pack with sky-only reflections) or fail by naming (Visual Vibrance and Glimmer did, and were fixed after a hand check; a similar miss in the reflection check is possible for packs near the threshold: Just Colored Lighting, Light Shaders, Eclipse).
- The Colorwheel patcher list names versions ("BSL 10.1", "Bliss 2.1.1 - 2.1.2"); whether each pack's newest release is covered was not checked.
- The pack's actual DH setting, a TACZ scope and Create contraptions were not run with any shader pack.
- CurseForge and Discord reports were not read. A pack with only CurseForge or Discord problem reports would pass the "not reported" test here.
- `compare.py` was not run (no usable Python). Scoring and the weight sensitivity check were done with PowerShell (`scripts/score.ps1` and an inline loop; the five weightings are listed in `comparison.md`).
- The gate was changed twice after hand checks (shadow tokens widened, water library files added). The final run used the final rules for all 106 packs, and the scope file states them.

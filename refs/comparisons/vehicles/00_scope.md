# Scope: vehicles and transport proposed on 2026-11-24

Date of research: 2026-11-24. The user then decided: add five, hold Valkyrien Skies (see `comparison.md`).

## Candidates

The user pasted six Modrinth projects and asked whether they can be added to the pack ohm (Minecraft 1.20.1, Forge 47.4.28).

| Candidate | Modrinth slug | What it is |
| --- | --- | --- |
| Immersive Vehicles (formerly Minecraft Transport Simulator) | `immersive-vehicles` | A platform for cars and planes; the vehicles come from separate content packs |
| Immersive Aircraft | `immersive-aircraft` | Rustic aircraft |
| Create: Steam 'n' Rails | `create-steam-n-rails` | An add-on for Create's trains |
| Man of Many Planes | `man-of-many-planes` | An add-on of two aircraft for Immersive Aircraft |
| Small Ships | `small-ships` | Medieval-style ships with cannons |
| Valkyrien Skies | `valkyrien-skies` | A physics engine for moving blocks; a library that needs add-ons |

Added during the research (checked, not scanned in depth): Eureka! Ships! (the usual add-on of Valkyrien Skies), the Immersive Vehicles content packs on Modrinth (Official Content Pack, Official Automobile Pack), and the Small Ships Viking Addon.

## Goal

Decide, per candidate, whether it can join the pack and what it needs: libraries, settings and decisions from the user.

## Comparison type

Fit review, not a market comparison. The candidates are different features. "No mod" is the baseline for each. The installed baselines are Create 6.0.8 (trains), Superb Warfare 0.8.9.2 (tanks, aircraft and boats of its own) and vanilla boats. Other vehicle mods were not enumerated.

## Criteria

| Criterion | Evidence level |
| --- | --- |
| Forge 1.20.1 build, release channel, date, downloads, side, dependencies (Modrinth API, 2026-11-24) | Measured |
| Loader, required libraries, bundled libraries, content (`mods.toml`, `META-INF/jarjar`, language files) | Measured by reading |
| Mixin conflicts against 118 jars (the 111 installed ones plus the seven of the second batch) and among the six candidates: same class and method; for `@Redirect` and `@ModifyConstant` the same `@At` target (`scripts/targets.ts`; `conflicts3.ts` is in `refs/comparisons/content-additions/scripts/`) | Measured by reading; not run |
| Class linkage of Valkyrien Skies to Embeddium 0.3.31 and to Create 6.0.8 with its Flywheel 1.0.5, of Steam 'n' Rails to Create 6.0.8, of Man of Many Planes to Immersive Aircraft (`scripts/link.ts`; Create's nested Flywheel, Ponder and Catnip jars were unpacked and passed as targets; `scripts/targetcheck.ts` checks the classes the mixins target) | Measured by reading |
| Reported problems (GitHub issue search and reading of the six trackers, a Shoulder Surfing issue) | Claimed by third parties |

No weights or scores. The result is a fact table plus a conditional recommendation.

## Hard constraints

- A Forge build for Minecraft 1.20.1 must exist (project rule). All six have one.
- Libraries are installed only when a mod requires them (project rule).

## What was not done

- Nothing was run in the game. `refs/issues.md` records that nothing of the pack has been measured.
- Config defaults were not read. Only key names were read from the jars.
- Eureka, the content packs and the Small Ships addons were not scanned.
- The method-level check of `targetcheck.ts` is unreliable for methods that a mod overrides from Minecraft (the jars use SRG names there), so only its class-level result is used.
- GitHub's anonymous API rate limit stopped some reads at the end; two issues were read through a web fetch instead.
- Mixin scanning does not find behavior conflicts (two mods moving the same entity), registry clashes or world-generation overlaps.

## Scripts

`scripts/` holds the new scripts of this research (Bun with `fflate`, and PowerShell). `scan.ts`, `deps.ts`, `conflicts3.ts`, `q.ts` and the download scripts are in `refs/comparisons/content-additions/scripts/`. The jars were not kept.

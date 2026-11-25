# Scope: client rendering and culling optimization for weak GPUs (Forge 1.20.1)

Date of research: 2026-11-23.

## Market

Forge 1.20.1 client mods that cull or throttle rendering work. Modrinth searches (Forge, 1.20.1): `culling`, `integrated graphics`, `occlusion`, `rendering optimization`. CurseForge was not enumerated.

## Goal

Decide whether Opticores belongs in the pack ohm (Minecraft 1.20.1, Forge 47.4.28). Nothing was added. The decision is the user's.

## Comparison type

Product comparison between mods, plus the "no mod" baseline. Installed mods that already cover the area: Entity Culling (occlusion), Chloride (distance culling, leaf culling), Embeddium (frustum culling), Flerovium, ImmediatelyFast, Optimized Block Entities, AsyncParticles, Kerria, BadOptimizations, Dynamic FPS.

## Criteria

| Criterion | Evidence level |
| --- | --- |
| Download count (Modrinth, fetched 2026-11-23) | Measured |
| Release date, repository age and activity (GitHub API) | Measured |
| Author's benchmark and description | Claimed |
| Mixin targets, dependencies, behavior at crash (read from the jar with `javap`) | Measured by reading |

No weights, curves or tiers were given. `compare.py score` was not run. The result is a fact table plus a conditional recommendation.

## Hard constraints

- A Forge build for Minecraft 1.20.1 must exist (project rule).

## What was not done

- Nothing was run in the game. No FPS was measured.
- The alternatives other than Opticores were listed from platform data only; their jars were not read.

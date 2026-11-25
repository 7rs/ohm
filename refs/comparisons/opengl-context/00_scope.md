# Scope: OpenGL context version (Forge 1.20.1)

Date of research: 2026-11-23.

## Market

Forge 1.20.1 client mods that change the OpenGL context version the game requests. Modrinth searches (Forge, 1.20.1): `opengl`, `gpu driver`, `graphics driver`. CurseForge was not enumerated.

## Goal

Decide whether ThreatenGL belongs in the pack ohm (Minecraft 1.20.1, Forge 47.4.28). Nothing was added. The decision is the user's.

## Comparison type

Product comparison between mods, plus the "no mod" baseline: vanilla requests OpenGL 3.2 core. Installed rendering mods that depend on the context: Embeddium, Oculus, Distant Horizons, Ixeris, ImmediatelyFast, Flerovium, Colorwheel.

## Criteria

| Criterion | Evidence level |
| --- | --- |
| Download count (Modrinth, fetched 2026-11-23) | Measured |
| Release date, repository activity (GitHub API) | Measured |
| Author's claim of smoother gameplay | Claimed |
| Mixin targets, dependencies (read from the jar with `javap`) | Measured by reading |

No weights, curves or tiers were given. `compare.py score` was not run. The result is a fact table plus a conditional recommendation.

## Hard constraints

- A Forge build for Minecraft 1.20.1 must exist (project rule).

## What was not done

- Nothing was run in the game. No FPS was measured on any GPU.
- Interaction with Embeddium, Oculus, Distant Horizons and Ixeris at an OpenGL 4.6 context was not checked.

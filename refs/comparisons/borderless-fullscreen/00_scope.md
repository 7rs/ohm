# Scope: borderless fullscreen window (Forge 1.20.1)

Date of research: 2026-11-23.

## Market

Forge 1.20.1 client mods that add a borderless or windowed fullscreen mode. Modrinth searches (Forge, 1.20.1): `borderless`, `fullscreen`, `window mode`. CurseForge was not enumerated; Borderless Mining and Borderless Window are known from Cubes Without Borders' incompatibility list, not from a search.

This is a client quality-of-life feature, not an optimization. It was listed with the user's optimization candidates, so it was compared here as is.

## Goal

Decide whether Cubes Without Borders belongs in the pack ohm (Minecraft 1.20.1, Forge 47.4.28). Nothing was added. The decision is the user's.

## Comparison type

Product comparison between mods, plus the "no mod" baseline: vanilla fullscreen (exclusive) is available and the window size is a launcher setting (see `refs/settings.md`). The installed Chloride also has a borderless mode; this was missed when the research was done (see the correction in `comparison.md`).

## Criteria

| Criterion | Evidence level |
| --- | --- |
| Download count (Modrinth, fetched 2026-11-23) | Measured |
| Release date, repository activity (GitHub API) | Measured |
| Author's description (input latency, platform support) | Claimed |
| Mixin targets, config keys, incompatibility list (read from the jar with `javap`) | Measured by reading |

No weights, curves or tiers were given. `compare.py score` was not run. The result is a fact table plus a conditional recommendation.

## Hard constraints

- A Forge build for Minecraft 1.20.1 must exist (project rule).

## What was not done

- Nothing was run in the game. Windows behavior (cursor, focus, input latency) was not tested.
- Alternatives other than Cubes Without Borders were listed from platform data only.
- The config file name and the default value of `fullscreenMode` were not confirmed.

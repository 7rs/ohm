# Scope: boss bar visuals (Forge 1.20.1)

Date of research: 2026-11-23.

## Market

Forge 1.20.1 client mods that change how boss bars look or hide them. Modrinth searches (Forge, 1.20.1): `boss bar`, `bossbar`, `boss health`. CurseForge was not enumerated.

## Goal

Decide whether Enhanced Boss Bars belongs in the pack ohm (Minecraft 1.20.1, Forge 47.4.28). The user wants it as a visual addition. Nothing was added. The decision is the user's.

## Comparison type

Product comparison between mods, plus the "no mod" baseline: vanilla boss bars, which a resource pack can restyle only in part.

## Criteria

| Criterion | Evidence level |
| --- | --- |
| Download count (Modrinth, fetched 2026-11-23) | Measured |
| Release date, repository (GitHub API, Modrinth) | Measured |
| Which installed mods' bosses have designs | Claimed (author's mod list) |
| Mixin targets, dependencies, config keys, network use (read from the jar with `javap` and a byte scan) | Measured by reading |

No weights, curves or tiers were given. `compare.py score` was not run. The result is a fact table plus a conditional recommendation.

## Hard constraints

- A Forge build for Minecraft 1.20.1 must exist (project rule).

## What was not done

- Nothing was run in the game. The default values of the config keys were not read.
- Whether another installed mod mixes into `BossHealthOverlay` was not scanned across all jars.
- Refined Bossbars and Boss Bar Begone were listed from platform data only.

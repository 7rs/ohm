# Scope: structure and biome locating lag (Forge 1.20.1)

Date of research: 2026-11-23.

## Market

Forge 1.20.1 mods that make `/locate`, explorer maps, Eyes of Ender and similar searches asynchronous or faster. Modrinth searches (Forge, 1.20.1): `locate`, `structure locating`, `async structure`, `explorer map`. CurseForge was not enumerated. Structure Essentials (CurseForge, named by Async Locator as incompatible) was not enumerated.

## Goal

Decide whether Async Locator belongs in the pack ohm (Minecraft 1.20.1, Forge 47.4.28). Nothing was added. The decision is the user's.

## Comparison type

Product comparison between mods, plus the "no mod" baseline. ModernFix is installed and ships `perf.faster_structure_location` (`StructureCheckMixin`, `ServerLevelMixin`).

## Criteria

| Criterion | Evidence level |
| --- | --- |
| Download count (Modrinth, fetched 2026-11-23) | Measured |
| Release date, repository activity (GitHub API) | Measured |
| Author's description of the effect | Claimed |
| Mixin targets, dependencies, side (read from the jar with `javap`) | Measured by reading |

No weights, curves or tiers were given. `compare.py score` was not run. The result is a fact table plus a conditional recommendation.

## Hard constraints

- A Forge build for Minecraft 1.20.1 must exist (project rule).

## What was not done

- Nothing was run in the game. No locate time or tick time was measured.
- BiomeSpy's jar was not read.
- Whether Twilight Forest or The Aether use the vanilla locate paths was not checked.

# Scope: item entity and item frame rendering (Forge 1.20.1)

Date of research: 2026-11-23.

## Market

Forge 1.20.1 mods that make dropped items or item frames cheaper to render or tick. Modrinth searches (Forge, 1.20.1): `item entity`, `dropped item`, `item frame`, `2D items`, `item rendering`. CurseForge was not enumerated (no public search without an API key).

Mods that handle dropped items by merging or clearing them (Sweeper Maid, Staaaaaaaaaaaack, BetterDrop, ClearDrops, DarkTimer, Get It Together Drops, Echo Chest) change gameplay and entity counts, not rendering. They are a different goal and were not compared.

## Goal

Decide whether Fast Items and Fast Item Frames belong in the pack ohm (Minecraft 1.20.1, Forge 47.4.28). Nothing was added. The decision is the user's.

## Comparison type

Product comparison between mods, plus the "no mod" baseline: Entity Culling, ImmediatelyFast and Embeddium are installed, and ModernFix `mixin.perf.faster_item_rendering` is off by default (read from the pinned jar).

## Criteria

| Criterion | Evidence level |
| --- | --- |
| Download count (Modrinth, fetched 2026-11-23) | Measured |
| Release date, repository activity | Measured |
| Author's description of the effect | Claimed |
| Mixin targets, dependencies, side (read from the jar with `javap`) | Measured by reading |

No weights, curves or tiers were given. `compare.py score` was not run. The result is a fact table plus a conditional recommendation.

## Hard constraints

- A Forge build for Minecraft 1.20.1 must exist (project rule).

## What was not done

- Nothing was run in the game. No FPS was measured.
- Interaction with TaCZ item drops, Jade and Embeddium was not tested.

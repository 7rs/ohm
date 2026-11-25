# Scope: fast leaf decay (Forge 1.20.1)

Date of research: 2026-11-23.

## Market

Forge 1.20.1 mods that make leaves decay quickly after a tree is cut. Modrinth searches (Forge, 1.20.1): `leaf decay`, `leaves`, `fast leaf decay`. CurseForge was not enumerated.

This is a gameplay and quality-of-life feature, not rendering. It was listed with the user's optimization candidates, so it was compared here as is.

## Goal

Decide whether Leaves Be Gone belongs in the pack ohm (Minecraft 1.20.1, Forge 47.4.28). Nothing was added. The decision is the user's.

## Comparison type

Product comparison between mods, plus the "no mod" baseline. Installed and related: Chloride `leavesCulling = ALL` (render-side leaf culling, a different feature).

## Criteria

| Criterion | Evidence level |
| --- | --- |
| Download count (Modrinth, fetched 2026-11-23) | Measured |
| Release date (Modrinth) | Measured |
| Author's description | Claimed |
| Mixin targets, dependencies, side (read from the jars with `javap`) | Measured by reading |

No weights, curves or tiers were given. `compare.py score` was not run. The result is a fact table plus a conditional recommendation.

## Hard constraints

- A Forge build for Minecraft 1.20.1 must exist (project rule).

## What was not done

- Nothing was run in the game.
- The decay logic of Rapid Leaf Decay was not read beyond its class list.
- Compatibility with Twilight Forest and The Aether leaves was not tested.

# Scope: server movement checks and rubber-banding (Forge 1.20.1)

Date of research: 2026-11-23.

## Market

Forge 1.20.1 mods and datapacks that stop the server from rolling players back ("moved too quickly", "moved wrongly", elytra checks). Modrinth searches (Forge, 1.20.1): `rollback`, `rubber band`, `moved too quickly`, `movement check`. CurseForge was not enumerated.

## Goal

Decide whether NoRollback belongs in the pack ohm (Minecraft 1.20.1, Forge 47.4.28). Nothing was added. The decision is the user's. Which rollbacks the user sees (elytra, on-foot movement such as ParCool, vehicles) is not known.

## Comparison type

Product comparison between mods, plus the "no mod" baseline: a vanilla game rule.

## Criteria

| Criterion | Evidence level |
| --- | --- |
| Download count (Modrinth, fetched 2026-11-23) | Measured |
| Release date, repository activity (GitHub API) | Measured |
| Author's claim ("removes 99% of rollbacks") | Claimed |
| What the jar does on 1.20.1 (data files and mixin lists read from the jars) | Measured by reading |

No weights, curves or tiers were given. `compare.py score` was not run. The result is a fact table plus a conditional recommendation.

## Hard constraints

- A Forge build for Minecraft 1.20.1 must exist (project rule).

## What was not done

- Nothing was run in the game.
- The mixins of Too Fast and Im Fast were listed but their code was not read.
- ParCool and TaCZ interaction with the server movement check was not tested.

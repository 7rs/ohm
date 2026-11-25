# Scope: mods that hide the experimental-settings warning (Forge 1.20.1)

Date of research: 2026-11-22.

## Market

Client-side Forge 1.20.1 mods that suppress the vanilla "Experimental Settings" confirmation screens:

- the confirmation shown when a world is created (`WorldOpenFlows.confirmWorldCreation`)
- the confirmation shown when a world is loaded
- the confirmation in the datapack screen of world creation
- the experimental icon in the world list

## Goal

Pick a mod (or none) for the pack `ohm` (Minecraft 1.20.1, Forge 47.4.28) so that the experimental-settings confirmation at world creation no longer appears. Nothing was added to the pack. The decision is the user's.

## Comparison type

Product comparison between mods.

## Criteria (set by the user)

| Criterion | Evidence level |
| --- | --- |
| Download count | Measured (platform counters, fetched 2026-11-22) |
| Release date | Measured (platform metadata) |
| README, read concretely | Claimed (author text) |
| Source, read, summarised | Measured by reading (GitHub source and jar bytecode via `javap`) |

No weights, curves or tiers were given. `compare.py score` was therefore not run and no ranking score was computed. The result is a fact table plus a conditional recommendation.

## Hard constraints

- A Forge build for Minecraft 1.20.1 must exist (project rule).

Not a criterion: licenses (the user will check them later).

## Baseline: no mod

- `ForgeConfig$Client`, `ForgeConfig$Server` and `ForgeConfig$Common` of Forge 47.4.28 have no key for this warning (read with `javap` from `forge-1.20.1-47.4.28-universal.jar`). The universal jar only holds the warning icon texture.
- Installed mods already touching the topic:
  - ModernFix `mixin.bugfix.extra_experimental_screen` (`CreateWorldScreenMixin`): after world creation it marks a non-stable world as confirmed (`withConfirmedWarning(true)`, inferred from bytecode), so the warning is not shown a second time at first load. It does not remove the confirmation at creation.
  - The Aether (`WorldOpenFlowsMixin`, `CreateWorldScreenMixin`): only for its own menu background world (`WorldDisplayHelper.isActive`).
- Result: the creation-time confirmation can only be removed by adding a mod.

## What was not done

- Nothing was run in the game. Every statement about behavior comes from reading code, not from running it.
- The cause of the warning in this pack (which mod makes the lifecycle experimental) was not investigated.

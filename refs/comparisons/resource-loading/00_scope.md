# Scope: resource pack and data pack loading speed (Forge 1.20.1)

Date of research: 2026-11-23.

## Market

Forge 1.20.1 mods that speed up or avoid loading and reloading of resource packs and data packs. Modrinth searches (Forge, 1.20.1): `resource pack loading`, `zip loading`, `datapack loading`, `resource reload`. CurseForge was not enumerated.

## Goal

Decide whether Quick Pack belongs in the pack ohm (Minecraft 1.20.1, Forge 47.4.28). Nothing was added. The decision is the user's.

## Comparison type

Product comparison between mods, plus the "no mod" baseline. Installed mods that already touch the area: ModernFix (`faster_texture_stitching` is on by default, `dedicated_reload_executor`, dynamic resources off), 0Pack2Reload (skips reloads when the pack list did not change), Remove Reloading Screen.

## Criteria

| Criterion | Evidence level |
| --- | --- |
| Download count (Modrinth, fetched 2026-11-23) | Measured |
| Release date, repository activity, open issues (GitHub API) | Measured |
| Author's benchmark | Claimed |
| Mixin targets, config keys, dependencies (read from the jar with `javap`) | Measured by reading |

No weights, curves or tiers were given. `compare.py score` was not run. The result is a fact table plus a conditional recommendation.

## Hard constraints

- A Forge build for Minecraft 1.20.1 must exist (project rule).

## What was not done

- Nothing was run in the game. No load time was measured.
- The mixin list of ModernFix was read only in part (the output was cut), so overlap with Quick Pack's `FilePackResources` hooks is inferred, not proven.
- PackForge was listed from platform data only.

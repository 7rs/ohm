# Scope: entity model, texture and sound support for resource packs (Forge 1.20.1)

Date of research: 2026-11-23.

## Market

Forge 1.20.1 client mods that let resource packs replace entity models, textures and sounds in the OptiFine format (CEM, random and emissive entity textures, entity sounds). Modrinth searches (Forge, 1.20.1): `entity model`, `entity texture`, `entity sound`, `custom entity models`, `random entity`, `optifine`. CurseForge was not enumerated.

CEM (Custom Entity Models) is an OptiFine format, not a separate mod. The search `custom entity models` returned nothing. Entity Model Features implements it. OptiFine itself does not run beside Forge mods such as Oculus (EMF's page says EMF is not compatible with OptiFine).

## Goal

Find out which mods the planned resource packs need on ohm (Minecraft 1.20.1, Forge 47.4.28). The packs: Fresh Animations, Melody's Cute Girl Villagers, Melody's Cute Girl Witches, Melody's Cute Girl Illagers, Piglin-Chan, Iron Girl. Nothing was added. The decision is the user's.

## Comparison type

Fact table of the mods and of what each pack needs (read from the pack files), plus the "no mod" baseline: no mod means no CEM pack works. Also checked: Fresh Moves against the installed Punchy! Moves.

## Criteria

| Criterion | Evidence level |
| --- | --- |
| Download count, release date (Modrinth, fetched 2026-11-23) | Measured |
| Required mods and files of each pack (read from the downloaded zips) | Measured by reading |
| Mixin targets of the mods and of the installed mods (read from the jars) | Measured by reading |
| Authors' statements about requirements and effects | Claimed |
| Open issues (GitHub search) | Measured |

No weights, curves or tiers were given. `compare.py score` was not run.

## Hard constraints

- A Forge build for Minecraft 1.20.1 must exist (project rule).

## What was not done

- Nothing was run in the game. No FPS or visual result was checked.
- ESF's and EntityModelShaderFix's behavior comes from their mixin lists and pages; their code was not read.
- The UV layout of Fresh Animations' piglin model against Piglin-Chan's textures was not compared (both are 64x64).
- Pack order effects were derived from file overlaps, not from the game.

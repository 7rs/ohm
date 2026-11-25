# NoRollback and the other rollback mods (Forge 1.20.1)

Status: provisional. Research date: 2026-11-23. Nothing was run in the game; every behavior below comes from reading the jars and the platform pages.

Decision: pending (user).

## Headline

NoRollback does little on 1.20.1. Its Forge 1.20.1 file is a multi-version data pack, and the 1.20.1 path only sets the elytra game rule. That needs no mod: `/gamerule disableElytraMovementCheck true`. If the rollbacks the user sees are on-foot movement, Too Fast or Im Fast are the mods that act on it, at the cost of turning off a vanilla anti-speed check on the server.

## Fact table

| | NoRollback | Too Fast | Im Fast |
| --- | --- | --- | --- |
| Downloads, Modrinth (all versions) | 965,769 | 4,221,375 | 1,509,088 |
| Downloads, Modrinth (Forge 1.20.1 files) | 901,701 (5 files) | 1,407,671 (1 file) | 64,092 (1 file) |
| Latest Forge 1.20.1 release | 2.2.0, 2026-10-09 (one jar for Minecraft 1.14 to 26.3) | 0.4.3.5, 2024-05-25 | 1.0.2, 2025-02-27 |
| Repository | Solmeye/NoRollback, created 2026-10-09, 0 stars | none linked | Gabriel-Hiss/Im-Fast |
| Side (Modrinth) | client optional, server required | server required | server required |
| What it changes | Game rules through load functions | Mixin `MixinServerNetPlayHandler` (server) | Mixin `VelocityMixin` (server) |
| Dependencies | none | none | none |
| Evidence of the effect | author: removes 99% of rollbacks ("source: trust me") | claim only | claim only |

## Source, read (NoRollback jar 2.2.0+26.3)

- It is a data pack in a jar: one wrapper class, `pack.mcmeta` with `pack_format` 81 and `supported_formats` 4 to 81.
- Legacy directory `data/minecraft/tags/functions/load.json` runs `norollback:elytra`, which is `gamerule disableElytraMovementCheck true`. That is the only thing the 1.20.1 data pack format reads.
- The newer directory `data/minecraft/tags/function/load.json` runs `norollback:launch`, which schedules the same elytra function plus `gamerule disablePlayerMovementCheck true` and `gamerule elytra_movement_check false` / `gamerule player_movement_check false`. The singular `function` directory is the newer naming; Minecraft 1.20.1 reads `functions`, so these were not read as functions on 1.20.1 (from the directory layout and the pack-format rename; not run).
- The author's description says the pack makes cheating easier on a server.

## Observations for this pack

- The pack is installed on servers through packwiz, so a server-side change affects every player.
- Which rollbacks the user means decides the answer: elytra only (game rule), or on-foot and ParCool movement (Too Fast or Im Fast, unread).
- The game rule can also be set once per world with a command; Forge 47.4.28 has no config key for it.

## Excluded

| Mod | Reason |
| --- | --- |
| MythicalAC | An anticheat; the opposite goal |
| InvTools Inventory Rollback, PrismProtect, AquaGuard, Fiw Graves, Return by Death | Different meaning of "rollback" (inventory, block logs, death) |

## Coverage

- Market from Modrinth only.
- Evidence levels: downloads and dates Measured, jar contents Measured by reading, rollback removal Claimed.

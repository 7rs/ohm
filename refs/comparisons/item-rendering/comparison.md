# Fast Items and Fast Item Frames (Forge 1.20.1)

Status: provisional. Research date: 2026-11-23. Nothing was run in the game; every behavior below comes from reading the jars and the platform pages.

Decision (2026-11-23, user): Fast Items was added to the pack (with MidnightLib). Fast Item Frames was not added. Puzzles Lib is now installed for Leaves Be Gone, so Fast Item Frames would only add Forge Config API Port.

## Headline

Neither mod has an independent measurement of its effect. Both change what the player sees or builds, so they are not silent optimizations.

- Fast Items: only choice for 2D dropped items on Forge 1.20.1. Visual change by default (blocks become camera-facing sprites). Needs the library MidnightLib. The 1.20.1 build is from 2025-03.
- Fast Item Frames: only choice that turns item frames into blocks. Changes mechanics, needs Puzzles Lib and Forge Config API Port, and must be on the server too. Worth it only for builds with many frames.

## Fact table

| | Fast Items | Fast Item Frames |
| --- | --- | --- |
| Downloads, Modrinth (all versions) | 484,220 | 4,056,586 |
| Downloads, Modrinth (Forge 1.20.1 files) | 119,875 (1 file) | 1,219,183 (6 files) |
| Latest Forge 1.20.1 release | 1.1.0-forge+1.20.1, 2025-03-04 | v20.1.5, 2025-09-04 |
| Repository last push | 2025-03-03 (9 stars) | 2026-09-21 |
| Side (Modrinth) | client required, server unsupported | client and server required |
| Required libraries | MidnightLib 1.4.1 or newer (not installed) | Puzzles Lib 8.1.27 or newer, Forge Config API Port (neither installed) |
| Config | in-game toggles: enable, entity shadows, sides of 2D items, affect 3D models | not read |
| Evidence of the effect | claim only | claim only |

## Source, read

### Fast Items (jar 1.1.0)

- `ItemEntityRendererMixin`: at the head of `ItemEntityRenderer.render*` it draws the item itself and cancels the vanilla render (when `enable` is on). Block items get a camera-facing 3D shape when "affects 3D models" is on, which is the default.
- `ItemRendererMixin`: at the head of `ItemRenderer.render*` and a variable modifier that swaps in a flattened model for the GROUND display context.
- Both use `defaultRequire = 1`. Client only.

### Fast Item Frames (jar v20.1.5)

- Mixins into `ItemFrame` (the `survives` check and the dropped stack), `GlowItemFrame`, `HangingEntityItem` (wraps `Level.addFreshEntity` in `useOn`), `ItemFrameItem`, and the client `ItemFrameRenderer`. All use `defaultRequire = 1`.
- It registers an item frame block, a block renderer and a color capability (Puzzles Lib capability API).
- The platform text says frames become blocks and existing frame entities can be converted when chunks load (config). The conversion path was not read.

## Observations for this pack

- Entity Culling culls entities that are not visible (item frames and item entities included), and ImmediatelyFast optimizes immediate-mode drawing (author's description). Whether either new mod adds a visible gain on top of them was not measured.
- Interaction with the Embeddium and Oculus rendering paths was not tested.
- Adding both would add three libraries (MidnightLib, Puzzles Lib, Forge Config API Port).

## Excluded

| Mod | Reason |
| --- | --- |
| Sweeper Maid, Staaaaaaaaaaaack, BetterDrop, ClearDrops, DarkTimer, Get It Together Drops | Merge or clear drops (gameplay), not rendering |
| Echo Chest, Item Particles, ItemPhysic guns addon | Gameplay or cosmetic |
| Hide Item Frame, Invis Item Frame, ItemFramesPlus, Item Frament | Cosmetic or crafting changes to frames |

## Coverage

- Market from Modrinth only (Forge, 1.20.1). CurseForge-only mods are not covered.
- Source read from the jars of both mods. Repository code was not read.
- Evidence levels: downloads and dates Measured, mixin targets Measured by reading, performance effect Claimed.

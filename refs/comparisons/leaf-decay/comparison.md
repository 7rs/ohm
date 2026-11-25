# Leaves Be Gone and the other leaf decay mods (Forge 1.20.1)

Status: provisional. Research date: 2026-11-23. Nothing was run in the game; every behavior below comes from reading the jars and the platform pages.

Decision (2026-11-23, user): Leaves Be Gone was added to the pack (with Puzzles Lib).

## Headline

This is a convenience feature, not an optimization, and neither mod has performance evidence. If fast leaf decay is wanted:

- Leaves Be Gone: by far the most downloaded, but the Forge 1.20.1 build is from 2023-06 and needs Puzzles Lib.
- Rapid Leaf Decay: newer 1.20.1 build (2026-10-10), no mixin, no required library, far fewer downloads. Its logic was not read.

## Fact table

| | Leaves Be Gone | Rapid Leaf Decay | Tree Harvester |
| --- | --- | --- | --- |
| Downloads, Modrinth (all versions) | 13,689,994 | 100,504 | 7,826,239 |
| Downloads, Modrinth (Forge 1.20.1 files) | 2,625,743 (1 file) | 44,542 (2 files) | not collected |
| Latest Forge 1.20.1 release | v8.0.0-1.20.1-Forge, 2023-06-28 | 1.20.1-2.0.3, 2026-10-10 | not collected |
| Side (Modrinth) | server required, client unsupported | server required, client unsupported | not collected |
| Required libraries | Puzzles Lib 8.0.0 or newer (not installed) | none (a small Forge API jar is bundled by Jar-in-Jar) | not collected |
| Mixins | `ChunkSerializerMixin`, `LevelChunkMixin`, `ServerLevelMixin` (`defaultRequire = 1`, config plugin) | none | not read |
| Mechanism | Author: hooks the vanilla leaf decay, uses scheduled ticks, works through the `minecraft:leaves` tag | Decay queue with worker classes and a server config | Fells whole trees; fast leaf decay is a side feature |
| Evidence of the effect | claim only | claim only | n/a |

## Observations for this pack

- Leaves Be Gone would add Puzzles Lib, the same library Fast Item Frames needs.
- Rapid Leaf Decay avoids Mixin completely, so it cannot conflict through Mixin. It runs a queue of its own; behavior with modded leaves (Twilight Forest, The Aether) was not tested.
- Both are server-side. `side = "both"` would be needed so single-player worlds use them.

## Excluded

| Mod | Reason |
| --- | --- |
| Cull Leaves, SE LeafCulling | Render-side leaf culling; overlaps Chloride `leavesCulling = ALL` |
| Better Harvesting, FastLeafDecay | Better Harvesting is from 2023 and adds other features; FastLeafDecay targets servers (Bukkit family) with 10,295 downloads |
| Falling Leaves, Passable Foliage, Leaf Me Alone, Better Foliage Renewed | Cosmetic or collision changes |

## Coverage

- Market from Modrinth only.
- Evidence levels: downloads and dates Measured, mixin lists Measured by reading, effect Claimed.

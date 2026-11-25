# Benchmark: one mod at a time

Companion of [benchmark.md](benchmark.md), which holds the common rules, tools, test instance and the Run record. This file adds how to test a single mod, how to test mods that overlap, and the conditions each installed optimization mod needs.

Conditions below are test designs derived from each author's description and from `META-INF/mods.toml` of the pinned jars (read 2026-11-25). Nothing was run on the pack. If a target scene shows no gain, check the scene before blaming the mod. Anything marked `(unverified)` was not checked.

## Principle

- Most optimization mods speed up one part of the game. In a mixed scene that part is a small share of the frame or tick, and its gain falls under the noise. Build a scene where the part dominates.
- Every test has two scenes. Target: stresses the part, so the mod must win. Control: does not stress it, so the mod must show no gain. A loss in the control scene is the mod's own overhead; a gain there is noise or a side effect.
- Check the pack's own settings first. Some hide the target: `particles:2` (Minimal) hides particle work, `FAST` leaves hide Chloride's leaves culling, `mipmapLevels:0` hides mipmap cost. Override them in the test instance only and write the override in the Run record.
- A mod can be worth less in the pack than alone, because another mod already covers the same part. That is a result, not a failure.

## Methods

| Method | Variants | Shows | Weakness |
| --- | --- | --- | --- |
| M1 additive | Base instance against Base plus the mod (and its libraries in both) | What the mod does alone | A scale-dependent mod shows almost nothing in an empty instance |
| M2 subtractive | Full pack against full pack minus the mod | What the mod is worth in this pack, overlap included | Needs the whole pack; a gain can hide behind a mod that covers the same part |
| M3 group | Base, each mod alone, all together, each left out of all | Overlap and conflict between similar mods | 2 to 5 mods per group at most |
| M4 functional | Same scene, mod on and off | Same behavior and same picture | Needs a check written for the mod |

- Scale-dependent mods: FerriteCore (number of modded block states), ModernFix (number of mods), Quick Pack (number of files in zip packs), JEI/EMI Optimizations (plugins and recipes), FastSuite (recipe count), Jasione (call volume), AllTheLeaks (the leaks sit in other mods), Structure Layout Optimizer (structure size). Run M2 first and M1 second for them.
- Gain from M1 minus gain from M2 is the part of the mod's gain that other mods in the pack already provide.
- Always compute in milliseconds per frame (or per tick), never in FPS: savings add up in milliseconds, FPS does not. `ms = 1000 / FPS`.

### M3 group

For a group of mods A, B, C... and `t(x)` the median frame (or tick) time of variant `x`:

1. Run `t(base)`, `t(A)`, `t(B)`, `t(A+B)`. For three or more mods add `t(all)` and each `t(all minus X)`.
2. Single gain `gA = t(base) - t(A)`. Joint gain `gAB = t(base) - t(A+B)`. Interaction `I = gA + gB - gAB`.
3. `I` near 0 (inside the noise): independent. `I` clearly above 0: they cover the same part, so the second mod is partly redundant. `I` below 0: they help each other.
4. If `t(A+B)` is slower than `t(A)` or `t(B)` alone, it is a conflict. Go to M4 and read the log.
5. For three or more: marginal gain of X in the group is `t(all minus X) - t(all)`. A marginal gain far below `gX` means X is mostly redundant here.
6. A removal is only a candidate. Removing or replacing a mod follows the rules in [CLAUDE.md](../CLAUDE.md) and needs the user's approval.

## Base instances

New Prism instances, Minecraft 1.20.1, Forge 47.4.28. Copy `options.txt` from `config/defaultoptions/options.txt` and delete the `resourcePacks` and `incompatibleResourcePacks` lines (those packs are not in the base), then apply the benchmark keys of [benchmark.md](benchmark.md). Use the pinned file of each mod (`filename` and `url` in `mods/<slug>.pw.toml`).

| Base | Contents | For |
| --- | --- | --- |
| B0 | Forge, spark | Mods with no required dependency |
| B1 | B0, Embeddium 0.3.31 | Flerovium, Chloride, and Embeddium-dependent comparisons |
| B2 | B1, Oculus 1.8.0, one shader pack | Shader scenes |
| B3 | B2, Create 6.0.8 | Colorwheel, CreateBetterFPS |
| BS | Dedicated Forge server (README, Install on your server), spark, one idle client at the spawn | Server mods; MSPT |

- Put the libraries a mod needs into its baseline too, so only the mod differs.
- spark is in every variant, baseline included.
- Delete the copies when the test is done. They are cheap to rebuild from this file.

### Required dependencies (from the pinned jars' `mods.toml`)

| Mod | Needs | Notes |
| --- | --- | --- |
| Flerovium 1.2.19 | Embeddium | Modrinth lists no dependency; the jar requires it |
| Chloride 1.8.1 | Embeddium | |
| CreateBetterFPS 1.1.2 | Oculus, Embeddium | Create is optional |
| Colorwheel 1.3.2 | Oculus | Flywheel (inside Create), Colorwheel Patcher optional |
| Oculus 1.8.0 | none in the jar (Embeddium optional) | Modrinth lists Embeddium as required; use B1 |
| Fast Items 1.1.0 | MidnightLib | |
| Let Me Despawn 1.26.11.1 | Almanac, DungeonConfig | Modrinth lists only Almanac |
| Structure Layout Optimizer 1.0.12 | Resourceful Config | |
| FastWorkbench 8.0.4, FastFurnace 8.0.2, FastSuite 5.1.2 | Placebo | |
| Leaves Be Gone 8.0.0 | Puzzles Lib | |
| ModernFix 5.27.91 | none (JEI optional) | |

No other optimization mod of the pack declares a required dependency. Solix, AllTheLeaks and JEI/EMI Optimizations come from CurseForge and their jars were not read.

## Building scenes

- Blocks: `/fill`, at most 32,768 blocks per command. Examples: `/fill ~ ~ ~ ~15 ~3 ~15 minecraft:chest` (1,024 chests, a block entity each), `/fill ~ ~ ~ ~31 ~15 ~0 minecraft:magma_block` (an animated wall).
- Entities: a function in a data pack that lives in the test world copy, not in the pack (`<world>/datapacks/bench/pack.mcmeta` with `pack_format` 15, and `data/bench/functions/spawn.mcfunction`). Not run:

  ```
  summon minecraft:item ~ ~ ~ {Item:{id:"minecraft:cobblestone",Count:1b},PickupDelay:32767,Age:-32768}
  scoreboard players remove #n bench 1
  execute if score #n bench matches 1.. run function bench:spawn
  ```

  Then in the game: `/reload`, `/scoreboard objectives add bench dummy`, `/scoreboard players set #n bench 500`, `/function bench:spawn`. `PickupDelay:32767` and `Age:-32768` stop merging and despawning. Change the first line for mobs (`{NoAI:1b}` freezes their AI) or XP orbs.
- Count entities: `/execute if entity @e[type=minecraft:zombie]` prints `Test passed, count: N`. `/forge entity list <filter>` (permission 2) lists by type.
- Pregenerate on a server: `/forge generate <pos> <count> [dim] [interval]` (permission 4).
- A scene that generates chunks changes the world. Use a fresh world copy per run.

## Conditions per mod

Pinned versions are in the Mod column. "Server" scenes run on BS (or the integrated server, noting that the client adds load). Metric names follow [benchmark.md](benchmark.md): frame time for the client, MSPT for the server.

### Client rendering

| Mod | Needs | Target scene | Control scene | Metric |
| --- | --- | --- | --- | --- |
| Embeddium 0.3.31 | none | Terrain view at render distance 8 and 16, shaders off; fly 200 blocks into new terrain for chunk rebuilds | Render distance 2 | Frame time; spark `--thread *` for the chunk builder threads |
| Flerovium 1.2.19 | Embeddium | Three scenes: 500 dropped items in view; particles with `particles:0`; 200 `NoAI` mobs | Empty field, same view | Frame time; spark Render thread, item, particle and entity render frames |
| ImmediatelyFast 1.5.5 (the 1.20.4 Forge build) | none | CPU-bound view: many entities, 1,000 chests, many particles, signs and chat text, maps in item frames; shaders off, low resolution so the GPU is not the limit | Empty field | Frame time. The author says it helps only when the CPU is the limit |
| Kerria 1.3.2 | none | A wall of animated blocks in view (magma block, sea lantern, prismarine), Embeddium "Animate Only Visible Textures" off | A wall of stone | Frame time; spark Render thread, texture upload |
| Optimized Block Entities 1.2.1-patch.3 | none | 1,000 chests, shulker boxes, beds, signs and banners in view, closed; then opened or animated | No block entities | Frame time |
| Entity Culling 1.11.3 | none | 100 entities and 200 chests behind opaque walls, viewed from outside | The same entities in the open | Frame time; F3 `E:` counter |
| Chloride 1.8.1 | Embeddium | One feature per scene. Distance culling: 200 entities at 70 to 120 blocks, `culling.entityDistanceX` default 4096 against the pack's 16384. Fast Chests and Beds: 1,000 chests or beds, on and off. Leaves culling: Fancy leaves forest (the pack ships Fast leaves, where it does nothing). Language reload: switch language, read the log | Same scene with the feature off | Frame time; log timestamps for the language reload |
| AsyncParticles 20.1.4.4 | none (Cloth Config optional) | `particles:0`, many campfires, fireworks or TNT explosions | `particles:2` (the pack default) | Frame time; spark `--thread *`, `ParticleEngine.tick`. It asks in chat to apply recommended settings: write down what was applied |
| BadOptimizations 2.4.1 | none | Standing still by day in a uniform biome, so the lightmap and sky color do not change | A scene where brightness changes every tick, for example the flashing end of a Night Vision effect (`unverified`) | Frame time; spark Render thread, lightmap update and sky color (method names `unverified`) |
| Fast Items 1.1.0 | MidnightLib | 1,000 dropped items in view | No item entities | Frame time |
| Gnetum 2.5.1 | none | Full HUD: several effects (`/effect give`), a 15-line scoreboard sidebar, boss bars, a full chat, the HUDs of TaCZ and Jade | HUD hidden with F1 | Frame time; spark Render thread, `Gui.render` |
| Ixeris 4.6.11 | none | Windows, mouse polling at 1,000 Hz or more, mouse grabbed and kept in constant motion for the whole capture (a tool that sends constant relative motion; a hand is not repeatable); also the cursor moving over a menu | Mouse still | Frame time. Not tested with Key Binding Patch, Controlling, TaCZ, Punchy ([refs/issues.md](../refs/issues.md)) |
| GPUBooster 1.0.5.1 (Forge) | none | The pack notes call this build a VRAM leak fix: dedicated GPU memory after 10 resource reloads (`F3` + `T`) and world re-joins; frame time in a CPU-bound scene | The same steps without it | Task Manager dedicated GPU memory or `nvidia-smi`; frame time. Its page says RBO does not work with shader packs, OpenGL below 4.5 loses features, and the vectorization part needs `--add-modules jdk.incubator.vector` (that part is for newer Minecraft: whether 1.20.1 needs the argument is `unverified`) |
| Distant Horizons 3.3.3 | none (Oculus optional) | Equal view distance: render distance 32 against render distance 8 plus LOD radius 64 (the pack), LODs finished, shaders off | none | Frame time; spark `--thread *` for the LOD threads |
| Dynamic FPS 3.11.4 | none (Cloth Config optional) | Not a speed-up: it lowers use when the window is unfocused, hovered, invisible or idle. Leave the window unfocused 60 seconds | Focused window: must show no change | CPU time of `javaw.exe` (`Get-Process`) and GPU use in Task Manager |

### Create and shaders

| Mod | Needs | Target scene | Control scene | Metric |
| --- | --- | --- | --- | --- |
| Colorwheel 1.3.2, Colorwheel Patcher 1.0.5, CreateBetterFPS 1.1.2 | B3 (Create 6.0.8, Oculus, Embeddium) plus a shader pack | A large Create contraption in view (many cogs, belts, machines) with the shader on. Variants: Create, plus Colorwheel, plus CreateBetterFPS, plus both. Also Flywheel's backend `instancing` against `indirect` (`unverified` where it is set) | The same shader with no contraption; the same contraption with shaders off | Frame time. Both help only with a shader pack on ([refs/notes.md](../refs/notes.md)) |

### Server tick, entities and AI

| Mod | Needs | Target scene | Control scene | Metric |
| --- | --- | --- | --- | --- |
| Immersive Optimization 0.2.0 | none | 300 mobs with AI spread over 16 to 128 blocks from a player who stands still, plus a small farm | A few mobs | MSPT median and 95th percentile; spark server profile; the farm's output count must stay equal (M4) |
| AI Improvements 0.5.2 | none | 100 zombies chasing a player in a walled arena; 200 animals in a pen | A few mobs | MSPT; M4: the zombies reach the player in the same time |
| Harium 2.0 | none | One scene per category: a chain of 500 hoppers with items; 300 mobs in a 4x4 pen (collision); 1,000 items; pathfinding mobs. Categories toggle in its config | Empty area | MSPT; spark Server thread. It switches off `mixin.alloc.blockstate` when FerriteCore is present |
| Let Me Despawn 1.26.11.1 | Almanac, DungeonConfig | 200 zombies that hold items (persistent in vanilla), left out of player range 5 to 10 minutes | 200 zombies without items | Entity count after the wait; MSPT |
| Clumps 12.0.0.4 | none | 1,000 XP orbs summoned in one spot | None | MSPT; entity count; client frame time if a client is in range |

### Redstone, recipes, lighting

| Mod | Needs | Target scene | Control scene | Metric |
| --- | --- | --- | --- | --- |
| Alternate Current 1.7.0 | none | A 64x64 plane of redstone dust fed from one source that toggles on a clock | No redstone | MSPT; spark `RedStoneWireBlock` frames. M4: use circuits that do not depend on update order, and compare the output signals |
| FastWorkbench 8.0.4, FastFurnace 8.0.2, FastSuite 5.1.2 | Placebo | Shift-click crafting of a full stack, repeated; 500 furnaces fed by hoppers; recipe lookups of a type with 100 or more recipes (FastSuite) | No crafting or furnaces | MSPT; spark Sources view. M4: AE2 crafting terminal, Mekanism ([refs/issues.md](../refs/issues.md)) |
| Solix 0.3.7 (CurseForge, jar not read) | none | A light update storm: `/fill` a 32x32x32 block with glowstone and back to air, repeated; chunk generation | No block changes | MSPT; time until the light settles. M4: compare light levels at sample points (`unverified`) |
| Leaves Be Gone 8.0.0 | Puzzles Lib | A felled large tree or a forest block; the pack sets decay to 5 to 20 ticks | No leaves | MSPT during the decay; time until all leaves are gone. It is a quality-of-life change as much as a speed-up |

### World generation and structure search

| Mod | Needs | Target scene | Control scene | Metric |
| --- | --- | --- | --- | --- |
| Structure Layout Optimizer 1.0.12 | Resourceful Config | `/forge generate` of a fixed chunk count in a structure-rich area, fresh world copy per run | Ocean | Generation wall time; spark `--thread *`. M4: `/locate` gives the same positions. Never enable `deduplicateShuffledTemplatePoolElementList` |
| Fast Noise 1.0.13 | none | The same generation run, in noise-heavy terrain (large biomes, caves) | None | Generation wall time. M4: `/locate` biome and structure positions equal (byte-identical region files are not expected, vanilla is not deterministic: MC-55596). Incompatible with Moonrise, Noisium, Anti-Xray |
| Async Locator 1.3.0 | none | `/locate structure minecraft:village` where no nearby chunk exists, fresh world copy per run | `/locate` in generated terrain | Server thread stall: `/spark tickmonitor --threshold-tick 100`; time to the result |

### Memory, logging and loading

| Mod | Needs | Target scene | Control scene | Metric |
| --- | --- | --- | --- | --- |
| FerriteCore 6.0.1 | none | Heap after a full GC, after joining the world. M2 first | none | `jcmd <pid> GC.run`, then `jcmd <pid> GC.heap_info` (JDK tool, `unverified` here), or `/sparkc heapsummary` |
| Jasione 1.0.9 | none | Allocation rate in a busy scene: redstone with pistons, chunk meshing, lighting | Idle menu | `-Xlog:gc*` young collections per minute; `/sparkc profiler start --alloc`. Overlap with Harium `alloc.enum_values` (see Overlap) |
| AllTheLeaks (CurseForge, jar not read) | the mods it patches | Join and leave a world 10 times, read the heap after a GC each time; compare the trend | none | M2 only |
| Async Logger 2.2.3 | none | Heavy logging. Its `testPerformance` config option logs timings before and after (author) | Normal logging | The logged times; startup log volume |
| ModernFix 5.27.91 | none (JEI optional) | Startup, world join, heap after join, resource reload. Then one feature at a time through `config/modernfix-mixins.properties` (the pack sets `mixin.perf.remove_spawn_chunks=true` only). M2 first | none | Stopwatch; log lines; heap |
| Quick Pack 1.5.2 | none | Startup and a reload (`F3` + `T`) with the pack's real resource pack zips enabled. M2 first | No packs | Log timestamps from `Reloading ResourceManager` to the last `Created: ... atlas` line (`unverified`) |
| 0Pack2Reload 1.0.1 | none | Open the resource pack screen and press Done with no change: no reload | Change a pack: a reload is expected | Count of `Reloading ResourceManager` lines in `latest.log` |
| JEI/EMI Optimizations (CurseForge, jar not read) | JEI 15.56 or newer, EMI | World join. M2 only | none | `Starting JEI took`, `Reloaded EMI in` ([refs/issues.md](../refs/issues.md)); check recipes and search are complete after the join |

## Overlap groups

Run M3 on these. The facts in the last column come from [refs/notes.md](../refs/notes.md), [refs/settings.md](../refs/settings.md) and [refs/issues.md](../refs/issues.md).

| Group | Mods | Scene | Known |
| --- | --- | --- | --- |
| Visibility culling | Embeddium frustum, Entity Culling, Chloride distance culling (B1) | Entities and chests both far and behind walls | Judged complementary; not measured |
| Texture animation | Embeddium "Animate Only Visible Textures", Kerria (B1) | The animated wall; a 2x2 of option on or off and Kerria on or off | Judged complementary |
| Immediate mode and HUD | Gnetum, ImmediatelyFast | Full HUD plus many entities | Gnetum recommends both |
| Block entities | OBE, Chloride Fast Chests and Beds, Entity Culling, Chloride `tileEntityDistanceX` | 1,000 chests and beds | Fast Chests and Beds beside OBE was requested by the user and never run. Run first |
| Item, particle, entity render | Flerovium, Fast Items, ImmediatelyFast, AsyncParticles, BadOptimizations | Dropped items; particles with `particles:0` | Fast Items cancels `ItemEntityRenderer.render` at the head, so Flerovium's redirect inside it is probably bypassed (inference). AsyncParticles with BadOptimizations: fixed since 20.1.1.0 |
| Entity tick | Immersive Optimization, Entity Culling tick culling, AI Improvements, Harium AI, Let Me Despawn | 300 mobs at mixed distances | DoesPotatoTick was rejected for overlap |
| Redstone | Alternate Current, Harium `mixin.block.redstone_wire` | The dust plane | Whether Harium's redstone mixin is active beside Alternate Current is unconfirmed. Run first |
| Memory | FerriteCore, Harium `mixin.alloc.blockstate` and `alloc.enum_values`, Jasione | Heap after join; allocation rate | Harium has `defaultRequire = 1` and redirects `Direction.values()` in piston methods; another redirect on the same call site does not apply. Whether Jasione hits the same sites was not checked ([refs/comparisons/enum-values-memory/](../refs/comparisons/enum-values-memory/)). Run first |
| Loading and reload | ModernFix, Quick Pack, 0Pack2Reload, JEI/EMI Optimizations, Chloride fast language reload | Startup, reload, join | ModernFix already has `faster_texture_stitching` and a dedicated reload executor on by default |
| Recipes | FastWorkbench, FastFurnace, FastSuite | Crafting and furnace scenes | They share Placebo; FastSuite has had thread-safety crashes with other mods |
| World generation | Fast Noise, Structure Layout Optimizer, Async Locator, Distant Horizons generation | `/forge generate` | Distant Horizons generation load adds to it on a client |
| Create FPS | Colorwheel, CreateBetterFPS | The contraption with a shader on | The notes say CreateBetterFPS works beside Colorwheel; not run |

## Functional and conflict check (M4)

Do this for every mod and every group, after the timing runs.

- Launch and join: no crash, no `Mixin apply failed`, `Critical injection failure`, `InvalidInjectionException` or `@Redirect conflict` in `logs/latest.log` (common Mixin messages, exact wording `unverified`).
- Picture: the same spot with F1, mod on and off. Look for missing faces, flicker, wrong colors.
- Behavior: the check written in the table for that mod (same farm output, same structure positions, same signal strength).
- Settings: the mod's own on-screen prompts (AsyncParticles' recommendations) are answered the same way in every variant.

## Where results go

Same as [benchmark.md](benchmark.md), Run record. One extra line per result: the method (M1 to M4), the baseline, and the control scene's result next to the target's.

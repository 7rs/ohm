# Opticores against the installed culling stack (Forge 1.20.1)

Status: provisional. Research date: 2026-11-23. Nothing was run in the game; every behavior below comes from reading the jar and the platform pages.

Decision: pending (user).

## Headline

Not recommended. Opticores is a very young, aggressive suite that re-implements work the pack already does with Entity Culling, Chloride, Embeddium and the particle mods. Its only performance evidence is the author's own table for Minecraft 1.21.1 on an Intel UHD laptop.

## Fact table

| | Opticores | Entity Culling (installed) |
| --- | --- | --- |
| Downloads, Modrinth (all versions) | 72,975 | 191,859,559 |
| Downloads, Modrinth (Forge 1.20.1 files) | 3,596 (7 files) | not collected |
| Latest Forge 1.20.1 release | 1.1.2.5+1.20.x, 2026-10-28 | 1.11.3, 2026-10-08 |
| Repository | created 2026-05-08, 6 stars, last commit 2026-11-18, 0 open issues | tr7zw/EntityCulling |
| Side | client | client |
| Evidence of the effect | author's table, Minecraft 1.21.1, i3-1115G4 with UHD: average FPS 45 (vanilla), 147 (Sodium), 270 (Sodium + Opticores) | n/a |

## Source, read (jar 1.1.2.5+1.20.x)

- 68 classes, package `com.example.opticore` (template package name). `mods.toml` describes it as "an aggressive client-side optimization suite" with 7 phases: memory and GC, CPU logic, culling, chunk loading, I/O network, lighting.
- Client mixins: `LevelRenderer.renderLevel` (`m_109820_`), `Minecraft` (a crash hook, see below), `EntityRenderDispatcher.render` (cancels entity render, overlaps Entity Culling), `ParticleEngine` (cancels particle ticks, overlaps AsyncParticles, Kerria, BadOptimizations), `ItemFrameRenderer` (skips distant frame items, overlaps Entity Culling), `BlockEntityRenderDispatcher`, `BlockModelRenderer`, and Embeddium and Oculus specific mixins (`RenderSectionManager`, block renderer, `ShadowRenderer`).
- The common mixin list (not client-only) holds `MixinWorld`, `MixinMobEntity`, `MixinLightingProvider`, `MixinChunkBuilder` and `MixinWorldRendererSetupTerrain`. Mixin names are Yarn style. Whether each target resolves on Forge 1.20.1 was not checked (no `defaultRequire`).
- Other systems in the jar: chunk upload throttling and deferred upload queues, shadow frustum culling, leaf culling, async chunk decompression, region prefetching, packet batching, an indirect draw mesh system, Distant Horizons compat helper, JFR integration, a benchmark suite.
- `CrashHandler` builds a GitHub new-issue URL with the stack trace when a crash trace contains its package, and opens it. It hooks `Minecraft.crash`. An earlier crash in this pack (FastQuit) showed that crash hooks can hide the real error.

## Observations for this pack

- Overlap with installed mods is large: entity culling, particle culling, item frame culling, leaf culling, chunk upload pacing.
- Nothing independent measures it on 1.20.1. The 1.20.1 build has about 3.6 thousand downloads.

## Excluded

| Mod | Reason |
| --- | --- |
| Entity Culling, Chloride, Embeddium | Installed |
| Particle Core | Overlaps AsyncParticles, Kerria, BadOptimizations |
| Cull Leaves, SE LeafCulling | Overlaps Chloride `leavesCulling = ALL` |
| Create NoWheel | Create is not installed |
| Optitritium, CLab, Accelerated Rendering (fork), Cullify, brute-force-rendering-culling, occlusion-culling-fix-sodium | Not read. Same overlap class as Opticores; occlusion-culling-fix-sodium is from 2023 |

## Coverage

- Market from Modrinth only. The alternatives were not read beyond platform data.
- Evidence levels: downloads and dates Measured, mixin targets Measured by reading, FPS effect Claimed.

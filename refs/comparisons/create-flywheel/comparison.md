# Create and Flywheel for Colorwheel (Forge 1.20.1)

Status: provisional. Research date: 2026-11-23. Nothing was run in the game.

Decision (2026-11-23, user): add Create ("Createを入れるか。とりあえず"). Create 6.0.8 was added after this review found no blocker.

## Why

On the ohm instance, selecting a shader pack that has `shaders/colorwheel.properties` crashed the game with `NoClassDefFoundError: dev/engine_room/flywheel/api/material/Transparency` (crash reports `crash-2026-11-23_23.30.51-client.txt` and `23.31.34`). Colorwheel 1.3.2 logs "Flywheel is not installed, Colorwheel will be disabled" but its Iris shader-pack hook still runs. Five of the six shader zips in the instance have that file (Complementary Reimagined, Mellow, I Like Vanilla, Solas, and BSL patched by Colorwheel Patcher). Details are in `refs/issues.md`, section Colorwheel.

## Candidates

| Candidate | Result |
| --- | --- |
| Create 6.0.8 (Forge 1.20.1) | Chosen by the user. It carries Flywheel 1.0.5 as Jar-in-Jar (`META-INF/jarjar/flywheel-forge-1.20.1-1.0.5.jar`), which contains `dev/engine_room/flywheel/api/material/Transparency.class` (read from the jar) |
| No mod: remove Colorwheel and Colorwheel Patcher | Would have ended the crash with nothing else installed, and loses nothing until Create comes. Offered as the recommended option; not chosen |
| Standalone Flywheel | None for 1.20.1 Forge: Modrinth's `flywheel` project is from 2023 and has no 1.20.1 Forge version; a web search found only third-party mirrors |
| Create: Nowheel (166,647 downloads, 2026-09-21, client only) | Not needed. An optimization for Create (Flywheel plus Entity Culling) that needs Indirect Flywheel and, with shaders, Colorwheel 1.3 |
| Iris & Oculus Flywheel Compat | Excluded: Colorwheel declares it incompatible (`refs/comparisons/flywheel-shader-compat/`) |

## Create 6.0.8

| Item | Value | Evidence |
| --- | --- | --- |
| Downloads, followers | 28,417,799, 7,463 (Modrinth, all versions) | Modrinth API |
| Release | `create-1.20.1-6.0.8.jar`, 2025-11-02, 18.7 MB. The latest Forge 1.20.1 version; the one before is 6.0.7 (2025-10-25) | Modrinth API |
| Side | Client optional, server required: `side = "both"` | Modrinth API |
| Requires | Forge 47.1.3 or newer (pack: 47.4.28), Minecraft 1.20.1, Flywheel 1.0 to 2.0 (bundled, client side), Ponder 0.8 or newer (bundled). JEI optional | `mods.toml` |
| Jar-in-Jar | Ponder-Forge-1.20.1-1.0.91, Registrate-MC1.20-1.3.3, flywheel-forge-1.20.1-1.0.5, mixinextras-forge-0.4.1 | jar |
| Installed mods that mention it | Colorwheel (Flywheel optional, range 1.0.0 to 2.0.0), CreateBetterFPS (Create optional, 6.0.0 or newer), Jade Addons (Create optional, 6.0.2 or newer). None declares an incompatibility (89 jars read) | `mods.toml` of the instance's `mods/` |
| Tracker search (Creators-of-Create/Create, 1.20.1, for ImmediatelyFast, Embeddium, Entity Culling, Flerovium, Chloride, Ixeris, ModernFix) | Only noise: mod names that appear in issue templates and unrelated bugs. No report of a conflict was found. A search for Optimized Block Entities returned nothing | GitHub search |

## What was not done

- No game run. Whether Colorwheel's Flywheel backend works under each shader pack with Embeddium 0.3.31, Flerovium and Oculus 1.8.0 is unverified.
- Mixin targets of Create against the 89 installed jars were not compared.
- The Flywheel backend setting was not read; Create and Colorwheel were left at their defaults.
- Create's own config (`config/create-*.toml`) is not shipped.

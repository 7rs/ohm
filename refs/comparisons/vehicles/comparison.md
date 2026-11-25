# Vehicles and transport proposed on 2026-11-24 (Forge 1.20.1)

Status: provisional. Research date: 2026-11-24. Nothing was run in the game.

Decision (2026-11-24, user): add Immersive Vehicles, Immersive Aircraft, Create: Steam 'n' Rails, Man of Many Planes and Small Ships; hold Valkyrien Skies. The Immersive Vehicles content pack is chosen later. The five were added as Modrinth releases (`packwiz modrinth add`); see `refs/notes.md`, "Added 2026-11-24: vehicles". Scope and limits: `00_scope.md`. Third-party reports: `gh_issues.md` (raw: `gh_raw_search.txt`, `gh_raw_issues.txt`). Facts per project: `products.csv`.

## Result

All six have a Forge 1.20.1 build and none of them has a hard Mixin conflict ("hard" means two mods hook the same call with `@Redirect` or `@ModifyConstant`, or one uses `@Overwrite` on a method the other hooks). The scan compared each jar with the 118 jars of the pack and with each other. That says nothing about behavior, shaders or world data.

| Candidate | Forge 1.20.1 build | Needs | Overlap with the pack | Verdict |
| --- | --- | --- | --- | --- |
| Create: Steam 'n' Rails | 1.7.3 (2026-08-27, 16.3 MB) | Create 6.0.7 or newer (installed 6.0.8) | Extends Create's trains; no other installed mod does trains | Add |
| Immersive Aircraft | 1.5.0 (2026-09-12, 2.3 MB) | Nothing (Ad Astra is optional, not installed) | Seven civil aircraft. Superb Warfare has military aircraft of its own | Add |
| Man of Many Planes | 0.2.1 (2026-09-09, 0.3 MB) | Immersive Aircraft 1.1.0 or newer | Two more aircraft for Immersive Aircraft | Add only with Immersive Aircraft, if wanted |
| Small Ships | 2.0.2 (2026-10-16, 2.8 MB) | Nothing | Vanilla boats. Nine ships with cannons | Add, knowing the Shoulder Surfing camera problem |
| Immersive Vehicles | 24.0.0 (2026-04-16, 6 MB) | At least one content pack: it has no vehicles by itself | Superb Warfare has tanks, aircraft and boats; the packs have guns, next to TaCZ | Your decision: pack choice and overlap (see below) |
| Valkyrien Skies | 2.4.11 (2026-04-10, 26.5 MB) | Kotlin for Forge (installed). An add-on such as Eureka for ordinary play | None (no physics-ship mod installed) | Not recommended now |

## Per candidate

### Create: Steam 'n' Rails 1.7.3

- Needs Create 6.0.7 or newer; `mods.toml` lists Hex Casting and Simple Voice Chat as optional. Create 6.0.8 is installed.
- The jar has 192 Mixin classes. 165 targets, 12 of them share a method with an installed mod, all plain injects (for example `Player.tick`, `GameRenderer.bobView`, `ItemInHandRenderer.renderHandsWithItems`, `TextureAtlas.cycleAnimationFrames` with Oculus). Two `@WrapOperation`s sit on the same methods as Bedrockoid's (`ServerLevel.tickChunk`, `Biome.shouldSnow`); wrap operations chain.
- All 3,199 member references into Create 6.0.8, its Flywheel 1.0.5, Ponder 1.0.91 and Catnip resolve. Every Mixin target class in an installed mod exists; the five missing ones belong to Simple Voice Chat and malilib (not installed).
- Reports: #768 is open: with Flywheel's `instancing` backend, many cased tracks cause a large FPS drop and `indirect` is smooth; a commenter points to cased tracks building a new model every time. #740 (closed): tracks placed before 1.7.0 were not recognized because of a data fixer, with the advice to restore from a backup; the release fixed it. Reports #740, #752 and #727 come from Create 6.0.8 with Flywheel 1.0.5 on Forge 47.4.x, the same versions as this pack. The issue searches returned 35 hits for Oculus, 6 for Distant Horizons, 2 for Colorwheel and 6 for Create Better FPS; the ones listed by title are closed (a shader POM glitch on the boiler, bogey rendering) or unrelated, and the rest were not read one by one. The pack has Colorwheel and Create Better FPS, which touch Flywheel; no test.
- Verdict: Add. It is the natural extension of the Create already in the pack. Check the Flywheel backend and the FPS on a long track with the pack's shader packs.

### Immersive Aircraft 1.5.0 and Man of Many Planes 0.2.1

- Immersive Aircraft: Airship, Cargo Airship, Warship, Biplane, Gyrodyne, Quadrocopter and Bamboo Hopper, with 27 items (engines, boilers, propellers, a Rotary Cannon, a Bomb Bay, a Heavy Crossbow). 14 Mixin classes, 13 targets, 11 of them share a method with installed mods, plain (`Camera.setup`, `Player.updatePlayerPose`, `GameRenderer.renderLevel`, `LivingEntityRenderer.setupRotations` and others; most of them are also hooked by Superb Warfare, which has vehicles too). No jar string refers to Immersive Optimization (the same author).
- Config keys read from the jar: `enableCrashExplosion`, `enableCrashBlockDestruction`, `enableCrashFire`, `weaponsAreDestructive`, `fuelConsumption`, `separateCamera`, `useThirdPersonByDefault`. Defaults were not read, so how much damage a crash or a bomb does to the world is unknown. Decide before adding.
- Reports: #246 (closed) a client disconnect when an aircraft is placed on a server, tied to an add-on that is not installed; #329 (closed) "takes many tries to mount" on 1.4.0 with Valkyrien Skies and Create, with no cause given. The tracker has no report with Oculus, Embeddium, Immersive Optimization or Entity Culling that applies to this pack.
- Man of Many Planes: Scarlet Biplane and Economy Plane. The jar has 9 classes and no Mixin; all 28 member references into Immersive Aircraft resolve. It has no Create code ("Create-themed" means the models).
- Verdict: Add Immersive Aircraft. Man of Many Planes is a small extra.

### Small Ships 2.0.2

- Nine ships (Cog, Galley, War Galley, Rowing Boat, Drakkar, Dhow, Brigg, Caravel, Galleon) in wood variants (104 items), Ship Cannon and Cannon Ball, and a Dockyard block. Config keys read from the jar include `shipGeneralCannonDestruction`, `shipGeneralCannonDamage`, `windEnable`, `sailDamageEnable` and `shipGeneralCameraFreeLook`; defaults were not read.
- 16 Mixin classes, 12 targets, 8 share a method with installed mods, plain (`Camera.setup`, `Boat.tick`, `LivingEntityRenderer.render`, `KeyboardHandler.keyPress`, `Gui.render`, `Entity.turn` and others). `Camera.setup` is also hooked by Shoulder Surfing Reloaded, Create, Punchy!, Punchy! Moves, Vanilla Backport and Superb Warfare.
- The 2.0 line for 1.20.1 is new: 2.0.0 on 2026-10-04, before that only a beta from 2024-07.
- Reports: #54 (open, Forge 1.20.1, version 2.0): with Shoulder Surfing's "replace default perspective" on, the third-person view in a ship is Shoulder Surfing's and the scroll wheel does not zoom; the Shoulder Surfing maintainer (their #477) says a Small Ships plugin using Shoulder Surfing's API is needed. Shoulder Surfing Reloaded is installed here, and its config is not shipped. #57 (open) is a startup crash of 2.0.1 on NeoForge 1.21.1 with a mod that is not installed here, because both used `@Redirect` on `Camera.setPosition`. The 1.20.1 jar (read) hooks `Camera.setup` with an inject at the head, a `@WrapOperation` on `Camera.setPosition` and a `@ModifyArg` on `getMaxZoom`, so this crash does not apply to the pack. The installed Create has a `@ModifyArg` on the same `getMaxZoom` call; two `@ModifyArg`s on one call both apply, but the resulting zoom distance of a ship was not tested.
- Verdict: Add. Expect the camera problem while Shoulder Surfing replaces the perspective.

### Immersive Vehicles 24.0.0

- Its Modrinth page says it has no vehicles by default; vehicles come from content packs that go into `mods/`. On Modrinth: Official Content Pack (build 29, 2026-04-18, planes and cars, 612,400 downloads) and Official Automobile Pack (OAmP-V3, 2026-04-16, 145,483 downloads). The other packs listed on the page link to CurseForge.
- 13 Mixin classes, 3 share a method with installed mods, plain (`HumanoidModel.setupAnim`, `LevelRenderer.renderLevel`, `LivingEntityRenderer.render`). The jar has its own renderer (10 client Mixin classes) and its own shader files (`assets/mts/shaders`). It also hooks `Entity.getEyePosition` and `Entity.collide`; Valkyrien Skies hooks `Entity` too, so the pair would stack (not tested). One IV hook is a `@Redirect` on `Level.getHeight` inside `LevelRenderer.renderSnowAndRain`, the same call that AsyncParticles wraps with `@WrapOperation`. By the rule above (two `@Redirect`s) that is not a hard conflict, and whether Mixin lets a redirect and a wrap coexist on one call was not tested.
- Reports about shaders: #2008 (closed) a crash with OptiFine or its replacements, the author calls it bad texture-loading return calls and has a fix; #1980 (closed) PBR reflections turned off with Embeddium 0.3.31 and Oculus 1.8.0 on 1.20.1, "addressed in 23.0.0"; #2159 (open, on a NeoForge 26.1 build 25.0.0) instruments break with any shader in two of three render modes and the author says shaders are hard with this kind of rendering. #2185 (open) a dedicated server fails to load on 22.18.0 with a client-only class (`PoseStack`); a commenter suspects a mod that alters the renderer, unconfirmed, and not tested on 24.0.0. A pull request (#2265, open) would make TaCZ bullets damage its vehicles; until then they do not.
- Overlap: Superb Warfare already has vehicles, and Immersive Aircraft would add aircraft. The IV content packs bring cars and some guns (a second gun source next to TaCZ).
- Verdict: possible, but it is a platform plus a pack choice, not a drop-in mod. Needs your decision.

### Valkyrien Skies 2.4.11

- Modrinth calls it a library mod and says to add an add-on for normal play (Eureka! is named; Eureka 1.6.4 for Forge 1.20.1 was released 2026-11-01). The page also says it is in beta.
- `mods.toml`: Forge 47.2.0 or newer, Create 6.0.6 or newer optional, ComputerCraft optional. 357 Mixin classes, 306 targets (194 outside Minecraft); 29 classes share a method with installed mods, plain (`Entity`, `Level.getEntities`, `ServerLevel.tick`, `LevelRenderer`, `GameRenderer`, `ClientPacketListener` and others). It has renderer integrations for Embeddium (25 member references into Embeddium 0.3.31, all resolve), Iris-style shader packs (it detects the Iris class), Flywheel 1.0 (234 references into Create 6.0.8 and its Flywheel 1.0.5, all resolve) and ETF. Every Create-side Mixin target class exists in Create 6.0.8.
- Reports that fit this pack: #1896 (open): with Distant Horizons and an Oculus shader pack, ships are not drawn beyond a distance, whatever the ship load distance; #1300 (open): ships are partly invisible with Distant Horizons because of LOD fade, VS would have to declare ships to Distant Horizons' render API. #1534 (open): Create shafts are invisible on assembled ships (Forge 1.20.x; the last comment, 2026-11-22, says it is fixed in the latest playtest build). #1112 (open): parts of a very large ship are invisible; maintainers say it is fixed in the 2.5 playtests. So the 2.4.11 release still carries two visible rendering bugs that are fixed only in a playtest build. #1929 (closed): a maintainer asked the reporter to try without Entity Culling and Immersive Optimization because "we've encountered this issue before and believe it's a mod conflict"; both are installed here. The reporter removed both without a change and the issue was closed as not reproducible.
- Closed ones that matter less: #913 and #986 (Distant Horizons crashes, fixed or caused by another mod), #728 (block entities on ships with Embeddium, 1.18, cannot reproduce on the newest), #1980 (block entity render glitch with Litematica).
- Scale: 329 open issues; the 1.20.1 branch was pushed on 2026-11-22; the newest 1.20.1 release is 7 months old while a 2.5 playtest exists.
- Verdict: not recommended now. The pack is the exact stack where the open reports sit (Create, Embeddium, Oculus, shader packs, Distant Horizons, Entity Culling, Immersive Optimization), it needs a second mod (Eureka) for survival ships, and the fixes are in an unreleased build. Revisit when 2.5 is released.

## What the user suspected

The user only asked whether they can be added. Findings: all six load on Forge 47.4.28 by their declared ranges; Steam 'n' Rails, Immersive Aircraft and Small Ships need nothing more; Immersive Vehicles needs a content pack; Valkyrien Skies needs an add-on to be useful.

## Decisions only the user can make

1. Immersive Vehicles: wanted at all, given Superb Warfare's vehicles and Immersive Aircraft? If yes, which pack (the Official Content Pack for planes and cars is on Modrinth), and are packs with guns acceptable next to TaCZ? Shaders with this renderer are reported as fragile on newer versions.
2. Valkyrien Skies: wait for 2.5, or add it with Eureka and accept the open rendering reports and the Entity Culling / Immersive Optimization suspicion.
3. Destruction: Immersive Aircraft (crash and weapons keys) and Small Ships (cannon key) have world-damage settings whose defaults were not read. Superb Warfare explosions are already on (user's choice). Decide the shipped values when adding.
4. Small Ships and Shoulder Surfing Reloaded: accept the camera issue, or ship Shoulder Surfing's "replace default perspective" as off (the key name was not read from the jar).

## Risks that apply to all of them

- Everything is `side = "both"` (the Modrinth side data says client and server required for all six). The `.mrpack` grows by about 54 MB for all six (Steam 'n' Rails 16.3, Valkyrien Skies 26.5, Immersive Vehicles 6, Small Ships 2.8, Immersive Aircraft 2.3, Man of Many Planes 0.3), less without Valkyrien Skies.
- The pack's Create stack (6.0.8, Colorwheel, Create Better FPS, Flerovium, Oculus, Embeddium, Distant Horizons) has never been run (`refs/issues.md`). Adding more Flywheel-related mods makes a crash harder to trace. Add in groups and launch after each: first Steam 'n' Rails, then the air and sea mods.
- Entity-heavy mods (aircraft, ships, cars) and the pack's entity tick throttling (Immersive Optimization) and culling (Entity Culling) have not been tried together.

# Superb Warfare (Forge 1.20.1)

Status: provisional. Research date: 2026-11-24. Nothing was run in the game. Scope and limits: `00_scope.md`.

Decision (2026-11-24, user): add Superb Warfare with explosion block destruction left on, plus Almost Unified and Almost Unify Everything. Added with Kotlin for Forge 4.12.0 (its loader). The TaCZ links of its jar (8 member references) all resolve against TaCZ 1.1.8-hotfix2.

## Result

It can be added: no blocker was found. Whether it fits is the user's call, because it is a second gun system next to TaCZ and its real addition is vehicles and heavy weapons.

## Facts

| Item | Value | Evidence |
| --- | --- | --- |
| Build | 0.8.9.2 (release, 2026-09-30), 42.1 MB. 36 Forge 1.20.1 builds; the project was updated 2026-11-06 | Modrinth API |
| Popularity | 3,449,815 downloads, 619 followers (TaCZ: 33,100,217) | Modrinth API |
| Side | Client required, server required: `side = "both"` | Modrinth API |
| Loader | `modLoader = "kotlinforforge"`, `loaderVersion = [4.11.0,)`. Kotlin for Forge is the only new library: Modrinth `kotlin-for-forge`, 1.20.1 Forge build 4.12.0 (2025-12-03), 55 million downloads | `mods.toml`, Modrinth API |
| Required | Forge 47 or newer, SimpleBedrockModel 2.5.1 (bundled). GeckoLib, Curios, Cloth Config, Patchouli are optional | `mods.toml` |
| Bundled (Jar-in-Jar) | Ponder 1.0.91, Flywheel 1.0.5 (the same versions as Create 6.0.8), Cloth Config 11.1.106 (pack: 11.1.136), Curios 5.14.1 (pack: 5.14.1), GeckoLib 4.4.6 (pack: 4.8.5), SimpleBedrockModel, rhino | jar |
| Incompatible | GeckoAnimFix (not installed). Do not add it | `mods.toml`, Modrinth API |
| Mixin conflicts | 0 hard conflicts, 0 `@Overwrite` pairs against 111 jars. 516 plain same-method injects, mostly the same camera and held-item hooks as TaCZ, Punchy!, Punchy! Moves, Shoulder Surfing Reloaded (`Camera.setup`, `GameRenderer.bobView` and `getFov`, `MouseHandler.turnPlayer`, `ItemInHandRenderer`, `HumanoidModel.setupAnim`) | scan |
| TaCZ | It has a TaCZ compat package and a Mixin into TaCZ's `EntityUtil.getHitResult` at the head (probably so TaCZ bullets hit its vehicles; inference) | jar |
| Other compat | Oculus, Valkyrien Skies, Jade, JEI, Ponder, KubeJS, Cold Sweat, Cloth Config, Real Camera | jar |
| Content | 339 items (about 40 guns with blueprints, ammo, perks), 90 entities (tanks such as M1A2, aircraft such as A-10 and AC-130H, helicopters, a Kirov airship, missiles, mortars, drones, mines, CIWS), 33 blocks including galena, scheelite and silver ore | `en_us.json` |
| Gameplay default | Block destruction by explosions is on by default since 0.7.0 (mod page). Server config `serverconfig/superbwarfare-server.toml` `explosion_destroy`, or `/sbw config explosionDestroy` | Modrinth page |

## Overlap with the pack

- TaCZ plus LR Tactical already cover guns. A second system means two sets of aiming, recoil, reload keys and HUD, and two ammo families. Vehicles, aircraft, artillery and missiles have no installed equivalent.
- Materials: Superb Warfare adds lead (galena), silver, tungsten, steel, plates and powders. With it, item tags from 2 or more mods rise from 2 to 12: `ingots/lead`, `ores/lead`, `raw_materials/lead`, `storage_blocks/lead`, `storage_blocks/raw_lead`, `ingots/steel`, `storage_blocks/steel` (all with Mekanism), `dusts/iron` and `dusts/coal` (Mekanism), `plates/copper` (Create), and the two dust tags already seen. Almost Unified (not installed) would then have a job: see `refs/notes.md`.
- Create: Superb Warfare bundles Flywheel 1.0.5 and Ponder 1.0.91, the same versions as Create's own. Forge should load one copy of each; not run.

## Reported problems (GitHub, Mercurows/SuperbWarfare)

| Issue | State | What it says | Fit |
| --- | --- | --- | --- |
| 181 | open | A TaCZ gun in the offhand stops main-hand animations after updating to 0.8.9.2 (the reporter says it is untested) | Direct TaCZ interplay, unconfirmed |
| 168 | open | With a gun in the offhand the third-person model shows the hands but not the gun | Superb Warfare guns only |
| 180 | open | "Severe lag on the mod overlay trace function"; a profile screenshot; the reporter also has Create: Aeronautics; no version given | Unknown |
| 77 | closed 2026-08-18 | With Iris, shaders and Distant Horizons, when a vehicle or drone tilts the camera the LOD does not tilt (ghost objects). Reported on 1.21.1, Iris 1.8.12, DH 2.3.6. The author: "fixed in 0.8.9.1, in theory" | The pack has Oculus, shader packs and Distant Horizons; 0.8.9.2 is newer than the fix, not tested |
| 103 | closed | A 1.20.1 pack with Create 6.0.8, Create Crafts & Additions 1.3.3, Embeddium 0.3.31, Oculus 1.8.0, GeckoLib 4.8.2 and Kotlin for Forge 4.11.0 ran Superb Warfare 0.8.8; the bug was a Valkyrien Skies one | Close to this stack |
| 113 | closed | Crash with "tacz tweaks" (an add-on that is not installed) | None |

No report was found for Punchy!, Colorwheel, Shoulder Surfing Reloaded, Flerovium or Entity Culling (search terms returned nothing, or noise).

## Risks and open questions

- Punchy! draws held items itself, so Superb Warfare guns would hit the same double-render and animation fight as TaCZ items (see `refs/issues.md`, Punchy!). Not tested.
- Superb Warfare's own server performance work exists (pull request 156, closed 2026-07-28), but how its projectiles and vehicles interact with Immersive Optimization and Entity Culling is unknown.
- Explosion block destruction in a world with Create contraptions and Mekanism machines is a gameplay decision. The setting lives in the world's `serverconfig`, which the pack's `config/` does not ship; a default would need a `defaultconfigs/` folder, which the pack does not have.
- The `.mrpack` grows by about 42 MB (jtrans already adds 52.7 MB).

## What the user has to decide

1. Is it wanted for the vehicles and heavy weapons, or only for guns? For guns alone TaCZ and its packs are enough, and Superb Warfare mostly adds a second control scheme.
2. Explosion destruction on or off by default.
3. If added: Almost Unified (and possibly its add-on) becomes worth adding because of the lead and steel overlap with Mekanism.

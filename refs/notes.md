# Notes

Per-mod decisions and constraints: why a mod is installed, what must not be added beside it, and what was checked and rejected. Read it before adding, removing or replacing a mod.

## Key Binding Mods

- Key Binding Patch gives several key combinations per action, combinations beyond Ctrl, Shift and Alt, and shadow copies of key bindings. Controlling adds the controls search bar. Searchables is the library Controlling requires. All three are `side = "client"`.
- Sinytra Connector, Forgified Fabric API, Amecs and NMUK were removed (2026-11-22). Amecs 1.6.x and NMUK 1.2.x ship no refmap and crashed at launch under Connector beta.49. No Fabric mod is installed now. Do not re-add Connector unless a Fabric mod is needed again.
- Key Binding Patch and Controlling are not tested together in-game. Key Binding Patch mixes into `KeyBindsList`, `KeyBindsScreen` and `KeyEntry`. Controlling has accessor mixins only (read from the jar).
- Do not add More Keybinds beside Key Binding Patch. Both mix into `KeyMapping`, `KeyBindsScreen`, `KeyBindsList` and `KeyEntry`.

## Punchy Mods

- Punchy! (first-person animations) and Punchy! Moves (third-person animations, shoulder camera). Both jars declare `clientSideOnly=true`, so both are `side = "client"`. packwiz marked Moves as `both` because its Modrinth environment is `unknown`; it was set by hand.
- Punchy! Moves ships no animations. Fluid & Foolish (resource pack, required on Modrinth) is in `resourcepacks/` and enabled at first launch (see `refs/settings.md`). Existing instances must enable it in the resource pack screen.
- Punchy! Moves bundles `punchy_expressions` and MixinExtras through Jar-in-Jar. Do not add them as separate mods.
- Punchy! draws held items itself, so TaCZ and LR Tactical items can render twice. Players can fix it per item with the F8 blacklist, or the pack can add Don't Punch My TACZ (Forge 1.20.1 build exists, needs Punchy!). Not installed.
- Punchy! Moves has its own shoulder camera and overlaps Shoulder Surfing Reloaded. Not tested together.

## Viewer, Info and Camera Mods

- EMI runs the JEI plugins of other mods through JEI (JEMI). The jars of The Aether, The Twilight Forest, TaCZ and LR Tactical ship JEI plugins only (checked in the jars), so EMI alone would not show their recipes. Keep JEI beside EMI.
- JEI is pinned to the release `15.56.0.205`. The 15.75.x line is beta and needs MezzConfig. JEI/EMI Optimizations needs JEI 15.56 or newer.
- JEI/EMI Optimizations has no environment data on CurseForge, so `side = "client"` was set by hand. It is exported as a client override in the `.mrpack`.
- Do not add TooManyRecipeViewers. It declares itself incompatible with JEI.
- The Aether and The Twilight Forest ship Jade plugins. Jade Addons integrates mods that are not Aether or Twilight Forest (Create, Tinkers' Construct, and others). Create was added on 2026-11-23, so its Create plugin (Jade Addons asks for Create 6.0.2 or newer) is active now; not run.
- Mine Menu is `side = "both"`: it has a server-side packet.
- Shoulder Surfing Reloaded declares Better Third Person, Nimble and YDM's Custom Camera View incompatible. Do not add them. TaCZ ships its own Shoulder Surfing plugin.

## Recipe, Worldgen, Create and Weather Mods

- FastWorkbench and FastFurnace cache the last recipe. FastSuite searches recipes in parallel, only for recipe types with 100 or more recipes and only for recipe classes it knows are thread-safe. The three share the library Placebo. They were added because 20 or more large mods are planned. Not measured.
- FastWorkbench hides the vanilla recipe book button by default. It stays at the default because EMI and JEI show recipes.
- Structure Layout Optimizer is `side = "both"` (single-player worlds need it too) and requires Resourceful Config. Never turn on its `deduplicateShuffledTemplatePoolElementList`: it breaks seed parity.
- Create 6.0.8 (added 2026-11-23, after the user's crash report: see `refs/issues.md`, Colorwheel) is `side = "both"` (the server needs it; Modrinth: client optional, server required). The jar carries Flywheel 1.0.5, Ponder 1.0.91, Registrate and MixinExtras as Jar-in-Jar, so none of them is a separate mod. Do not add them. Its `mods.toml` wants Forge 47.1.3 or newer (the pack has 47.4.28) and Minecraft 1.20.1; JEI is optional. No installed mod declares itself incompatible with Create (89 jars read). Create: Nowheel (Create plus Entity Culling optimization, needs Indirect Flywheel and Colorwheel 1.3 with shaders) was not added. Create 1.20.1 has had no release since 6.0.8 (2025-11-02).
- CreateBetterFPS is `side = "client"`. It needs Create 6.0 or newer, which is installed now. It only helps with a shader pack.
- Colorwheel is `side = "client"`. It lets Flywheel (bundled in Create 6) keep its GPU rendering under Oculus shaders. Without Flywheel its shader-pack hook crashed the game on selecting a pack with `colorwheel.properties`; Create's bundled Flywheel contains the missing class (read from the jar), which is why Create was added. Oculus 1.7.0 or newer is required (the pack has 1.8.0). Shader packs outside its official list need Colorwheel Patcher (installed 2026-11-23, see Shader Packs below) or run in its fallback mode with rendering flaws. CreateBetterFPS works beside it.
- Never add Iris & Oculus Flywheel Compat: Colorwheel declares it incompatible. Do not add Ocuwheel beside Colorwheel either (same job, hooks the same Iris and Flywheel classes).
- Weather Refined comes from CurseForge. `side = "client"` was set by hand. It uses vanilla weather while a shader pack is on.
- ModernFix `mixin.perf.dynamic_dfu` is on by default (read from the pinned jar), so `modernfix-mixins.properties` has no entry for it.
- Not added (checked 2026-11-22):
  - DoesPotatoTick: overlaps Immersive Optimization. Its default 4-chunk freeze and render stop works against `entityDistanceScaling`.
  - Redirected: overlaps Harium's `enum_values` mixins. Re-checked 2026-11-23: both redirect `Direction.values()` in the piston methods (see `refs/comparisons/enum-values-memory/`).
  - FastBoot: `dynamic_dfu` already skips loading DFU at startup.
  - Bocchium: culls only the world-bottom layer.
  - Ocuwheel: duplicate of Colorwheel. Its jar requires Create 6.0.8 or newer and patches shader pack GLSL at runtime.
  - [TaCZ] Optimization: its mixin targets the TaCZ 1.1.8 `BulletHoleParticle` constructor and is expected to break on TaCZ 1.2.x. Its defaults hide the kill count and interact key overlays.

## Added 2026-11-23

Chosen by the user from the comparisons under `refs/comparisons/`. Settings stay at the mods' defaults (see `refs/settings.md`).

- Enhanced Boss Bars (`boss-bar/`): `side = "client"`. Needs Cloth Config 11.1.136 or newer; the pack has `11.1.136+forge`, so do not downgrade it. The Aether has its own `BossHealthOverlay` mixin that cancels Forge's `BossEventProgress` event, so the two may interact (not tested). The source repository linked on Modrinth is the 1.21.1 NeoForge one.
- Async Locator (`structure-locating/`): `side = "both"` (the server needs it; single-player worlds use the integrated server). No installed Modrinth mod mixes into `LocateCommand`, `EnderEyeItem`, `EyeOfEnder`, the treasure map trade or `ExplorationMapFunction`. Other mods must call it themselves to benefit.
- Fast Items (`item-rendering/`): `side = "client"`. Needs MidnightLib. It cancels the vanilla `ItemEntityRenderer.render` at the head, so Flerovium's redirect of `getRenderAmount` inside that method is probably bypassed while it is on (inference). The pack already sets `entityShadows:false`. CurseForge has a different mod named Fast Items+ (another author); the Modrinth one has no CurseForge page.
- MidnightLib: `side = "client"` was set by hand (packwiz marked it `both`). Fast Items needs it and its mixin is client-only; Spawn Animations (added 2026-11-24) lists it as optional. Remove it together with Fast Items, unless Spawn Animations is still installed and its global config menu is wanted.
- Leaves Be Gone (`leaf-decay/`): `side = "both"`. Needs Puzzles Lib. Its only Forge 1.20.1 build is v8.0.0 (2023-06-28).
- Puzzles Lib: `side = "both"`. Its `displayTest` is `MATCH_VERSION`, so client and server must run the same version. Fast Item Frames (not installed) would also need it, plus Forge Config API Port.
- Quick Pack (`resource-loading/`): `side = "both"` (it also covers data pack zips on the server). The gain depends on the number of files inside zip packs, not on the number of packs. Revisit if reload times grow after the planned resource packs are added.
- Cubes Without Borders (`borderless-fullscreen/`): `side = "client"`. Added 2026-11-23, removed the same day for Chloride's built-in borderless mode (`fullscreen.mode`), and added again on 2026-11-24 at the user's request, with Chloride kept: the user wants Cubes Without Borders to lead. Chloride's fullscreen code has no off switch and mixin order is not configurable, so the pack keeps both in the same state (`fullscreenMode = BORDERLESS`, `useDelayedFullscreen = false`, Chloride `fullscreen.mode = BORDERLESS`; see `refs/settings.md`). The earlier comparison missed Chloride's borderless mode because it did not check the installed mods. Open risk: Chloride's redirect may bring the title bar back (see `refs/issues.md`). If it does, remove Cubes Without Borders and keep Chloride's. Do not add Borderless Mining, Borderless Window or any other borderless mod: Cubes Without Borders declares them incompatible.

## Added 2026-11-23: entity resource packs and their mods

Chosen by the user. Evidence in `refs/comparisons/entity-model-support/`.

- Packs: Fresh Animations (bottom), Iron Girl, Piglin-Chan, Melody's Cute Girl Traders, Illagers, Villagers, and Witches (top). All are `side = "client"` (packwiz marked them `both` because Modrinth lists their environment as unknown).
- Mods: Entity Model Features and Entity Texture Features (EMF requires ETF; ETF is the library, not a separate choice) and EntityModelShaderFix (for Oculus shader packs). All `side = "client"`.
- Entity Sound Features (ESF) was left out on purpose: the pack files use plain `.ogg` replacements. It would need EMF 3.3 and ETF 7.2 or newer, both present now.
- Pack order is a rule: the girl packs go above Fresh Animations, and Melody's Witches above Iron Girl (Iron Girl ships its own `witch.jem`).
- Minecraft 1.20.1 ignores `supported_formats`. Iron Girl (`pack_format` 32) and the four Melody's packs (10) count as incompatible, so they are also listed in `incompatibleResourcePacks` (see `refs/settings.md`).
- Flerovium stays installed. It breaks emissive (glowing) entity textures from resource packs (Flerovium issue 56, open), and the user accepted losing glowing eyes.
- Do not add Fresh Moves beside Punchy! Moves (both rewrite player poses).

## Shader Packs

Added 2026-11-23, chosen by the user from `refs/comparisons/shader-packs/`. All three are `side = "client"`. No shader pack is selected at first launch.

- Complementary Reimagined r5.10 is the only Complementary pack. Reimagined and Unbound have the same files except one line of `shaders/lib/common.glsl` (`SHADER_STYLE` 1 or 4), and `SHADER_STYLE` is the first entry of the shader's own options screen ("Visual Style"). Setting Visual Style to Unbound turns Reimagined into Unbound. Do not add Unbound beside it.
- BSL Shaders is pinned to 10.1 (`pin = true`). Colorwheel Patcher 1.0.5 lists exactly BSL `10.1` in its `config.json`; its patches are matched by exact version, so 10.1.1 to 10.1.8 would not be patched (inference from the config and class names, not run). 10.1.8 differs by 39 changed files and 9 new ones (an entity translucent pass and `chunkFade.glsl`, which needs the Iris feature `FADE_VARIABLE` that Oculus 1.8.0 lacks). Both versions have the same 14 Distant Horizons programs. Unpin when Colorwheel Patcher lists a newer BSL, or when Create stays out of the pack.
- Colorwheel Patcher is `side = "client"`. `mods.toml` requires only Forge and Minecraft (Colorwheel is not declared). At launch it copies supported shader packs as patched zips ending in `+ Clrwl`, so BSL appears twice in the shader list. Complementary r5.10 is not patched (officially supported since r5.7). It only matters with Create, which was added on 2026-11-23.
- Mellow 3.5, I Like Vanilla v1.5.0b and Solas 3.9 were added the same day (the user's choice; all three have the Colorwheel files in their zips and 14 to 20 Distant Horizons programs). Each is the latest release tagged for 1.20.1 and Iris, with no pin. All `side = "client"`.
- Mellow ships with `DYNAMIC_SHADOWS` off (commented out in `lib/settings.glsl`): its default shadows are lightmap based, not a shadow map. Turning it on uses a shadow map and the option's own text says "Performance impact: EXTREME". Its FPS in `refs/comparisons/shader-packs/lightness.md` is for the default, so the lead over the other packs does not hold with real shadows. Nothing is shipped to change it.
- I Like Vanilla has real-time shadows (`OVERWORLD_SHADOWS_TYPE` 2), reflections and water caustics on by default; it has no refraction code. Its page offers style-specific downloads on Modrinth; the main file is the one in the pack. Its Fantasy style is a setting.
- Solas has real-time shadows, screen-space shadows, water reflections, procedural water normals, caustics and refraction on by default.
- Rule from the user: only shader packs with Distant Horizons support. Packs without `dh_*` programs were dropped (for example Nostalgia, Kappa, Pastel, Insanity).
- TACZ and shader packs: the open TACZ issue 662 (scope shows a black band with DH and shaders, seen with Bliss and Complementary) and Oculus issue 797 (scope breaks rendering, Photon then crashes) are not solved by any mod. TACZ 1.2.0 (2026-11-06) and 1.2.0-hotfix (2026-11-15) rewrote some rendering and closed issue 755 (the same out-of-memory leak with Oculus separate entity draws); whether they fix the scope band is not confirmed. Updating TACZ is the user's decision. Do not add TaCZ:Accel for this: it is a performance add-on and does not claim a fix.

## Japanese Localization

Added 2026-11-24, chosen by the user from `refs/comparisons/japanese-localization/`. Evidence: of 13,177 text keys in the pack's 56 namespaces, official `ja_jp.json` covers 61.3 %, official plus jtrans 90.7 %, official plus Japanese Language Pack 86.2 %, all three 98.1 % (251 keys left: Punchy! Moves 134, Remove Reloading Screen 29, Bedrockoid 25, Shoulder Surfing 23, Punchy! 18, and a few small ones).

- All Japanese Translate (jtrans 1.9.1, CurseForge only, 52.7 MB): `side = "client"` was set by hand (packwiz marked it `both`; the CurseForge environment is Client and its hooks target client classes). No dependency is needed beyond Forge and Minecraft. It is a code mod: Mixins on `Font.drawInBatch`, `GuiGraphics.drawString`, the tooltip gather in `ForgeHooksClient`, `LiteralContents` and `Language.loadFromJson`, all with `required: false`. Its `mods.toml` lists about 1,370 optional mods with `ordering = "AFTER"`, so (inference) its text wins over a mod's own Japanese for the same key. It is the only one of the two that covers Xaero's Minimap, Shoulder Surfing Reloaded, Create's EMI keys and LR Tactical.
- Japanese Language Pack (V57, Modrinth, 4.2 MB): a resource pack with only `ja_jp.json` files (its `assets/minecraft/lang/ja_jp.json` holds only keys of mods that are not installed, so it does not touch vanilla text). `side = "client"` was set by hand. It is the last entry of `resourcePacks` in `config/defaultoptions/options.txt` (top slot, as its author asks), `pack_format` is 15, so it needs no `incompatibleResourcePacks` entry. It covers what jtrans does not: Punchy! 710 keys, AsyncParticles 156, Optimized Block Entities 63, Cubes Without Borders 36. A pack above jtrans wins for the same key.
- Do not add Sodium 日本語訳, EUJT or Sodium Japanese Localization: jtrans already covers the `sodium` and `embeddium` namespaces (65 and 7 keys). Do not add AutoTranslation (online machine translation through Google, last release 2023-12) or its fork.
- The 251 left keys can be filled by a small resource pack written for this pack if they matter. Not built.

## Reviewed 2026-11-23 (not added, decision pending)

Each has an evidence folder under `refs/comparisons/`. Update this list when the user decides.

- Opticores: not recommended (`igpu-culling/`). Overlaps Entity Culling, Chloride and the particle mods.
- Fast Item Frames: changes mechanics (frames become blocks) (`item-rendering/`).
- ThreatenGL: not recommended for the shared pack (`opengl-context/`).
- NoRollback: little effect on 1.20.1 (`movement-rollback/`).
- MixinBooster: do not add (`mixin-library/`). A library, not an optimizer.
- Iris & Oculus Flywheel Compat: do not add, Colorwheel declares it incompatible (`flywheel-shader-compat/`).
- Shader packs (`shader-packs/`): decided 2026-11-23, see Shader Packs below. Other candidates of the comparison are not added.
- TACZ 1.2.0 (not installed, the pack has 1.1.8-hotfix2): decision pending. See Shader Packs below.
- Japanese localization (`japanese-localization/`): decided 2026-11-24, see Japanese Localization below. Other candidates of the comparison are not added.

## Added 2026-11-24: content mods

Chosen by the user from `refs/comparisons/content-additions/`. A Mixin scan of the new jars against the 91 jars installed then found no hard conflict (same `@Redirect` or `@ModifyConstant` call, or `@Overwrite`). Settings stay at the mods' defaults; nothing is shipped.

- Sides: Waystones, Touhou Little Maid, Mekanism, Mekanism Generators, Create Crafts & Additions, Applied Energistics 2, Iron's Spells 'n Spellbooks, Botania, Deeper and Darker, End Remastered, Zombie Awareness, Spawn Animations and True Ending are `side = "both"`. 3D Skin Layers is `side = "client"` (its `mods.toml` has `clientSideOnly=true`). No other new jar declares a client-only mod (read from the jars).
- Libraries, each `both`: GuideME (AE2), GeckoLib, Iron's Lib and playerAnimator (Iron's Spells; Modrinth lists no dependency for it, so packwiz did not add them), Patchouli (Botania), CoroUtil (Zombie Awareness). Remove each with its last user. Iron's Spells needs GeckoLib 4.8.2 or newer, Iron's Lib 1.20.1-2.x and Curios 5.14.1 or newer; the installed Curios is exactly 5.14.1, so do not downgrade it.
- Spawn Animations and True Ending are the Forge `+mod` builds (data packs wrapped as mods; True Ending uses the `lowcodefml` loader and has no code). Modrinth lists both as data packs; a data pack zip would not be distributed by packwiz. Spawn Animations: MidnightLib is optional (global config file and menu), and the pack's MidnightLib is client-only, so a dedicated server runs without it. Pehkui (optional) hides entities that have emissive layers on 1.20.4 and below and smooths the animation; it is not installed. Spawn Animations Compats is optional too.
- Zombie Awareness has no official add-on. TACZ-Sound Attracts Zombies (Modrinth `tacz-sound-attracts-zombies`, by EarthX_X; Zombie Awareness is by Corosus) makes TaCZ gunfire alert zombies; without it gunshots do nothing, because Zombie Awareness only hooks `ServerLevel.playSeededSound` and `levelEvent` (its issue 136 asks for more sound sources and is open). Added later the same day (see "Second batch" below). The `Doom Sounds for Zombie Awareness` resource pack only changes the zombies' alert sounds. Defaults (read from the source): all senses on, `daysBeforeFeaturesActivate` 0, extra spawning and wandering hordes off.
- Almost Unified and its add-on Almost Unify Everything were first judged unneeded and were added later the same day, after Superb Warfare raised the overlap (see "Second batch" below). At that first check, item tags under `forge:` and `c:` of the 91 installed jars plus the new ones overlapped in only two tags: `dusts/diamond` (Create Crafts & Additions and Mekanism) and `dusts/obsidian` (Create and Mekanism). Ores, ingots, nuggets, plates and rods do not overlap (Mekanism: tin, lead, osmium, uranium, steel, bronze; Create: zinc, brass; Create Crafts & Additions: electrum, rods, wires). Revisit when another mod adds copper, tin, lead, silver, nickel or zinc a second time. Every one of the five newest 1.20.1 builds of Almost Unified is tagged beta.
- Botania: the client config key `rendering.shaders` (default `true`, "Set this to false to disable the use of shaders for some of the mod's renders. (Requires game restart)", read from the source) is not shipped. Set it to `false` only if mana pools or pylons render wrong under a shader pack (see `refs/issues.md`).
- Touhou Little Maid has an open server crash on long-distance teleports (see `refs/issues.md`). Added on the user's word ("for now").

## Added 2026-11-24: second batch

Chosen by the user after the first batch (evidence: `refs/comparisons/content-additions/`, `refs/comparisons/superb-warfare/`). All are `side = "both"`: Superb Warfare, Vanilla Backport, Almost Unified, Almost Unify Everything, TACZ-Sound Attracts Zombies, and the libraries Platform and Kotlin for Forge. None of the new jars declares client-only. A Mixin scan against the 111 installed jars (91 before, plus the 20 of the first batch) and against each other found no hard conflict.

- Superb Warfare 0.8.9.2 (Modrinth, 42 MB): `modLoader = "kotlinforforge"`, so Kotlin for Forge 4.12.0 (required, `loaderVersion [4.11.0,)`) is installed. It bundles Ponder 1.0.91 and Flywheel 1.0.5 (the same versions as Create 6.0.8), Cloth Config 11.1.106, Curios 5.14.1, GeckoLib 4.4.6 and SimpleBedrockModel 2.5.1; the pack's newer GeckoLib 4.8.5 and Cloth Config 11.1.136 should win (not run). Do not add GeckoAnimFix: Superb Warfare declares it incompatible. Block destruction by explosions stays on, which is the mod's default (user's choice, 2026-11-24); the switch is `explosion_destroy` in the world's `serverconfig/superbwarfare-server.toml` or `/sbw config explosionDestroy`. Its TaCZ hook (`EntityUtil.getHitResult`) exists in TaCZ 1.1.8-hotfix2 and all 8 TaCZ member references in its jar resolve (checked class by class). A TaCZ update can move it.
- Vanilla Backport 1.2.2: Platform 1.4.2 is required and installed. All 454 references from Vanilla Backport to Platform resolve. Remove Platform with the last mod that uses it (Vanilla Backport is the only one).
- Fallen trees: Bedrockoid's `fallenTrees` is `false` (`config/bedrockoid-config.toml`, see `refs/settings.md`); Vanilla Backport's `fallen_trees` stays on. Bedrockoid 0.2 (2026-11-22) is out; the pack has 0.1.2. 0.2 adds `bigFallenTrees` and a crash fix.
- Almost Unified 0.11.0 (the 1.20.1 builds are tagged beta) and Almost Unify Everything 1.0.2.9: with Superb Warfare, 12 item tags carry items of 2 or more mods (`ingots/lead`, `ores/lead`, `raw_materials/lead`, `storage_blocks/lead`, `storage_blocks/raw_lead`, `ingots/steel`, `storage_blocks/steel`, `dusts/iron`, `dusts/coal`, `plates/copper`, `dusts/diamond`, `dusts/obsidian`). Almost Unify Everything is a 12 KB add-on of 2 classes with 2 references into Almost Unified; both resolve in 0.11.0. It was built in 2024-10 against an older Almost Unified, so a later Almost Unified release can break it. It hooks `BlockStateBase.getDrops` at the head; no installed mod hooks that method.
- TACZ-Sound Attracts Zombies 1.1.0 (Modrinth, EarthX_X, 12 KB, no repository): listens to TaCZ's `GunFireEvent` and `GunReloadEvent` and calls Zombie Awareness's `ZAUtil.hookSoundEvent`, with a silencer check. All 10 references to TaCZ 1.1.8-hotfix2 and Zombie Awareness 1.13.1 resolve. Its `mods.toml` declares no dependency on either mod, so without TaCZ or Zombie Awareness it would probably fail when its handler class loads (inference). Remove it together with whichever of the two goes first.

## Reviewed 2026-11-24 (not added, decision pending)

The user proposed 19 content mods (`refs/comparisons/content-additions/`). Update this list when the user decides.

- Wither Storm: do not add. Open reports with Oculus, Embeddium and Distant Horizons on 1.20.1 Forge.
- Ice and Fire: if added, prefer Ice and Fire Community Edition (`iceandfire-ce`, not save-compatible with the original). The original has only a beta and an open Distant Horizons crash. It needs Uranus (and Architectury) and Jupiter instead of Citadel.
- Ars Nouveau: not chosen (Iron's Spells and Botania were).
- Vanilla Backport and Superb Warfare were decided later the same day: see "Second batch" above.

## Optimization Mods

- Overlapping features were checked and are complementary:
  - Embeddium frustum culling, Entity Culling (occlusion), and Chloride distance culling.
  - Embeddium "animate only visible textures" and Kerria.
  - Gnetum and ImmediatelyFast (recommended together by Gnetum).
  - Immersive Optimization (server entity ticks) and Entity Culling tick culling (client).
  - AsyncParticles and BadOptimizations: fixed since AsyncParticles 20.1.1.0. The pack has 20.1.4.4.
  - Harium auto-disables `mixin.alloc.blockstate` when FerriteCore is present. Its `mixin.block.redstone_wire` stays at default beside Alternate Current. No conflict is documented.
- GPUBooster on Forge 1.20.1 is the `1.0.5.1-forge` build (VRAM leak fix, no config).
- Ksyxis is not installed. ModernFix's `remove_spawn_chunks` replaces it. Do not add both.
- Yeetus Experimentus (`side = "client"`, Forge, no dependencies, no config) hides the experimental-settings confirmation at world creation and in the datapack screen of world creation. It also skips a confirm branch when a world is loaded (`loadLevel` calls `doLoadLevel` with `false, false`, vanilla uses `false, true`; probably the backup prompt). It was chosen from the comparison in `refs/comparisons/experimental-warning/`. Do not add another mod that hooks `confirmWorldCreation` beside it.

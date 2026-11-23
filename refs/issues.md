# Issues

Problems found so far in installed mods. Status: `open` is known and unresolved, `unverified` is not tested or not confirmed, `by design` is an accepted trade-off, `resolved` is fixed.

## General

- Nothing was tested in-game, and no FPS or TPS was measured. Measure with `spark` before tuning further. (`unverified`)
- Source or jars were read only for Distant Horizons, Chloride, Solix, Immersive Optimization, Entity Culling, Gnetum, Kerria, Ixeris, Harium, ModernFix and Embeddium (not the exact pinned tag). The defaults of ImmediatelyFast, BadOptimizations, AI Improvements, Clumps, Let Me Despawn, Dynamic FPS, Oculus and Optimized Block Entities rest on the authors' descriptions. (`unverified`)
- Read for the 2026-11-22 additions: FastSuite (branch 1.20 source, top of changelog is 5.1.2), Weather Refined (Forge 1.20.1 source), CreateBetterFPS (`mods.toml` and mixin config of the pinned jar), ModernFix 5.27.91 (pinned jar: `dynamic_dfu` is on by default and `config/modernfix-mixins.properties` does not override it). The effect of every added mod is not measured. (`unverified`)
- Memory and JVM arguments cannot ship in an `.mrpack`. Set them in the launcher. (`by design`)

## Key Binding Patch, Controlling

- Key Binding Patch (Forge, refmap included) mixes into `KeyMapping`, `Options`, `KeyBindsList`, `KeyBindsScreen` and `KeyEntry`. Controlling has accessor mixins only. Their combination is not tested in-game. (`unverified`)
- Key Binding Patch triggers every key binding that shares one key, unlike vanilla. Two mods with the same default key can fire together. (`by design`)
- Whether Key Binding Patch interacts with TaCZ, Mine Menu, Ixeris or Shoulder Surfing Reloaded is not checked. (`unverified`)

## Punchy!, Punchy! Moves

- Punchy! 3.2b (release) and Punchy! Moves 1.0.9b (beta) were added on 2026-11-22. Both are Forge 1.20.1 builds with a refmap. Neither was tested in-game. (`unverified`)
- Punchy! draws held items itself. TaCZ, LR Tactical and Create items can render twice or fight the animation. Fixes: the F8 blacklist (per item, per player) or Don't Punch My TACZ (not installed). (`open`)
- Punchy! Moves has a shoulder camera (`CameraMixin`, `GameRendererMixin`, `MouseHandlerMixin`) and Shoulder Surfing Reloaded has its own. Which one wins, or whether they conflict, is not checked. (`unverified`)
- Punchy! and Punchy! Moves both mix into `Camera`, `GameRenderer`, `LevelRenderer` and `LivingEntityRenderer`. Their interaction with Embeddium, Oculus, Distant Horizons and TaCZ is not checked. (`unverified`)
- Punchy! Moves shows nothing without the Fluid & Foolish resource pack. The pack is enabled at first launch by the `resourcePacks` key in `config/defaultoptions/options.txt`, which names the file `Fluid & Foolish 1.0.1.zip`. If `packwiz update` renames the file, the game drops the entry with a warning and the pack stays off. Existing instances keep their own `options.txt` and must enable it by hand. (`by design`)

## Yeetus Experimentus

- Added 2026-11-22 from the comparison in `refs/comparisons/experimental-warning/`. packwiz picked `2.3.0-build.4`, which Modrinth lists after `2.3.1`. The class files of both builds have the same sizes. It was not run in-game. (`unverified`)
- It also changes `WorldOpenFlows.loadLevel`: `doLoadLevel` is called with `false, false` instead of vanilla `false, true`. The fourth argument gates a confirm screen, probably the backup prompt for worlds from another version. Loading such worlds shows no prompt. (`by design`)
- Its mixins use `defaultRequire = 1`. All targets exist in Forge 47.4.28, but a Forge update that changes `WorldOpenFlows` or `CreateWorldScreen` would stop the game at launch. (`unverified`)
- Interaction with ModernFix `extra_experimental_screen` and The Aether's `WorldOpenFlowsMixin` is not tested. (`unverified`)

## FastQuit

- A launch crash log from 2026-11-22 ended with `FastQuit` `ExceptionInInitializerError` (`ModList.get()` is null in `FastQuitConfig.<clinit>`). FastQuit's crash hook ran before FML had a mod list, so it only hid the real error. The cause was the removed Amecs and NMUK (see `refs/notes.md`). (`by design`)

## ModernFix, Harium

- `mixin.perf.remove_spawn_chunks` stops farms and machines around the world spawn when no player is near. Use `/forceload` for areas that must keep running. ModernFix's own text says it removes spawn chunks entirely, unlike Ksyxis. The difference from Ksyxis was not verified. (`by design`)
- Harium's redstone mixin stays at default beside Alternate Current. No conflict is documented, but whether it is active or effective is unconfirmed. (`unverified`)

## Distant Horizons, entity distance

- The server-side `maxGenerationRequestDistance` has a lower bound of 256, so it cannot match the 64-chunk LOD range. Whether clients stay within their own 64 chunks was not confirmed. (`unverified`)
- `simulationDistance` in `options.txt` applies to singleplayer only. A server uses `server.properties`. (`by design`)
- `entityDistanceScaling:2.0` with Chloride `entityDistanceX=16384` is the most expensive of the minimum settings. The FPS impact is not measured. Block entities (chests, signs) stay at 64 blocks through Chloride `tileEntityDistanceX` and Optimized Block Entities. (`unverified`)

## AllTheLeaks

- Its README disables a fix when the original mod already fixes the leak. Whether the Aether 1.5.2 fix is active depends on the version range and was not checked. It is Mixin-heavy, so compatibility with other mods is not guaranteed. The effect can be checked in the F3 memory display. (`unverified`)

## EMI, JEI, JEI/EMI Optimizations

- Plain JEI starts at world join. It registers all plugins and builds the search index before you can play, and EMI waits for JEI through JEMI. Other packs lost 4.4 s (a small 1.20.1 pack) to 15.6 s (ATM10) in the TMRV author's benchmark. This pack is not measured. Check `Starting JEI took X s` and `Reloaded EMI in X ms` in `logs/latest.log`. (`unverified`)
- JEI/EMI Optimizations moves slow plugins and the search index to after the join, so recipes and search results can be incomplete for a minute or two. Its source is not public (the issue tracker URL in its `mods.toml` returns 404). It was published on 2026-10-20 and its benchmarks are the author's own. Compare with it disabled using the same test. (`unverified`)
- JEI is pinned by version id to the release `15.56.0.205`, which is also the minimum for JEI/EMI Optimizations. After `packwiz update`, confirm JEI did not move to a 15.75.x beta (it needs MezzConfig). (`unverified`)
- Interaction between the EMI and JEI search fields and InvMove or Mouse Tweaks is not checked. (`unverified`)

## Shoulder Surfing Reloaded

- ParCool issue 226: first-person camera animations do not work with Shoulder Surfing. It is open and was reported on ParCool 3.2.1.2 with Shoulder Surfing 3.2.0, not on ParCool 4.0.2.0 with 5.3.1. (`unverified`)
- Under Shoulder Surfing, TaCZ forces every gun to the adaptive crosshair (TaCZ issue 648). The maintainer's workaround is deleting `shouldersurfing_plugin.json` from the TaCZ jar. It is not applied. (`open`)
- On Forge 1.20.x, the in-game config screen may need Forge Config Screens (README). Without it, edit `shouldersurfing-client.toml`. (`unverified`)
- TaCZ issue 708 (crash from a missing `Perspective` class) does not apply: Shoulder Surfing 5.3.1 contains the class. (`resolved`)

## Mine Menu, Jade Addons

- Mine Menu has a server-side packet (`PacketUseItem`), so it is `side = "both"`. A client-only install on a server without it was not tested. (`unverified`)
- Mine Menu cannot trigger keybindings that need Ctrl, Shift or Alt (maintainer's answer in 2021, not rechecked on 1.20.1). Key combinations made with Key Binding Patch may not work from the wheel. (`unverified`)
- Jade Addons only does something with a supported mod (Create, Tinkers' Construct, SecretRooms, McJtyLib, Lootr, EnderIO, Supplementaries or Artifacts). Create was added on 2026-11-23, so the Create plugin is active now; not run. (`unverified`)

## Structure Layout Optimizer, FastSuite, FastWorkbench, FastFurnace

- Structure Layout Optimizer is `side = "both"` (like Immersive Optimization) so single-player worlds use it too. Modrinth lists it as server-only. It needs Resourceful Config, which the author says may stay on the server only. (`by design`)
- Structure Layout Optimizer: keep `deduplicateShuffledTemplatePoolElementList` off. It breaks seed parity and was linked to a Waystones generation problem (issue 16). Whether Twilight Forest or The Aether use Jigsaw structures was not checked. The benefit during Distant Horizons generation is an inference. (`unverified`)
- FastSuite parallelizes only recipes it knows are thread-safe (vanilla recipe classes with vanilla or Forge ingredients) and only for recipe types with 100 or more recipes. Mod recipe classes run on the main thread. It overrides only `getRecipeFor` and `getRecipesFor`. Whether Create's processing recipes use that path was not checked. Older versions had thread-safety crashes with TerraFirmaCraft, Mekanism and AE2. None of those mods are installed. Check `RecipeManager.getRecipeFor` in a spark profile before and after. (`unverified`)
- FastWorkbench hides the recipe book button by default. It is left at the default because EMI and JEI show recipes. Its config can bring the button back. (`by design`)
- FastWorkbench, FastFurnace and FastSuite share Placebo. Placebo is removed together with the last of the three. (`by design`)

## CreateBetterFPS

- Create 6.0.8 was added on 2026-11-23, so the mod is active now (it needs Create 6.0 or newer, Oculus 1.8.0 or newer and Embeddium 0.3.31-beta.53 or newer, all installed). Not run in the game. (`unverified`)
- It only helps with a shader pack on. Flywheel switches itself off under Oculus shaders, and that is the main cause of low Create FPS. CreateBetterFPS covers addon models, speed controllers, factory gauges and schematic previews. Colorwheel (installed) covers the rest. Colorwheel's page lists CreateBetterFPS as compatible. (`unverified`)
- The tracker has issue 18 (open): with Oculus 1.8.0 and 1.1.3 on 1.20.1 Forge, shadows of contraptions and cogwheels disappear. Modrinth's newest Forge 1.20.1 file is 1.1.2, while the CurseForge page lists 1.1.3. (`unverified`)
- The author plans to merge the code into Create. If that happens, the mod is abandoned. (`by design`)

## Colorwheel

- Crash without Flywheel (seen 2026-11-23 on the ohm instance, crash reports 23.30.51 and 23.31.34): Colorwheel 1.3.2 logs "Flywheel is not installed, Colorwheel will be disabled", but its Iris `ShaderPackMixin` still runs. Selecting any shader pack that has `shaders/colorwheel.properties` stops the game with `NoClassDefFoundError: dev/engine_room/flywheel/api/material/Transparency` in `ClrwlShaderProperties.<init>`. Affected packs in the pack: Complementary Reimagined, Mellow, I Like Vanilla, Solas, and BSL patched by Colorwheel Patcher (`BSL_v10.1 + Clrwl_1.0.5.zip`). Plain `BSL_v10.1.zip` has no such file and is safe. The selection is saved in `config/oculus.properties` (`shaderPack`, `enableShaders=true`), so the game crashes again on every launch until `enableShaders` is `false`. 1.3.2 is the newest 1.20.1 Forge build, no Colorwheel issue for it was found, and Modrinth has no standalone Flywheel for 1.20.1 Forge (only a 2023 project; Create 6 carries Flywheel). It ends when Create is added or Colorwheel is removed. Create 6.0.8 was added on 2026-11-23 (the user's choice); its bundled Flywheel 1.0.5 contains `Transparency` (read from the jar), so the crash should end. Not run: confirm by selecting each shader pack with Create in the pack. (`unverified`)
- Colorwheel needs Oculus 1.7.0 or newer; the pack has 1.8.0. (`by design`)
- Its mixins also target Create and Ponder classes (`create.ClientEventsMixin`, `ponder.*`). Create was added on 2026-11-23 and has not been launched yet; that launch is the first real test. (`unverified`)
- Shader packs with official support work as they are: Complementary Unbound/Reimagined from r5.7, Euphoria Patches from 1.7.0, Photon from 1.4, Solas, Spooklementary, Steadfast, and others on its page. Others (BSL 10.1, Complementary 5.6, Rethinking Voxels, and others) need Colorwheel Patcher, which was installed on 2026-11-23 (see Shader Packs below). Any other pack runs in fallback mode with rendering flaws. Shader packs in the pack: BSL 10.1 and Complementary Reimagined r5.10. (`open`)
- It is incompatible with Iris & Oculus Flywheel Compat (conflicting mixins, declared in its `mods.toml`). That mod must not be added. (`by design`)
- Ocuwheel was checked and not added. Its jar requires Create 6.0.8 or newer (the pack would not start without Create), hooks the same Iris and Flywheel classes as Colorwheel (ProgramSource, ProgramSet, IrisRenderingPipeline, ShaderPackSourceNames, MeshHelper, MeshEmitter), and patches shader pack GLSL at runtime, the approach Colorwheel's docs call partial at best. No source repository was found. Running it beside Colorwheel is expected to conflict (inference from the mixin targets, not run). (`unverified`)
- Vanillin (optional for Colorwheel) is not installed. (`by design`)

## Weather Refined

- It comes from CurseForge only. `side = "client"` was set by hand because the CurseForge page says Client and Server while the `mods.toml` declares `displayTest = IGNORE_ALL_VERSION` and every dependency as client. (`by design`)
- With an Iris or Oculus shader pack on, the default AUTO mode uses vanilla weather. The Embeddium `weather_quality = FAST` setting applies in that case. (`by design`)
- It adds particles through `ParticleEngine.add`, so the pack's `particles:2` (Minimal) does not hide them. Compatibility with AsyncParticles and Kerria is not documented. Whether it is lighter than vanilla rain with `weather_quality = FAST` is not measured. (`unverified`)

## Enhanced Boss Bars, Async Locator, Fast Items, Leaves Be Gone

- Added 2026-11-23. None of the four, nor MidnightLib and Puzzles Lib, was run in the game. (`unverified`)
- Conflict scan: the Mixin classes of the 72 installed Modrinth jars were searched for the classes these mods hook. The six CurseForge jars and nested jars were not scanned. (`unverified`)
- Enhanced Boss Bars: `override_all_boss_bars` is `false` by default and its effect was not confirmed (the author says all vanilla bars are replaced). The Aether cancels Forge's `BossEventProgress` for its own bars, which may interact with Enhanced Boss Bars' Aether designs. BetterF3, Gnetum and ImmediatelyFast also hook `BossHealthOverlay`. (`unverified`)
- Fast Items: Flerovium (`ItemEntityRenderMixin`) redirects `getRenderAmount` inside `ItemEntityRenderer.render`, which Fast Items cancels at the head, so that part of Flerovium is probably bypassed. Seven other installed mods (Embeddium, Flerovium, Gnetum, ModernFix, Oculus, Punchy!, Punchy! Moves) also mix into `ItemRenderer`; none was checked method by method. Dropped TaCZ items were not checked. (`unverified`)
- Async Locator: its only Forge 1.20.1 build is from 2023-06 and it covers vanilla locating only. Twilight Forest and The Aether structure searches are not covered unless those mods call it. (`by design`)
- Leaves Be Gone: its only Forge 1.20.1 build is from 2023-06. Decay time is 5 to 20 ticks by default. Behavior with Twilight Forest and Aether leaves was not tested. (`unverified`)
- Puzzles Lib has `displayTest = MATCH_VERSION`: a client and a server with different versions fail the mod list check. The pack ships one version to both. (`by design`)

## Chloride (fullscreen, Fast Chests and Fast Beds), Cubes Without Borders, Quick Pack

- Cubes Without Borders (`fullscreenMode = BORDERLESS`, `useDelayedFullscreen = false`) and Chloride (`fullscreen.mode = BORDERLESS`) are both first-launch defaults (2026-11-24). Both hook the same two calls in `Window.setMode`, `glfwSetWindowMonitor` and `glfwGetWindowMonitor`: Chloride as `@Redirect`, Cubes Without Borders as `@WrapOperation`. Both were read from the jars, not run. The game did start with both installed on 2026-11-23, so the mixins apply; what the window looks like was not seen. (`unverified`)
- Risk: Chloride's redirect sets `GLFW_DECORATED` to true after every `glfwSetWindowMonitor` call that is not its own borderless path (mode other than `BORDERLESS`, or a call with monitor 0). If that runs after Cubes Without Borders makes the window borderless, the title bar comes back and the window looks windowed. First-launch check: the title bar must not show. If it does, remove Cubes Without Borders and keep Chloride's `fullscreen.mode = BORDERLESS` (the 2026-11-23 setup). (`unverified`)
- The "Windowed" seen on 2026-11-23 had two possible causes: (a) Chloride's selector shows its config value `fullscreen.mode`, not the real window state; (b) the `GLFW_DECORATED` reset above. The earlier explanation (Chloride's startup check forcing windowed) does not hold when Cubes Without Borders' delayed fullscreen is on, because the vanilla `fullscreen` option is `false` at that point and Chloride's `WINDOWED` matches it. It was not run, so the cause is open. (`unverified`)
- F11 is Chloride's: it always cancels the vanilla toggle and cycles windowed, borderless and fullscreen (`attachModeF11 = ATTACH`). Cubes Without Borders' mode selector replaces the Fullscreen button of the vanilla Video Settings; Embeddium has its own video options screen with a Fullscreen toggle, and whether the selector shows anywhere else was not checked. Cloth Config is installed for Cubes Without Borders' config screen. (`unverified`)
- Chloride `fullscreen.mode = BORDERLESS` was read from the jar. The author says the borderless-leave black blink on multi-monitor setups is fixed by `disableBorderlessOptimizations`, at the cost of frame rate. (`unverified`)
- `useDelayedFullscreen = false` goes against the Cubes Without Borders default. Its tooltip says the delay can fix rare issues on systems with faulty drivers that cannot enter fullscreen at once at a different resolution. (`unverified`)
- Chloride Fast Chests and Fast Beds are on by request. Optimized Block Entities (installed) also optimizes chests and beds and keeps the animation, so the two overlap; Fast Chests removes the chest animation. Chloride warns that Fast Beds may break modded beds. The combination was not run. (`unverified`)
- Embeddium `leaves_quality = FAST` with vanilla `graphicsMode:0` makes leaves opaque. Players who switch to Fancy leaves get the vanilla look because Chloride `leavesCulling` is left at `OFF`. (`by design`)
- Quick Pack: its open issue #18 ("Instant Reload conflict", delays when moving around the world) names a mod that is not installed. It hooks `SpriteLoader` and `FilePackResources`; ModernFix `faster_texture_stitching` hooks `Stitcher`. Not run together. (`unverified`)

## Entity packs, EMF, ETF, EntityModelShaderFix

- Added 2026-11-23: Fresh Animations 1.11.2, Melody's Cute Girl Villagers 1.11.1 (`pre-26.1`), Witches 1.0.1, Illagers 1.0.1, Traders 1.0.0 (`pre-26.1`), Piglin-Chan v2.0, Iron Girl v2.0, EMF 3.3.12, ETF 7.2.7, EntityModelShaderFix 1.2.0. None was run in the game. (`unverified`)
- Emissive (glowing) entity textures from packs do not work with Flerovium enabled (Flerovium issue 56, open). Oculus alone also loses emission in the Flerovium author's test. The user accepted this. (`by design`)
- The first-launch list depends on `incompatibleResourcePacks` keeping five packs enabled. That the game keeps them was read from `Options.loadSelectedResourcePacks` in the 1.20.1 client jar, not run. The red warning and the confirm dialog stay in the pack screen. (`unverified`)
- Iron Girl ships a `witch.jem` and `cem/witch.png`. Melody's Witches must stay above it or the witch changes. (`by design`)
- Piglin-Chan has plain 64x64 textures that sit above Fresh Animations' piglin textures and models (also 64x64). Whether the UV layouts match was not compared. (`unverified`)
- Melody's Cute Girl Villagers lists a known EMF bug: the level 5 profession texture shows for all profession levels. (`open`)
- The Melody packs carry textures for mods that are not installed (Shiny Mobs, It Takes a Pillage, and others). They do nothing here. (`by design`)
- Fresh Animations overrides the animation of every mob the girl packs replace; those mobs lose Fresh Animations' animation. (`by design`)
- EMF and ETF mix into `ModelPart` and `EntityRenderDispatcher` like Embeddium, Flerovium, Oculus, Punchy!, Punchy! Moves, ParCool and TaCZ do. No conflict was found by reading; none was ruled out by running. (`unverified`)
- EntityModelShaderFix and Colorwheel both have a mixin named after `FullyBufferedMultiBufferSource`. Their targets were not compared. (`unverified`)

## Shader Packs: BSL, Complementary Reimagined, Colorwheel Patcher

- Added 2026-11-23. None was run in the game. The shader zips were read as text (shadows, reflections, water programs and Distant Horizons programs exist in both packs). (`unverified`)
- TACZ scope with shaders: Oculus issue 797 (open, 2025-04-15, Oculus 1.8.0 and Embeddium 0.3.31): a TACZ scoped weapon causes rendering errors at once; with BSL they stay until the shader is reloaded, with Photon the game crashes after a few minutes. TACZ issue 662 (open, 2026-03-25): the scope shows a black band or a black screen when Distant Horizons and a shader pack (Bliss, Complementary) are on, worse after F11; reloading the shader or toggling DH does not fix it for good. The pack has TACZ 1.1.8-hotfix2, Oculus 1.8.0, Embeddium 0.3.31 and DH 3.3.3, the same stack. No mod fixes it. TACZ 1.2.0 may help and is not installed. (`open`)
- Out-of-memory crash with shaders on Oculus and TACZ (TACZ issue 755, closed 2026-11-06; Oculus issues 678 and 725): the TACZ maintainer ties it to Oculus separate entity draws and says 1.2.0 overhauled the rendering. The pack still has 1.1.8-hotfix2. (`open`)
- BSL is pinned to 10.1 for Colorwheel Patcher (see `refs/notes.md`). The patcher's version match is read from its `config.json` and class names, not run: the instance log of 2026-11-23 confirms it: `BSL_v10.1.zip` was patched into `BSL_v10.1 + Clrwl_1.0.5.zip`, Complementary r5.10 was skipped ("version is unknown or unsupported"), and I Like Vanilla, Mellow and Solas have no patch. How the patched BSL renders Create contraptions is not run. Patcher 1.0.5 was built for Colorwheel 1.0; the pack has Colorwheel 1.3.2. (`unverified`)
- BSL: Oculus issue 592 (flickering white dots at block seams, a commenter blamed the mod Handcrafted, which is not installed). Vanilla clouds missing with BSL (Oculus issue 355) was reported on 1.19.2 and a commenter says the 1.20.1 build fixed it. (`unverified`)
- Complementary: Oculus issue 868 (open, Unbound sky wrong on Oculus 1.8.0.1) and issue 858 (open, enchantment glint items turn black, reported with shaders off too). Not reproduced. (`unverified`)
- Mellow, I Like Vanilla and Solas (added 2026-11-23): not run. Mellow's page says "Please use the latest Iris version (any version that supports custom uniforms should work)" and its 3.5 notes say "Restored compatibility with Oculus". Mellow's `DYNAMIC_SHADOWS` is off by default (see `refs/notes.md`). Solas's Oculus issues 116 and 75 are closed; Oculus issue 772 (Antique Atlas map turns transparent) is open and not checked against the installed mods. (`unverified`)
- Oculus 1.8.0 has no `FADE_VARIABLE` Iris feature. BSL 10.1.8 and Complementary r5.10 declare it optional, so they run without it. (`by design`)
- Colorwheel Patcher puts a second BSL entry ("+ Clrwl") in the shader list at launch. Oculus 1.8.0 lists every valid zip or folder in `shaderpacks/` and has no setting to hide one, and no mod for it was found on Modrinth (Forge 1.20.1). The patched zip is a full pack (it holds all of BSL plus the `clrwl_*` programs), so it still works if the plain `BSL_v10.1.zip` is deleted from the instance; a pack update or a new import brings the plain file back. (`by design`)
- Selecting the plain `BSL_v10.1.zip` (seen 2026-11-23) prints a chat alert, "[Colorwheel] The shader pack BSL_v10.1.zip is not compatible. You should select BSL_v10.1 + Clrwl_1.0.5.zip in the Shader Packs menu instead", and the Flywheel backend falls from `colorwheel:indirect` to `flywheel:off`, so Create contraptions lose GPU rendering. The pack still loads. The alert is the `alertIncompatiblePack` key of `config/colorwheel-client.toml` (default `true`; there are also `alertBrokenPack` and `enableFallbackMode`, default `false`). Nothing is shipped for it. (`by design`)
- Clouds with shaders off (user report 2026-11-24, `renderClouds:"false"` in `options.txt`): Distant Horizons 3.3.3 draws its own LOD clouds through `CloudRenderHandler`, switched by `client.advanced.graphics.genericRendering.enableCloudRendering` (default `true`) and not by the vanilla option. Its `overrideVanillaGraphicsSettings = true` only turns the vanilla clouds off. The pack now ships `enableCloudRendering = false` (see `refs/settings.md`); existing instances keep their old value. Not run to confirm the clouds are gone. (`unverified`)
- Clouds with shaders on: the vanilla "Clouds" video option (`renderClouds:"false"` in this pack) only controls vanilla clouds. Each shader pack draws its own clouds by default: BSL `CLOUDS` is 2 (Volumetric; 3 is Vanilla and needs the vanilla option on), Complementary `CLOUD_STYLE_DEFINE` is -1 (the style's own clouds; 0 is OFF), Mellow `CLOUD_STYLE` is 1 (Flat; 0 is Vanilla, there is no OFF value), I Like Vanilla `CLOUDS_TYPE` is -1 (the style's own clouds; no OFF value), Solas has `VOLUMETRIC_CLOUDS` and `PLANAR_CLOUDS` on and `VANILLA_CLOUDS` off. Solas and Mellow also set `clouds=off` in `shaders.properties`, which Oculus applies in place of the vanilla option (inference from its class `MixinOptions_CloudsOverride`; the logic was not read). Distant Horizons logs "Disabling vanilla clouds" on its own. Nothing is shipped to turn the shader clouds off. (`by design`)

## Create

- Added 2026-11-23 (6.0.8, from the comparison in `refs/comparisons/create-flywheel/`). Not run in the game. No installed mod declares an incompatibility and no conflict report was found, but how Create's Flywheel backends (through Colorwheel) behave beside Embeddium, Flerovium, Oculus, Entity Culling, ImmediatelyFast and Optimized Block Entities is untested. (`unverified`)
- Create's config is not shipped; the defaults apply. The Flywheel backend setting was not read. (`unverified`)

## All Japanese Translate, Japanese Language Pack

- Added 2026-11-24 (jtrans 1.9.1, Japanese Language Pack V57). Neither was run in the game. The coverage numbers (see `refs/notes.md`) count key presence against the pinned jars, not text quality or what the game shows. (`unverified`)
- jtrans hooks text drawing with Mixin (`Font.drawInBatch(String...)`, `Font.width(String)`, `GuiGraphics.drawString` and `drawCenteredString`, `ForgeHooksClient.gatherTooltipComponents`, `LiteralContents`). ImmediatelyFast (`MixinDrawContext`, `MixinFontManager`, `MixinTextRenderer_Drawer`), Embeddium, Gnetum, EMI, BetterF3, Chloride and FastQuit also mix into `Font` or `GuiGraphics`. No method-by-method check was done and the per-frame cost is unmeasured. Compare frame time and the log with and without it. (`unverified`)
- jtrans declares about 1,370 optional dependencies in `mods.toml`; the effect on startup time is not measured. The jar is 52.7 MB and the `.mrpack` grows from 23.6 MB to roughly 70 MB. (`unverified`)
- jtrans releases fast (about 23 files between 2026-09-02 and 2026-11-21, one author) and its translations match one version of each mod. A mod update can leave some keys in English. After `packwiz update`, check that Create, Twilight Forest, The Aether and TaCZ still show Japanese. (`by design`)
- jtrans text replaces the official Japanese where both exist (inference from its load order): for ModernFix, JEI, The Aether, Jade and BetterF3 its wording differs from the official one in most keys, for Create, EMI, Twilight Forest and TaCZ it is almost identical. (`by design`)
- The Japanese Language Pack entry in `resourcePacks` names the file `AzukiV57.zip`. If `packwiz update` renames the file (V58 and later), the game drops the entry with a warning and the pack stays off; update the key. Existing instances keep their own `options.txt` and must enable it by hand. (`by design`)
- 251 text keys stay English after both: Punchy! Moves 134, Remove Reloading Screen 29, Bedrockoid 25, Shoulder Surfing Reloaded 23, Punchy! 18, Weather Refined 6, JEI/EMI Optimizations 6, Fast Items 5, Key Binding Patch 3, Distant Horizons 1, Chloride 1. (`open`)
- Not counted: Patchouli books, quests, advancements, and lang files nested in jars. TaCZ's default gun pack has its own official `ja_jp.json` (checked in the jar). (`unverified`)

## Content mods (added 2026-11-24)

- Waystones, 3D Skin Layers, Spawn Animations, Deeper and Darker, Mekanism, Mekanism Generators, Create Crafts & Additions, Applied Energistics 2, Iron's Spells 'n Spellbooks, Botania, Zombie Awareness, End Remastered, True Ending and Touhou Little Maid, with their libraries. None was run in the game. The Mixin scan (`refs/comparisons/content-additions/`) compares class, method and hooked call only; it cannot see behavior, registry or world generation conflicts. (`unverified`)
- Touhou Little Maid: open crash on long-distance teleports (TouhouLittleMaid issue 1146, 1.20.1 Forge 47.4.16 confirmed 2026-11-16, also 1.21.1 NeoForge). The mod's own `PersistentEntitySectionManagerMixin` walks the live `chunksToUnload` set at `processUnloads()` (the same hook is in the jar, `tick` at `processUnloads()V`) while `handleChunkPreUnload` calls `maid.teleportToOwner`, which changes it. The result is `ConcurrentModificationException` or `ArrayIndexOutOfBoundsException` in `Exception ticking world`. The mixin was copied from Snownee's Companion, which fixed it on 2026-05-29; Touhou Little Maid 1.5.3 has no fix. The moving party is the player (any teleport that unloads the chunks around the old position); the maid is the one that gets pulled. A maid in home mode, sitting, sleeping, leashed or riding does not teleport, so it does not trigger it. Waystones teleports the player too (inference: not tested). (`open`)
- Botania: GitHub issue 3951 (open, reported on 1.18): shader packs break Botania's own shaders (invisible sparks, empty-looking mana pools, partly invisible pylons). Botania has no Iris or Oculus check (no such string in its classes). Whether Oculus 1.8.0 with build 456 shows it is unknown. Fix if it does: client config `rendering.shaders = false` (default `true`, needs a restart). (`unverified`)
- Applied Energistics 2 and FastSuite: AE2 issue 8772 (closed 2026-10-28, Minecraft 1.21 NeoForge) is a client crash on auto-filling the wireless crafting terminal; the AE2 author says the error is in FastSuite. The pack has FastSuite 5.1.2 on 1.20.1. Check a spark profile and the crafting terminal. FastSuite also had older thread-safety crashes with Mekanism (see Structure Layout Optimizer, FastSuite section). (`unverified`)
- Mekanism, Create and TaCZ: Mekanism issue 8609 (closed 2026-11-04, 1.21.1 NeoForge): TaCZ's hand animation breaks while the Mekasuit chestplate is worn; a commenter says Create's netherite backtank does the same. Not tested on 1.20.1. (`unverified`)
- Spawn Animations: issue 53 (open, 1.21.11): spiders invisible until close, the reporter suspects the Fresh Animations pack and entity culling (both installed). Emissive layers of Fresh Animations on hidden mobs: Pehkui is not installed (see `refs/notes.md`). The `wet-sand` mod (Fabric) broke it through the `#minecraft:sand` tag (issue 33); it is not installed. (`unverified`)
- 3D Skin Layers: it hooks `PlayerRenderer.setModelProperties` like Punchy! Moves, and `ModelPart.render` like Oculus, Flerovium and Shoulder Surfing Reloaded (plain injects). Issue 165 (open, 2024, 3D Skin Layers 1.6.6 with ParCool 3.2.1.2): the first-person hand layer warps while ParCool's sprint is on. The pack has 1.11.4 and ParCool 4.0.2.0. Its page says some skins fit badly with ETF/EMF packs, and shaders give odd shadows on some layer sides. (`unverified`)
- Deeper and Darker: issue 441 (open, 1.20.1 Forge): the game hangs when loading into the Otherside; one comment traces it to `OthersideColumnFeature` and `CrystallizedAmberBlockEntity.generateFossil()` while flying through unexplored chunks (Embeddium was named first, then ruled out). Distant Horizons misreading its dimension name (issue 386) was closed 2024-11-06, before 1.3.3. (`unverified`)
- Iron's Spells 'n Spellbooks: `@Overwrite` on `IForgeItemStack.canElytraFly` and `elytraFlightTick`; no installed mod hooks them. playerAnimator hooks `LivingEntityRenderer.render` like Punchy! Moves and ModernFix (a different call than ModernFix's); the cast poses beside Punchy! Moves are not tested. Iron's Spells needs Curios 5.14.1 (installed exactly). (`unverified`)
- End Remastered and Async Locator both hook `EnderEyeItem.use`: End Remastered injects at `Player.startUsingItem`, Async Locator redirects `findNearestMapStructure`, `signalTo` and others. Whether eyes of ender find a stronghold with both is not tested. (`unverified`)
- Zombie Awareness does not react to TaCZ gunshots (see `refs/notes.md`). It hooks `ServerLevel` and `PathNavigation` like Harium and Immersive Optimization; no hard conflict. (`by design`)
- Distant Horizons and new world generation: Deeper and Darker (a dimension), End Remastered (structures), Botania (flowers) and Waystones (village waystones) add generation. The Distant Horizons FAQ says world generators are mostly supported and advises the `surface` generator mode if a structure breaks under multithreaded generation. Waystones hooks `JigsawPlacement$Placer.tryPlacingChildren` like Structure Layout Optimizer, on a different call (`ModifyArg` on `Registry.getHolder`); keep `deduplicateShuffledTemplatePoolElementList` off (see the Structure Layout Optimizer section). (`unverified`)
- True Ending is a data pack wrapped as a mod (`modLoader = 'lowcodefml'`, no code). Whether FML 47.4.28 loads it and applies its functions at world load was not run; its settings menu is `/function true_ending:_settings`. (`unverified`)

## Superb Warfare, Vanilla Backport, Almost Unified, TACZ-Sound Attracts Zombies (added 2026-11-24, second batch)

- None was run in the game. Mixin scan against the 111 installed jars and the batch itself: no hard conflict (same `@Redirect` or `@ModifyConstant` call, or `@Overwrite`). Superb Warfare has 516 plain same-method injects with installed mods, mostly camera and held-item hooks it shares with TaCZ, Punchy!, Punchy! Moves and Shoulder Surfing Reloaded (`Camera.setup`, `GameRenderer.bobView` and `getFov`, `MouseHandler.turnPlayer`, `ItemInHandRenderer`, `HumanoidModel.setupAnim`). (`unverified`)
- Superb Warfare and TaCZ, two gun systems: two sets of aiming, recoil and HUD. Superb Warfare issue 181 (open, 2026-11-20, the reporter calls it untested): with a TaCZ gun in the offhand the main-hand animations stop after updating Superb Warfare. Issue 168 (open): an offhand gun is not drawn in third person. (`unverified`)
- Superb Warfare and Punchy!: Punchy! draws held items itself, so Superb Warfare guns can render twice or fight the animation like TaCZ items (see the Punchy! section). No report was found. (`unverified`)
- Superb Warfare issue 77 (closed 2026-08-18, reported on 1.21.1): with Iris, shaders and Distant Horizons, a vehicle or drone that tilts the camera leaves the LOD untilted (ghost objects). The author says it is fixed in 0.8.9.1; the pack has 0.8.9.2. The pack has Oculus 1.8.0, shader packs and Distant Horizons 3.3.3. (`unverified`)
- Superb Warfare issue 180 (open, 2026-11-09): "severe lag on the mod overlay trace function", a profile screenshot, no version; the reporter also has Create: Aeronautics. (`unverified`)
- Superb Warfare bundles Ponder 1.0.91 and Flywheel 1.0.5, the same versions as Create 6.0.8, and GeckoLib 4.4.6 and Cloth Config 11.1.106 (the pack has 4.8.5 and 11.1.136). Whether Forge loads one copy of each and Colorwheel still patches Flywheel is not tested. Superb Warfare 0.8.8 ran in a 1.20.1 pack with Create 6.0.8, Create Crafts & Additions 1.3.3, Embeddium 0.3.31, Oculus 1.8.0, GeckoLib 4.8.2 and Kotlin for Forge 4.11.0 (issue 103, a Valkyrien Skies bug). (`unverified`)
- Superb Warfare explosions destroy blocks by default and the pack keeps that. In a world with Create contraptions, Mekanism machines and AE2 networks, a stray explosion can destroy them. The switch is per world (`serverconfig`), so an existing or new world can turn it off with `/sbw config explosionDestroy false`. (`by design`)
- Superb Warfare, Mekanism and Almost Unified: Superb Warfare adds lead, silver, tungsten and steel. Almost Unified's `modPriorities` lists Mekanism and not Superb Warfare, so Mekanism's items should win for lead and steel. How Almost Unified treats Superb Warfare's own recipe types (blueprints, vehicle assembling) was not read; if a Superb Warfare recipe stops working, check `config/almostunified/` first. Almost Unified 1.20.1 builds are tagged beta, and no issue about Superb Warfare, TaCZ or FastSuite was found in its tracker. (`unverified`)
- Almost Unify Everything was built in 2024-10 against an older Almost Unified. All 2 member references into Almost Unified 0.11.0 resolve (checked class by class), but a later Almost Unified release can break it. (`unverified`)
- Vanilla Backport: 272 blocks, 94 items, 12 mobs and 3 biomes (Dappled Forest, Pale Garden, Sulfur Caves) with about 40 switches. Open reports: issue 89 (a portal trip froze the screen and turning shaders on crashed, with Oculus, one report), issue 570 (open, spears from other mods lose speed when charging while sprinting; the thread names Twilight Forest), issue 399 (open, Aether Quicksoil). Distant Horizons generation of the new biomes is not tested. (`unverified`)
- Fallen trees come from Vanilla Backport only (Bedrockoid's `fallenTrees` is `false`). That Bedrockoid 0.1.2's biome modifier really stops on this flag was read from the jar (`FallenTreeBiomeModifier` reads `BedrockoidConfig.fallenTrees`), not run. (`unverified`)
- TACZ-Sound Attracts Zombies: it hooks TaCZ's `GunFireEvent` and `GunReloadEvent`. After a TaCZ update (1.2.0 is out, the pack has 1.1.8-hotfix2) its references may break. It declares no dependency in `mods.toml`. (`unverified`)

## Resolved

- GPUBooster was a Fabric-only jar. It was replaced with the Forge build `1.0.5.1-forge`. (`resolved`)

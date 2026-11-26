# Settings

Settings the pack ships. Nothing here was tested in-game. Where a file lives is set by the Rules in `CLAUDE.md`: `config/defaultoptions/` and `config/defaultoptions/extra/config/` apply only when the target file does not exist, `config/` is enforced.

Only keys that differ from the default are written. Everything else stays at the default. Overlapping features were checked and are complementary (see `refs/notes.md`).

Files under `config/defaultoptions/extra/` are copied when `Options.load` starts (Default Options runs them at its `PRE_LOAD` stage, read from the jar), which is before mods read their configs.

## Vanilla

File: `config/defaultoptions/options.txt`

| Key | Value | Reason |
| --- | --- | --- |
| `renderDistance`, `simulationDistance` | `8`, `8` | Short vanilla range. Distant Horizons covers the far range. |
| `entityDistanceScaling` | `2.0` | Entity render distance of about 8 chunks (128 blocks) for an average-size mob. It is a multiplier of 64 blocks times the entity's size, not a chunk count. |
| `particles` | `2` | Minimal particles. |
| `mipmapLevels` | `0` | Mipmaps off. |
| `graphicsMode` | `0` | Graphics "Fast" (processing first). Vanilla values: 0 Fast, 1 Fancy, 2 Fabulous. |
| `renderClouds` | `"false"` | Clouds off. |
| `entityShadows` | `false` | Entity shadows off. |
| `guiScale` | `3` | GUI scale 3x. |
| `fov` | `0.75` | Field of view 100. `options.txt` stores `(degrees - 70) / 40`, not degrees. |
| `lang` | `ja_jp` | Japanese. |
| `mouseSensitivity` | `0.165` | Sensitivity 33%. `options.txt` stores half of the percent shown in the game (default `0.5` is 100%). |
| `onboardAccessibility` | `false` | Skips the accessibility and narrator screen at first launch. |
| `soundCategory_music` | `0.0` | Music volume (the Music slider, the vanilla BGM) at 0%. Chosen by the user (2026-11-27). The other sound categories stay at the default `1.0`. |
| `resourcePacks` | `["vanilla","tacz_resources","mod_resources","mod/punchy:punchy","file/Fluid & Foolish 1.0.1.zip","file/FreshAnimations_v1.11.2_1.20+.zip","file/Iron Girl v2.0.zip","file/Piglin-Chan.zip","file/Melodys Cute Traders 1.0.0_pre-26.1.zip","file/Melodys Cute Illagers 1.0.1.zip","file/Melodys Cute Villagers v1.11.1_pre-26.1.zip","file/Melodys Cute Witches 1.0.1.zip","file/AzukiV57.zip"]` | Enables the packs. The first entry has the lowest priority, the last the highest: Fresh Animations at the bottom, then Iron Girl, Piglin-Chan and the Melody's packs, with Melody's Witches above them (Iron Girl ships its own `witch.jem`). Japanese Language Pack (`AzukiV57.zip`) is the last entry, so it is on top: its author asks for the top slot, it holds only `ja_jp.json` files (no textures, so it does not touch the entity packs), and a pack above jtrans wins for the same key. The list is copied from a real instance, so it also names the packs mods add. The `file/` id is the file name in `resourcepacks/`. The game saves `&` as a JSON unicode escape, but a plain `&` parses the same. |
| `incompatibleResourcePacks` | `["file/Iron Girl v2.0.zip","file/Melodys Cute Traders 1.0.0_pre-26.1.zip","file/Melodys Cute Illagers 1.0.1.zip","file/Melodys Cute Villagers v1.11.1_pre-26.1.zip","file/Melodys Cute Witches 1.0.1.zip"]` | Minecraft 1.20.1 reads only `pack_format` (the jar has no `supported_formats`), and compares it with 15. Iron Girl declares 32 and the four Melody's packs declare 10, so the game would remove them from `resourcePacks` at load ("no longer compatible"). Listing them here keeps them enabled. |

- `options.txt` carries `version:3465` (the 1.20.1 data version) so the DataFixer does not run on a partial file.
- The GUI scale in the game is capped by the window size: 3x needs a window of at least 960x720 pixels. Prism's default window (854x480) shows 2x even with `guiScale:3`. The window size is a launcher setting and cannot ship in the `.mrpack`. Cubes Without Borders starts the game in borderless fullscreen (see Mods), so at first launch the window is as large as the monitor and 3x applies until the player leaves fullscreen.

## Key Bindings

File: `config/defaultoptions/keybindings.txt`. Chosen by the user (2026-11-27). One line per mapping: `key_<mapping name>:<key>:<modifier>`. `key.keyboard.unknown` means "not bound".

How Default Options applies it (read from the source of its 1.20.1 branch, `KeyMappingDefaultsHandler`; the pack has 18.0.5): the file sets the default key of each listed mapping. The current key follows only when the mapping is still on its original default and the player has not set it before (it is not in `options.txt` yet). So it applies to a new instance and to mappings that are new to an existing one, and never overrides a key the player chose.

| Rule | Mappings (key) | Reason |
| --- | --- | --- |
| Function keys are unbound, except F5 | `key.screenshot` (F2), `key.dragon_change_view` (F7, Ice and Fire CE), `key.punchy_moves.camera_editor` (F7), `key.punchy.open_main_menu` (F8), `key.fullscreen` (F11) | The user wants no function key bound for now. F5 (`key.togglePerspective`) stays. F1, F3 and F4 are fixed in vanilla and are not mappings. |
| Number keys and Shift+number are unbound | `key.hotbar.1` to `key.hotbar.9`, `key.doggytalents.whistle.1` to `4` (Shift+1 to 4) | The same wish. `0` and Shift+5 to 9 had nothing bound. The keypad is not touched (Jade 0 to 5, Placebo 8 and 9, Xaero `+`). |
| R is left to the two reload keys | unbound: `key.parcool.dodge`, `key.parcool.breakfall`, `key.parcool.horizontal_wall_run`, `key.irons_spellbooks.spell_wheel` | R is TACZ's (`key.tacz.reload.desc`) and Superb Warfare's (`key.superbwarfare.reload`) reload. The three ParCool actions work on foot, so they fire together with a reload. Iron's Spells opens its spell wheel whenever no screen is open: the held-spellbook check is commented out in its source (branch `1.20.1-dragon`). |
| Z, X, C, V, G, B, Tab and left Alt keep only keys limited to an item, a ride or a screen | unbound: Z `keybind.name.CHAT_PEEK` (Essential), `gui.xaero_enlarge_map`; X `key.loadToolbarActivator`, `key.touhou_little_maid.stt_chat.desc`; C `keybind.name.ZOOM` (Essential), `chloride.zoom`, `key.botania_corporea_request`, `key.simpleenemymod.commander_menu`, `key.parcool.crawl`, `key.parcool.hide_in_block`, `key.punchy_moves.emote_menu`; V `key.irons_spellbooks.spellbook_cast`, `key.punchy_moves.camera_toggle_v`; G `keybind.name.MENU_ACCESS` (Essential), `key.curios.open.desc`; B `keybind.name.COSMETIC_STUDIO` (Essential), `gui.xaero_new_waypoint`, `key.punchy_moves.free_camera`; Tab `key.playerlist`; left Alt `key.shouldersurfing.free_look`, `key.irons_spellbooks.spell_bar_modifier`, `create.keyinfo.toolbelt` | The user's rule (2026-11-27): unbind every mapping on these keys except those that work only while holding or wearing an item, riding, or with a screen open. A mapping that is always available, or limited only by a block or an area (Botania's Corporea Index, Create's nearby toolboxes), was unbound. The labels come from the mods' English language files. |

- Kept on Z, X, C, V, G, B and left Alt (item, armor, ride or screen only; the limit is read from the label, not from code): Z TACZ refit; X Superb Warfare interact and vehicle lock target, Cataclysm ability, Ice and Fire dragon down, L2 Item Selector wheel; C Superb Warfare vehicle free-cam, Touhou Little Maid broom dismount, Cataclysm helmet ability, TACZ crawl; V Mekanism head mode, Aether invisibility toggle, Superb Warfare flares and melee, Cataclysm boots ability, Deeper and Darker sculk transmitter, TACZ zoom and melee; G Mekanism chest mode, Ice and Fire dragon strike, Simply Tooltips tab cycle, TACZ SEWV tactical data terminal, TACZ fire select, GuideME guide, Punchy sword inspect; B Mekanism feet mode, Immersive Aircraft rocket boost, Deeper and Darker soul elytra boost; left Alt Superb Warfare dismount, Railways bogey and cycle menus, L2 Item Selector, Create schematic overlay focus. Doubtful: Superb Warfare `interact` (X), Aether `invisibility_toggle` (V), TACZ SEWV `open_tdt` (G) and Railways' two menus: whether each really needs an item or a ride was not read. (`unverified`)
- The zoom keys of Essential and Chloride are both unbound, so the game has no zoom key; the Curios key, the player list (Tab), the ParCool crawl and hide-in-block keys and the Punchy Moves emote wheel are unbound too.
- Kept on R because they cannot coincide with a reload, as the user asked: `key.jei.showRecipe` (JEI, only while a screen is open), `key.immersive_aircraft.dismount`, `key.smallships.ship_sail` and `key.dragon_fireAttack` (only while riding), `key.l2mods.swap` (L2 Item Selector, items tagged `l2itemselector:selectable`). Whether a gun can be used while riding was not read, so the three riding keys rest on the user's premise. (`unverified`)
- With `key.fullscreen` unbound, F11 does nothing: Chloride's mode cycling is injected at the `Window.toggleFullScreen()` call of `KeyboardHandler.keyPress`, which only runs when the vanilla mapping matches (Chloride's mixin target read from the jar; the vanilla branch is from memory). The game starts borderless (Cubes Without Borders), so the player leaves it through Video Settings. There is no screenshot key either.
- Not run in the game, and not tested with Key Binding Patch (see `refs/issues.md`).

## Mods

### Embeddium

File: `config/defaultoptions/extra/config/embeddium-options.json`

| Key | Value | Reason |
| --- | --- | --- |
| `quality.weather_quality` | `FAST` | Embeddium's own weather setting, the lowest. |
| `quality.leaves_quality` | `FAST` | Opaque leaves (processing first). In this mode Embeddium also hides the faces between neighboring leaves. Values: `DEFAULT`, `FANCY`, `FAST`. |

### Distant Horizons

File: `config/defaultoptions/extra/config/DistantHorizons.toml`

| Key | Value | Reason |
| --- | --- | --- |
| `client.advanced.graphics.quality.lodChunkRenderDistanceRadius` | `64` | LOD range in chunks. |
| `client.advanced.graphics.quality.horizontalQuality`, `verticalQuality` | `LOW` | Same as the Low preset. |
| `client.advanced.graphics.quality.transparency` | `DISABLED` | Same as the Low preset. |
| `client.advanced.graphics.quality.vanillaFadeMode` | `SINGLE_PASS` | Same as the Low preset. |
| `client.advanced.graphics.quality.lodBiomeBlending` | `1` | Same as the Low preset. |
| `client.advanced.graphics.enableSsao` | `false` | Same as the Low preset. |
| `client.advanced.graphics.genericRendering.enableCloudRendering` | `false` | DH draws its own LOD clouds (default `true`, 3 layers through `enableMultiLayerClouds`, overworld only) and ignores the vanilla `renderClouds:"false"`. With it on, clouds show even with shaders off. Found 2026-11-24 on the ohm instance. An instance that already has `config/DistantHorizons.toml` keeps its value, because extras never overwrite. |

- The values equal its Low preset. The other preset-controlled keys stay at defaults, so its UI shows Low.
- Generation is bounded by its render distance (`generationMaxChunkRadius` is `0`, which means "use the render distance"). Never set `generationMaxChunkRadius`: it is centered on chunk 0,0, not on the player.
- DH's default `generation.plan` is `SURFACE_THEN_CHUNKS` (read from the 3.3.3 jar). Turbo for Distant Horizons overrides it to `SURFACE_ONLY` through the DH API at run time, so the DH config file and its UI keep the default (see the next section).

### Turbo for Distant Horizons

Nothing is shipped. Its config is a Forge COMMON config (`config/dhturbo-common.toml`, created by the mod at first launch; the type is read from the jar). Every default fits the pack, so no file is written:

| Key | Default | Why it stays |
| --- | --- | --- |
| `enabled` | `true` | The mod is the purpose. With it off, DH's own generator runs. |
| `threads` | `0` | Two thirds of the CPU cores. Hardware-dependent, so never shipped. |
| `exact_radius` | `16` | Singleplayer: the chunks around the player are redrawn by the game's real generator while the generator is idle (caves, ores, lakes). Chunks inside the render distance are real anyway. |
| `exact_radius_server` | `0` | A dedicated server pays for the exact pass with tick time, so it is opt-in. |
| `real_chunks_nearby` | `false` | Off: Turbo sets the DH plan to `SURFACE_ONLY`, so DH never re-requests tiles as real chunks. On: DH keeps `SURFACE_THEN_CHUNKS`, which costs more CPU. |
| `excluded_dimensions` | `[]` | Turbo compares a few dozen columns per level with the level's own generator and leaves an unreadable level to DH by itself (chat line for operators and the host, log line). |
| `share_worldgen` | `true` | Only a server without DH sends the seed to clients that have Turbo. The pack's server has DH, so it sends distant terrain and no seed. |
| `structures`, `fake_trees`, `real_trees`, `ground_cover`, `vanilla_surface`, `soft_plant_colors` | `true` | The look of the distance. |
| `full_resolution` | `false` | Costs about twice the time for a few more exact heights. |

- `/dhturbo regenerate` (operators and the host) deletes a world's distant terrain so it is drawn again. Terrain that DH or an older Turbo already stored keeps its look until then.

### Chloride

File: `config/defaultoptions/extra/config/chloride-client.toml`

| Key | Value | Reason |
| --- | --- | --- |
| `fullscreen.mode` | `BORDERLESS` | Kept equal to Cubes Without Borders' mode (see below). The default is `WINDOWED`. Values: `WINDOWED`, `BORDERLESS`, `FULLSCREEN`. |
| `culling.entityDistanceX` | `16384` | Squared horizontal distance in blocks (128 blocks). The default `4096` (64 blocks) would cap the vanilla `entityDistanceScaling` above. |
| `fastBlocks.chests` | `true` | Fast Chests: chests become solid block models without animation. Off by default. |
| `fastBlocks.beds` | `true` | Fast Beds: beds become solid block models. Off by default. May break modded beds (Chloride's own warning). |

- `world.leavesCulling` is left at its default `OFF`. Chloride's culling only changes anything with Fancy leaves: with Fast leaves Embeddium's `skipRendering` already culls faces next to leaves, and Chloride's `should()` returns true there whatever the mode. With Fancy leaves, `ALL` thins the canopy. It was `ALL` until 2026-11-23.
- Optimized Block Entities (installed) also optimizes chests and beds and keeps their animation. Enabling Fast Chests and Fast Beds beside it was requested by the user; the combination was not run.
- Chloride's fullscreen code cannot be switched off. Its mixin plugin only gates the JEI, REI and EMI mixins. Cubes Without Borders (installed) hooks the same two `Window.setMode` calls, `glfwSetWindowMonitor` and `glfwGetWindowMonitor` (Chloride as `@Redirect`, Cubes Without Borders as `@WrapOperation`). Mixin order cannot be set from a config, so the pack keeps both in the same state instead (read from both jars, not run).
- Chloride acts at three points. (1) At `FMLClientSetupEvent` it compares the vanilla `fullscreen` option with `mode != WINDOWED`; if they differ it calls its own `setFullScreenMode(mode)`, which toggles the window. (2) In `Window.setMode` it redirects `glfwSetWindowMonitor`. With `mode = BORDERLESS` and a call that has a monitor, it runs its own undecorated-window code. In every other case (another mode, or a call with monitor 0, which is how a windowed-style fullscreen looks) it makes the call and then sets `GLFW_DECORATED` to true. Whether that happens before or after Cubes Without Borders applies its borderless type was not determined, so the title bar may come back. (3) F11: it always cancels the vanilla toggle and cycles its own modes. So the pack sets `mode = BORDERLESS` here and `useDelayedFullscreen = false` in Cubes Without Borders: the window is fullscreen from creation, the vanilla `fullscreen` option is already `true` when point (1) runs, and point (1) does nothing. Point (2) is the open risk (see `refs/issues.md`).
- Chloride's mode selector (Sodium options, Interface page) shows `fullscreen.mode`, the config value, not the state of the window.
- `fullscreen.attachModeF11` stays at its default `ATTACH`: F11 cycles windowed, borderless and fullscreen (Chloride's modes), but only while `key.fullscreen` is bound, and `keybindings.txt` unbinds it (see Key Bindings). `fullscreen.disableBorderlessOptimizations` stays `false`; Chloride says turning it on fixes a black blink when leaving the game on multi-monitor setups, at the cost of frame rate.
- `fullscreen` is not set in `options.txt`: Cubes Without Borders writes it from its own state when the window is created.

### Cubes Without Borders

File: `config/defaultoptions/extra/config/cwb.json`

| Key | Value | Reason |
| --- | --- | --- |
| `fullscreenMode` | `BORDERLESS` | The game starts in borderless fullscreen. The default is `OFF`. Values: `OFF`, `EXCLUSIVE`, `BORDERLESS`, `WINDOWED`. |
| `useDelayedFullscreen` | `false` | The default is `true`: the window starts windowed and Cubes Without Borders enters fullscreen after loading. Then the vanilla `fullscreen` option is `false` when Chloride's startup check runs, and Chloride (mode `BORDERLESS`) enters fullscreen during loading instead. With `false` Cubes Without Borders enters fullscreen when the window is created. Its tooltip says the delay can help on systems with faulty drivers that cannot enter fullscreen at once. |

- `preferredFullscreenMode` stays at its default `BORDERLESS`. `borderlessFullscreenType` and the other keys stay at their platform defaults.
- At window creation it sets the vanilla `fullscreen` option from its own state, so `fullscreen` in `options.txt` is not used.
- It replaces the Fullscreen button of the vanilla Video Settings screen with a mode selector. Embeddium has its own video options screen with a plain Fullscreen toggle; whether the selector shows anywhere else was not checked. Its config screen needs Cloth Config or YACL, and Cloth Config is installed.
- To start in exclusive fullscreen instead, set `fullscreenMode` to `EXCLUSIVE` and Chloride's `fullscreen.mode` to `FULLSCREEN`. Not run.

### Xaero's Minimap

Files: `config/defaultoptions/extra/config/xaero/minimap/profiles/default.cfg` (the profile `default`, which `xaero/minimap/client.cfg` selects) and `config/defaultoptions/extra/config/xaerohud.txt` (position). Taken from the author's instance on 2026-11-26. Defaults were read from the 26.6.0 jar (`MinimapProfiledConfigOptions`) and the xaerolib 1.7.3 jar inside it.

| File | Key | Value | Reason |
| --- | --- | --- | --- |
| `default.cfg` | `minimap_size` | `120` | Minimap size. The default is `0` (Auto). |
| `default.cfg` | `minimap_opacity` | `90` | Minimap opacity in percent. The default is `100`. |
| `default.cfg` | `profile_name` | `Default` | The default is `Untitled`, so a profile file without this line would be renamed. |
| `xaerohud.txt` | the `xaerominimap:minimap` module line | `x=-1;y=12`, `fromRight=false`, `fromBottom=false` | Position, anchored to the top left, in the HUD's own units. The file is that one line, as the game saved it. The default position was not read. |

- Every other key stays at its default. The game writes the whole profile when it saves, so a file with only these three keys relies on Xaero filling the rest with the defaults (inferred, not run).
- `minimap_ui_scale` was `2` in the author's instance (default `1`) and is not shipped: the user listed only the size, the opacity and the position (2026-11-27).
- The world map (`xaero/world-map/profiles/default.cfg`), the radar and the waypoint keys were not touched.

### Dynamic FPS

File: `config/defaultoptions/extra/config/dynamic_fps.json`. Taken from the author's instance on 2026-11-26. Dynamic FPS saves only the values that differ from its built-in defaults and fills the missing keys from the jar's `default_config.json` (read from the 3.11.4 source: `Serialization.removeUnchangedFields`, `addMissingFields`), so the file is the difference as the game saved it.

| Key | Value | Default | Reason |
| --- | --- | --- | --- |
| `idle.timeout` | `180` | `300` | Seconds without movement, look change or mouse movement before the `abandoned` state. |
| `idle.condition` | `none` | `vanilla` | `IdleHandler` adds a check only for `on_battery`, so `none` and `vanilla` behave alike there. Other uses were not read. |
| `states.unfocused.graphics_state` | `reduced` | `default` | Reduced graphics while the window has no focus. |
| `states.invisible.frame_rate_target`, `graphics_state` | `1`, `reduced` | `0`, `default` | Window minimized or hidden: 1 FPS and reduced graphics. |
| `states.abandoned.frame_rate_target`, `graphics_state` | `30`, `reduced` | `10`, `default` | Idle player: 30 FPS and reduced graphics. |

- Left at the defaults: `hovered` 60 FPS, `unfocused` 1 FPS with the master volume at 25%, `invisible` volume 0. The focused window is not capped by any state.
- The user confirmed on 2026-11-27 that every changed value is shipped (all of the table above).

### RenderScale

File: `config/defaultoptions/extra/config/renderscale.json5`. RenderScale 2.0.0-beta.1 registers a Cloth Config AutoConfig named `renderscale` with the Jankson serializer (read from the jar: `RenderScaleConfig`, `me/shedaniel/autoconfig/serializer/JanksonConfigSerializer`), so the game reads `config/renderscale.json5`. The defaults are the field initializers in the jar's `RenderScaleConfig` constructor. Chosen by the user (2026-11-27).

| Key | Value | Default | Reason |
| --- | --- | --- | --- |
| `scale` | `0.8` | `1.0` | Render scale of 80%, relative to the window resolution. |
| `irisScale` | `0.75` | `-1.0` | Render scale while a shader pack is on, 75%. `-1` keeps the value of `scale`. |
| `fsr` | `true` | `false` | FSR 1 upscaling (the option's screen name is "FSR 1 upscaling"; the user's "SR"). Its tooltip says it works at 100% scale and below, so 80% and 75% qualify. |

- Left at the defaults: `targetFrameRate` `0` (dynamic scaling off), `aggressionLevel` `NORMAL`, `minimumScale` `0.1`, `forceBilinear` `false`, `downscaleFilter` `AUTO`, `sharpeningMode` `OFF`, `sharpeningStrength` `35`.
- A file with only these three keys relies on Jankson leaving the other fields at their defaults (inferred, not run). The file name and the three values were not tested in the game (see `refs/issues.md`).

### Oculus

File: `config/defaultoptions/extra/config/oculus.properties`

| Key | Value | Reason |
| --- | --- | --- |
| `maxShadowRenderDistance` | `16` | Maximum shadow render distance in chunks. The default is 32. It matters only while a shader pack is on. |

- `shaderPack` and `enableShaders` are not set: no shader pack is selected at first launch (2026-11-23). Players choose one in Options, Video Settings, Shader Packs.
- Mellow's `DYNAMIC_SHADOWS` (shadow map shadows) is left off, its default. Turning it on is a per-pack option file (`shaderpacks/Mellow v3.5.zip.txt`, name follows the zip), not shipped; its tooltip rates the cost as EXTREME.
- Complementary Reimagined's default `shadowDistance` of its HIGH profile is 192 blocks (12 chunks), inside the 16-chunk limit above. The pack's default profile and `SHADER_STYLE` (Visual Style) are left at their defaults.

### Create, Colorwheel

Added 2026-11-23. Nothing is shipped. Create's and Colorwheel's configs are at their defaults (not read).

### Kerria

- Left untuned on purpose: `fastLightTextureUpload` is off by default. It applies the persistently mapped buffer upload to the light texture, which is a 16x16 image. The gain is tiny, it needs OpenGL 4.5 or ARB_buffer_storage, and the author leaves it off. `fastUpload` and `cache` are on by default.

### ModernFix

File: `config/modernfix-mixins.properties` (enforced, so it lives directly under `config/`)

| Key | Value | Reason |
| --- | --- | --- |
| `mixin.perf.remove_spawn_chunks` | `true` | Removes spawn chunks, the same goal as Ksyxis. Off by default in ModernFix. Stops spawn-chunk farms. |

- Left untuned on purpose: `mixin.perf.dynamic_resources` saves memory, not FPS, with compatibility risk.

### AsyncParticles

- Left untuned on purpose: `FASTEST` mode has a crash risk with incompatible mods.

### Immersive Optimization

- Left untuned on purpose: `enableBlockEntities` may glitch other mods.

### Quick Pack

Nothing is shipped. The defaults of `quick-pack.json` are `removeLoadingOverlayFadeOut = true` and `parallelMipmapGeneration = true` (the latter does nothing with `mipmapLevels:0`).

### Entity Model Features, Entity Texture Features, EntityModelShaderFix

Added 2026-11-23. Nothing is shipped. The defaults were read from the jars and already switch the main features on:

- ETF: `enableCustomTextures`, `enableEmissiveTextures` and `enableBlinking` are `true`.
- EMF: `allowedCEM` is `ALL` (custom models on). `animationLODDistance` is 20 blocks, `animationFrameSkipDuringIrisShadowPass` is `true`.
- EntityModelShaderFix has no config.

### Enhanced Boss Bars, Async Locator, Fast Items, Leaves Be Gone

Added 2026-11-23. Nothing is shipped for them. The defaults were read from the jars and already switch the main feature on:

- Enhanced Boss Bars: `enhanced_boss_bars_enabled` is `true`. `override_all_boss_bars` is `false`; its effect is not confirmed (see `refs/issues.md`).
- Async Locator: `locateCommandEnabled`, `eyeOfEnderEnabled`, `explorationMspEnabled`, `villagerTradeEnabled` and `dolphinTreasureEnabled` are `true`. `asyncLocatorThreads` is 1, as the author recommends.
- Fast Items: `enable` is `true`, `affect3DModels` is `true`, `renderSidesOfItems` is `false`, `castShadows` is `true` (vanilla `entityShadows:false` already hides shadows).
- Leaves Be Gone: `minimumDecayTicks` is 5 and `maximumDecayTicks` is 20.

### Cerulean, FISM

Added 2026-11-26. Nothing is shipped for them (RenderScale has its own section above):

- Cerulean: the jar's `cerulean.yml` has `enable_skip_ticks`, `ignore_triggers_for_emptied_stacks` and `ignore_triggers_for_decreased_stacks` at `true` and `debug_mode` at `false`. The defaults already switch the optimization on.
- FISM: the jar holds no config.

### Debug Keybind

Added 2026-11-27. Nothing is shipped: every default is the vanilla key, so it behaves like vanilla until a player rebinds. Its keys are not `KeyMapping`s, so `config/defaultoptions/keybindings.txt` and `options.txt` cannot carry them. A player sets them in Controls > Debug Keybinds (`refs/notes.md`, `refs/issues.md`).

### Bedrockoid

File: `config/bedrockoid-config.toml` (enforced: it changes world generation). Added 2026-11-24. Bedrockoid writes the other keys with their defaults at first start (it reads the file with NightConfig and fills what is missing; read from the jar, not run).

| Key | Value | Reason |
| --- | --- | --- |
| `flags.bedrockoid.fallenTrees` | `false` | Vanilla Backport also generates fallen trees (`fallen_trees` in its own config, left on). Bedrockoid's `FallenTreeBiomeModifier` reads this flag, so the biome modifier does nothing and only Vanilla Backport's fallen trees appear. Chosen by the user (2026-11-24). |

### Almost Unified, Almost Unify Everything, Vanilla Backport, TACZ-Sound Attracts Zombies, Superb Warfare

Added 2026-11-24. Nothing is shipped for them.

- Almost Unified: the defaults unify 47 materials (including lead, steel, silver, tungsten, iron, coal, copper, zinc) on the tag patterns `nuggets`, `dusts`, `gears`, `gems`, `ingots`, `raw_materials`, `ores`, `plates`, `rods`, `wires`, `storage_blocks` and `storage_blocks/raw_` (read from the 1.20.1 branch source, `Defaults.java`; the jar was not decompiled). `modPriorities` is `minecraft, kubejs, crafttweaker, create, thermal, immersiveengineering, mekanism`. Mekanism is in that list and Superb Warfare is not; how it ranks mods that are missing from the list was not read. Almost Unify Everything uses the same config.
- Vanilla Backport: every feature has a switch (`fallen_trees` and about 40 others, read from the jar); all stay on.
- Superb Warfare: block destruction by explosions is on by default (user's choice: on). The setting is in the world's `serverconfig/superbwarfare-server.toml` (`explosion_destroy`), not in `config/`, so nothing is shipped.
- TACZ-Sound Attracts Zombies: it listens to TaCZ's `GunFireEvent` and `GunReloadEvent` and calls Zombie Awareness's `ZAUtil.hookSoundEvent`, with a silencer check (`SilencerDetector`). It has an on/off command (`SoundAttractionCommand`, state in `SoundAttractionConfig`); its name was not read. Its page says it needs no configuration.

### Create: Steam 'n' Rails, Immersive Aircraft, Man of Many Planes, Small Ships, Immersive Vehicles

Added 2026-11-24. Only one key is shipped (`defaultconfigs/smallships-server.toml`, below); none of them has its main feature switched off by default. Defaults below were read from the mods' 1.20.1 branch sources (Immersive Aircraft `Config.java`, Small Ships `SmallShipsConfig.java`); the jars hold the same key names (read), the default values were not read from the jars. None was run.

- Immersive Aircraft (`config/immersive_aircraft.json`): `enableCrashExplosion` `true` with `crashExplosionRadius` 2.0, `enableCrashBlockDestruction` `false`, `enableCrashFire` `false`, `weaponsAreDestructive` `false`, `collisionDamage` `true`, `separateCamera` `true`, `useThirdPersonByDefault` `true`, `fuelConsumption` 1.0. So a crash explodes but does not break blocks and weapons do not break blocks.
- Small Ships: server settings are per world (`serverconfig/smallships-server.toml`, type SERVER) and client settings are in `config/smallships-client.toml`. Server defaults are shipped through `defaultconfigs/smallships-server.toml`: Forge copies it into a new world, so an existing world keeps its own file (edit `saves/<world>/serverconfig/smallships-server.toml` by hand there). The server's value is synced to clients. Defaults: `shipGeneralCannonDamage` 25.0 and `shipGeneralCannonDestruction` 1.0 ("destruction a cannonball does when it hits the ground"), `windEnable` `true`, `sailDamageEnable` `true`, `shipGeneralCameraFreeLook` `true`, `shipUpgradeEnable` `true`, `updateCheckerEnable` `true` (server and client). `vanillaBoatSlowdownEnable` is `true` by default with `vanillaBoatSpeedFactor` 0.25: vanilla boats would be 75 % slower so that Small Ships' ships are more attractive. The user switched it off (2026-11-24), see the table below.

  | File | Key | Value | Reason |
  | --- | --- | --- | --- |
  | `defaultconfigs/smallships-server.toml` | `Ship.VanillaBoats.vanillaBoatSlowdownEnable` | `false` | Keeps vanilla boats at vanilla speed. Chosen by the user (2026-11-24). `vanillaBoatSpeedFactor` stays at 0.25 and has no effect while this is `false`. The file holds only this key: Forge fills the other keys with their defaults at the first load of the world (the table path was read from the mod's 1.20.1 branch source `SmallShipsConfig.java`; the file name follows from Forge's `<modid>-server.toml` rule and the jar registers the spec without a name; not run). |
- Immersive Vehicles: defaults. Its config files are `mtsconfig.json` and `mtsconfigclient.json` (names read from the jar; the folder was not read). Content packs added on 2026-11-24 by the user's choice: Official Content Pack (OCP) V29 and GT CRAFT 2.1.2. Nothing is shipped for the packs: they hold assets and JSON and have no config of their own. Keys of the `damage` section of `mtsconfig.json` that decide what OCP's bombs, rockets and RPGs do (named on the community pack list): `bulletBlockBreaking`, `bulletExplosions`, `vehicleBlockBreaking`, `vehicleExplosions`, `allowExternalDamage` (key names and descriptions read from the jar; the default values were not read; 24.0.0 notes say `allowExternalDamage` became `true` by default).
- Create: Steam 'n' Rails, Man of Many Planes: defaults (Man of Many Planes has no config).

### Zombie Awareness

Files: `config/zombieawareness/Features.toml`, `General.toml` and `MobLists.toml` (enforced: they change mob behavior). Added 2026-11-24, chosen by the user. All are Forge COMMON configs registered by the mod (`ModLoadingContext.registerConfig`, read from the jar), so Forge fills the keys that are not shipped with their defaults when it loads them (not run).

| File | Key | Value | Reason |
| --- | --- | --- | --- |
| `Features.toml` | `general.wanderingHordes` | `true` | Enhanced mobs gather into hordes and walk to random points near players (every `frequencyOfWanderingHordesPerPlayer` = 30 s by default). Off by default. The only gameplay feature of the mod that was off. |
| `General.toml` | `general.awareness_Light_OnlyZombies` | `false` | Lets the other enhanced mobs (creepers, skeletons, strays, witches, spiders, illagers) follow light near players too. The default `true` limits it to zombies. |
| `MobLists.toml` | `general.enhancedMobs` | the 7 defaults (`zombie`, `husk`, `creeper`, `skeleton`, `stray`, `witch`, `zombie_villager`) plus `spider`, `cave_spider`, `pillager`, `vindicator`, `evoker` (all `minecraft:`) | Spiders and illagers also hunt by sound, scent and light. Chosen by the user (2026-11-24). A list key replaces the default list, so the defaults are written out too. |

- Already on by default and left alone: sound, scent and light senses, noisy zombies and pistons, sounds from machines (`blockBreakEvent_PlayersOnly = false`), and every dimension (`awareness_Sound_OverworldOnly = false`). `daysBeforeFeaturesActivate` is 0, so all of it runs from the first day.
- Left off on purpose: `omniscient` (always target the closest player) and `seeThroughWalls` (no line-of-sight check), both marked performance sensitive by the mod.
- Not in `enhancedMobs`: flying and water mobs, bosses, neutral mobs, `ravager` and `illusioner`, modded mobs (Twilight Forest spiders, Iron's Spells mobs, Clanging Howl, Simple Enemy units, which have their own AI), Vanilla Backport's `parched` and `minecraft:wither_skeleton` (candidates if more skeletons are wanted). The mod's `enhanceableMobs` list (about 130 entries) says only ground-walking mobs probably work.
- Extra spawning (`ZAConfigSpawning` in the jar) is not registered in 1.13.1, so it cannot be set.

### Simple Enemy

File: `config/sem-common.toml` (enforced: a gameplay switch). Simple Enemy registers it as a Forge COMMON config named `sem-common.toml` (read from the jar, `ModConfigs`), so Forge fills the other keys with their defaults (not run).

| Key | Value | Reason |
| --- | --- | --- |
| `general_settings.enableVillageGarrison` | `false` | The default `true` spawns a hostile squad of 2 to 4 Russian or American soldiers near each village the first time its villagers load, which would fight Guard Villagers' guards and iron golems in every village. Chosen by the user (2026-11-24). Patrols, faction battles and cave squads near players still run (see `refs/issues.md`). Section and key name read from the jar's `GeneralConfig`. |

### Simple Enemy, Combined Arms, Enhanced Celestials 2, Clanging Howl, Guard Villagers

Added 2026-11-24. Nothing else is shipped; their main features are on by default:

- Guard Villagers (common config, read from its `1.20.1` branch source): 6 guards per village at the golem piece (`minecraft:village/common/iron_golem`), `Guards attack all mobs?` `true`, `All mobs attack guards` `false` (only zombies and illagers attack guards), `Mob Blacklist` villager, iron golem, wandering trader, guard, creeper, Alex's Mobs komodo dragon, enderman; witches attack villagers `true`, raid illagers attack animals `true`, guards turn into zombie villagers when zombies kill them `true`, guard arrows can hurt friendlies `true` (with a friendly-fire check), patrols `false`, conversion of nitwits and unemployed villagers without Hero of the Village allowed.

- Simple Enemy: timed events per player, evaluated every 1200 ticks (patrol base chance 0.1 per minute, faction battle 0.08, cave extraction 0.02, each rising after a miss), with a global cooldown between events; difficulty preset, accuracy, burst, drops (gun drop 0.5 inferred) and tactical AI budgets are in its config (read from the jar's config spec). Booleans from its `main` branch source: `enableVillageGarrison = true` (shipped as `false`, above), `ruUnitsFriendly = false`, `usUnitsFriendly = false`.
- Combined Arms: defaults (its wiki documents the orders).
- Enhanced Celestials 2: the event data lives in the Default Lunar Events jar (blood moon, super blood moon, blue moon, harvest moon and their super versions, super moon). The Overworld settings: events at least 3 and at most 98 days apart, clear skies required, year length 100 days. Changes would be a data pack (the pack ships none).
- Clanging Howl: defaults, `TechnoFleshBuff` on (buffs by game time), `MeteorShower` on (every 15 days, 180 s), six of the eight techno-flesh mobs start spawning on day 15 (`-1` disables a mob).

## Launcher

Not shippable in the `.mrpack`. Set in the launcher.

- Memory and JVM arguments.
- Window size (see the GUI scale note under Vanilla).

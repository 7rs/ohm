# Debug Keybind: comparison and review

Date: 2026-11-26. Decision 2026-11-27 (user): add, as Debug Keybind 5.0.0 with `pin = true` and no BoxLib metafile (the "Different choice" below). The condition list below, which names 9.1.1 and BoxLib by hand, was not taken.

Provisional: the market was searched with 24 single-topic Modrinth queries and 2 web searches; CurseForge was read for the candidate and its library only, not crawled. The convergence test of the comparison skill was not run (no snowball rounds), so the candidate list is a sample, not exhaustive. Nothing was run in the game. See `coverage_report.md`.

## Question

Add Debug Keybind (Modrinth `debug-keybind`, author Boxadactle) to the ohm pack (Minecraft 1.20.1, Forge 47.4.28)? What does it rebind, what does it need, does it fit the installed key-handling mods, and is a shipped default needed?

## Result

Recommendation: add, with conditions. This is a recommendation only; the user has approved nothing and nothing was added.

- It does what it says. It makes 17 keys of the F3 debug system rebindable (the Debug key F3, Hide GUI F1, and 15 combo keys), in its own screen. Every default is the vanilla key, so with no change it behaves like vanilla. [Measured by reading]
- It is client-only and needs one library, BoxLib 11.x, which Modrinth does not list as a dependency of this file, so packwiz will not add it. Both go in as `side = "client"`. [Measured by reading; Measured (Modrinth API)]
- 0 hard conflicts against the 138 installed jars. The only installed mod that touches the same area is BetterF3 (its own F3 combos), and the two share `KeyboardHandler.handleDebugKeys` with plain injects. [Measured by reading]
- It is a small, one-author mod with a slow 1.20.1 line (last 1.20.1 release 2025-03-23), and the file the user named was built for 1.20.2. All its mixin targets exist in 1.20.1, but one command (`/f3` with no argument) calls two 1.20.2-only methods. Nothing ships by default and no player has to use it. [Measured by reading]
- No other mod does this on Forge 1.20.1 (the Forge 1.20.1 search found one). The no-mod alternative (an operating-system key remap) works but is per player and outside the game.

Conditions for the add: put in `debug-keybind` 9.1.1 and `boxlib` 11.3.2 by hand (see Side and dependencies), both `client`; ship no setting; record the constraints below; treat the first launch as the test. Different choice: Debug Keybind 5.0.0, the older build made for 1.20.1, avoids the separate library and the 1.20.2 calls but has gaps of its own (see Candidates). Neither hold nor reject is supported by the evidence: no hard conflict, vanilla defaults, nothing shipped.

## Candidates

Source order: Modrinth first, CurseForge second. For this mod and its library both platforms hold the same release, uploaded within seconds of each other; neither is newer. [Measured]

| Candidate | Source | Version | Downloads | Last release | Forge 1.20.1 build | Side | Required dependencies |
| --- | --- | --- | --- | --- | --- | --- | --- |
| Debug Keybind 9.1.1 (the user's file) | Modrinth `debug-keybind` (CurseForge file 6337011, same release) | 9.1.1, `DebugKeybind-forge-9.1.1.jar`, sha1 `9dbc841d`... | Modrinth 65,261 (this file 2,835); CurseForge 19,705 (this file 145) | 2025-03-23 for 1.20.x; newest line 17.0.0 on 2025-10-20 (1.21.9 and 1.21.10) | Tagged 1.20.1 and 1.20.2, named "Forge 1.20.2". `mods.toml` minecraft `[1.20,)`. All 13 mixin injectors and the invoker resolve on 1.20.1; 39 of 41 Minecraft or Forge member references resolve, the 2 that do not are used only by the bare `/f3` command | client | BoxLib `[11.0.0,12.0.0)`, mandatory, side CLIENT |
| Debug Keybind 5.0.0 | Modrinth (CurseForge has it too) | 5.0.0, `DebugKeybind-5.0.0.jar` | this file 1,575 | 2023-10-02 | Built for 1.20.1 (`[1.20,1.20.1]`); 76 of 76 references resolve | client | BoxLib 9.0.0 inside the jar (Jar-in-Jar), nothing to add |
| BoxLib 11.3.2 (library of 9.1.1) | Modrinth `boxlib` (CurseForge file 5638423, same release) | 11.3.2, `Boxlib-forge-11.3.2.jar`, sha1 `a530d266`... | Modrinth 873,937 (this file 20,077); CurseForge 2,114,795 | 2024-08-17 (project pushed 2026-10-13 for newer versions) | Tagged 1.20.1 and 1.20.2; 127 of 127 references resolve | client | none beyond Forge and Minecraft 1.20.1 |
| No mod: OS or keyboard remap (Fn lock, a key remapper) | outside the game | | | | | per player | none |
| Thorough Keybindings, F3 CHANGER, RebindMyKeys, Rebind All The Keys | Modrinth (the last also CurseForge) | | 111,240 / 14,164 / 8,785 / not read | 2026-09 / 2026-09 / 2025-04 / not read | none: Fabric only (Modrinth loader lists) | n/a | n/a (would need Sinytra Connector, removed from the pack) |
| XYZ Copy, Better Gamemode (partial overlap, one or two combos each) | Modrinth | 1.0.1 / 1.4.0 | 1,826 / 7,755 | 2026-07-22 / 2025-07-26 (Forge 1.20.1 file) | Forge | client | not read |

Not alternatives (different function): no f3 (removes F3 features), DebugUtils (restores Mojang development tools), simpler keybinds (fires registered KeyMappings only; F3 combos are not KeyMappings). Older ones: ReBind (1.7.10 to 1.12.2), Legacy Rebindable Keys (1.6.4).

Debug Keybind 9.1.1 or 5.0.0, both read:

- 9.1.1: newer fixes (the author fixed lost bindings after leaving the screen with Esc around 2024-08, GitHub issue 4, inference that 9.1.0 and later carry it), saves `hideGui` (F1) in its config, adds the `/f3` client commands, needs BoxLib added by hand. Built for 1.20.2, so the bare `/f3` command is broken on 1.20.1 (below).
- 5.0.0: native 1.20.1, one jar, but its `KeybindConfig` has 16 fields and no `hideGui`, so the F1 binding probably is not saved (inference from the class), it hooks the keyPress `isKeyDown` calls by ordinal (4 `ModifyArg`, 2 injects) and `Component.empty()` in `refreshEntry` with a `@Redirect`, and it is 2 years old. Same scan result: 0 hard conflicts.
- Recommendation between the two: 9.1.1, the user's choice, unless the bare-`/f3` defect or the second metafile matters more.

## What it does (the jar, not the page)

Page claim: "A basic mod that adds keybinds for the F3 menu." [Claimed]

Read from the 9.1.1 jar [Measured by reading] (`data/dk_keybinds.tsv`):

- Seventeen keys, each with a vanilla default, saved as GLFW key codes in `config/debugkeybind.json`: Debug key F3, Hide GUI F1, and the combo keys A reload chunks, B hitboxes, C copy location, D clear chat, G chunk borders, H advanced tooltips, I inspect, L profiling, N creative or spectator, P pause on lost focus, Q help, S dump dynamic textures, T reload resource packs, F4 game mode switcher, Esc pause without menu. These are all 14 keys of vanilla's `handleDebugKeys` switch plus Esc, F3 and F1. Key codes the player leaves alone work as before; the key that was moved away from a combo's default key stops triggering it (`remapActionKey` returns -1 for it).
- The keys are not Minecraft `KeyMapping`s. They are the mod's own `GlobalKeybind` and `ActionKeybind` objects (a plain `InputConstants.Key` each). So they do not appear in the vanilla Controls list, in Controlling's search, in Key Binding Patch's shadow or combination handling, in Mine Menu, or in `options.txt` / Default Options' `keybindings.txt`. The mod has its own screen, `DebugKeybindsScreen`, opened by a "Debug Keybinds..." button it adds to the Controls screen (under the existing buttons, Done is moved down) or from the Mods screen config button.
- It shows a conflict mark in the vanilla key list when a `KeyMapping` is on F3 or F1 (the two global keys only; `DebugKeybinds.getCollisions`). The combo keys are never compared with KeyMappings.
- It also adds client commands under `/f3` (`toggle hitboxes|chunk_borders|advanced_tooltips|pause_on_lost_focus|profiling`, `copy location|inspect_data`, `reload chunks|resources`, `clear_chat`, `creative_spectator`, `help`, `dump_textures`, `gamemode`, `pause_menuless`). The bare `/f3` calls `Minecraft.m_293199_()` and `DebugScreenOverlay.m_293034_()`, which exist in 1.20.2 and not in 1.20.1; running it would throw `NoSuchMethodError` (an Error, so probably not caught by the command code; inference, not run). The sub-commands only use members that resolve.
- Not covered: the hold-to-crash combo (F3 held with C) keeps the physical `C`, and follows the Debug key. BetterF3's own combos F3+F, F3+Ctrl+F and F3+M are not rebindable (see Conflicts).
- Hooks (client mixin list only, `required: true`, `defaultRequire: 1`): `KeyboardHandler.keyPress` (3 `@ModifyConstant` on the integers 292, 256 and 290, 1 `@ModifyArg` on the `handleDebugKeys` call), `KeyboardHandler.handleDebugKeys` (`@Inject` HEAD cancellable, for the F3+Q help text; plus an invoker), `InputConstants.isKeyDown` (`@Inject` HEAD cancellable, returns false for the unbound key -1), `KeyBindsList$KeyEntry` (`render` RETURN and `refreshEntry` at `KeyMapping.isUnbound`, local capture `CAPTURE_FAILSOFT`), `ControlsScreen.init` (RETURN inject and a `@ModifyArg` on the third `bounds` call), `GameModeSwitcherScreen` (3 hooks for the F4 key).
- All of the above exist in the Forge 47.4.28 client for 1.20.1 (checked in the patched `KeyboardHandler`: five 292, one 256, one 290 and the call; `ControlsScreen.init` has three `bounds` calls; `refreshEntry` stores `Component.empty()` in local 1 and calls `isUnbound` once). The 14-key switch of `handleDebugKeys` is the same in the vanilla and the Forge-patched class. (`data/vanilla_1.20.1_evidence.txt`)

## Side and dependencies (from the jars)

- Debug Keybind: `side = "client"`. Modrinth says client required, server unsupported [Claimed, platform]. The jar agrees [Measured by reading]: every mixin is in the `client` list, `mods.toml` marks BoxLib `side="CLIENT"`, the mod class calls BoxLib and client classes with no `@OnlyIn` or `DistExecutor` guard (it would fail on a dedicated server, inference), and the jar registers no network channel (no `NetworkRegistry` or `SimpleChannel`).
- BoxLib: `side = "client"` for the same reason (no guard, client classes at start, no channel). Its single mixin only makes `CommandSourceStack` implement an interface; it has no injectors.
- `mods.toml` of both has no `displayTest`, so Forge uses `MATCH_VERSION` and the multiplayer list may show a version mark for a server without the mod. Joining is not blocked because no channel is registered (inference; the pack already has other client-only mods, not compared).
- BoxLib on Modrinth for 1.20.1 has only 11.3.1 and 11.3.2 (Forge and Fabric files carry the same version number "11.3.2-Boxlib": check that the metafile points to `Boxlib-forge-11.3.2.jar`, sha1 `a530d266fdb122dbac0fc2588ca42f9bdb1c4685`). BoxLib 10.4.0 is a 1.20-only build that was tagged 1.20.1 by mistake until 2024-12-19 (BoxLib issue 4); it is outside Debug Keybind's range `[11.0.0,12.0.0)`.
- Modrinth lists no dependency for 9.1.1 (Debug Keybind issue 19, open since 2026-04-16: the game stops at launch with a missing-mod screen when BoxLib is absent). Other lines (16.0.1) do list it. Remove BoxLib with Debug Keybind; nothing else installed uses it (no installed jar references `dev/boxadactle`).
- BoxLib has an HTTP module and a Google Translate client that Debug Keybind does not reference; BoxLib's startup does no network call. [Measured by reading]

## Conflicts with installed mods

Method: the Mixin annotations of the 138 installed jars (nested Jar-in-Jar one level; GT CRAFT and the Official Content Pack skipped, assets only; every jar hash equals its metafile) were read with `javap`, and every mixin whose target is `KeyboardHandler`, `KeyMapping`, `Options`, `KeyBindsList` (and `KeyEntry`), `KeyBindsScreen`, `InputConstants`, `ControlsScreen` or `GameModeSwitcherScreen` was listed: 47 mixin classes in 25 mods, 58 injector rows (`data/installed_hooks_of_interest.tsv`). A hard conflict is two `@Redirect` or `@ModifyConstant` on the same call, or an `@Overwrite` on a method the other hooks. Names are compared as written. The scan cannot see behavior.

| Installed mod | What it hooks next to Debug Keybind | Hard conflict | Behavior note |
| --- | --- | --- | --- |
| BetterF3 7.0.2 | `handleDebugKeys`: `@Inject` HEAD cancellable (F3+M opens its options, F3+F and F3+Ctrl+F cycle render and simulation distance) and `@Inject` RETURN (adds help lines to F3+Q); `keyPress`: 2 `@Redirect` on field writes (ordinal 0) and an inject at the debug-screen field write | none (different instructions) | Debug Keybind's remap returns a key unchanged when it is not the default key of one of its 15 actions, so F3+F and F3+M keep working on `F` and `M`, and they follow a rebound Debug key. If a Debug Keybind action is rebound to F or M, Debug Keybind wins (its `@ModifyArg` runs first). Its F3+Q help branch cancels `handleDebugKeys`, so BetterF3's extra help lines may be missing (order dependent, inference). Open BetterF3 issue 185 (2025-11-09): a crash when the Debug key is rebound to a letter that is also a combo key (B, V, E), reported on Fabric with BetterF3 16.0.3; not reproduced or reported for 1.20.1 Forge 7.0.2 [Claimed, GitHub] |
| Key Binding Patch 1.3.3.5 | `KeyBindsList.<init>` (2 `@Redirect`), `KeyEntry.refreshEntry` (`@Redirect` on `Component.translatable(String)` ordinal 0), `KeyBindsScreen`, `KeyMapping.<init>` injects, Forge `KeyMappingLookup` (`@Overwrite` put and getAll), `Options.processOptionsForge` | none (Debug Keybind injects at `KeyMapping.isUnbound` and at the end of `render`, no overlap) | Debug Keybind's keys are not KeyMappings, so Key Binding Patch's multi-binding, shadow keys and "fires every binding on a shared key" do not apply to them. Not run |
| Create: Steam 'n' Rails | `KeyEntry.refreshEntry`: `@WrapOperation` on `KeyMapping.same` | none | different call from the `isUnbound` inject |
| Controlling 12.0.2 | accessors on `KeyBindsScreen` and `KeyMapping` only | none | Its search bar covers KeyMappings; the Debug Keybinds screen is separate. Not run |
| Mine Menu, InvMove, Mouse Tweaks | Mine Menu: no hook on these classes; InvMove: `KeyMapping` only | none | they act on KeyMappings; the debug keys are invisible to them |
| Punchy! Moves 1.0.9b | `keyPress`: `@Inject` HEAD cancellable (emote keys through its own `EmoteKeybindManager`, key F for item switch animation, perspective key) | none | An emote key bound to a combo letter would fire in both; a rebinding choice, not a defect |
| Chloride, Small Ships, EMI, Remove Reloading Screen | `keyPress`: Chloride inject at `Window.toggleFullScreen` (F11), Small Ships inject at TAIL, EMI injects (`onKey`, `onChar`), RRLS `@WrapOperation` on `Minecraft.getOverlay` | none | different instructions |
| Default Options 18.0.5 | `Options.load` and `KeyMapping.setKey` hooks; it copies `extra/` during `Options.load`, which runs before the mods are constructed (`Options.<init>` precedes `ClientModLoader.begin` in Minecraft's constructor) | none | `keybindings.txt` cannot carry Debug Keybind keys |
| Embeddium, Oculus, Distant Horizons, Ixeris, Flerovium | no mixin on `KeyboardHandler`, `KeyMapping` (Oculus: 3 `Options` hooks for clouds, entrypoint and max-fps; Ixeris: caches `GLFW` calls) | none | Ixeris' GLFW key cache sits below `InputConstants.isKeyDown`; Debug Keybind returns before GLFW for the unbound key. Not run |
| BoxLib 11.3.2 itself | `CommandSourceStack`: interface only; installed mixins on `CommandSourceStack`: 1 accessor (Async Locator) | none | |

0 hard conflicts. Not checked: mods that listen to raw Forge key events (Distant Horizons' own debug keys, for example), key defaults of installed KeyMappings on F1 or F3 (the Controls screen would show them in red), the Forge 1.20.1 behavior of a client-only mod without `displayTest` on a dedicated server list.

## Settings

- It needs no shipped setting. It is on by default and does nothing until a player rebinds a key, because every default equals the vanilla key. There is no switch to turn the feature off. [Measured by reading]
- Where the player's keys live: `config/debugkeybind.json` in the game directory (created at first start; plain JSON with 17 integer fields: `debug`, `hideGui`, `reloadChunks`, `showHitboxes`, `copyLocation`, `clearChat`, `chunkBorders`, `advancedTooltips`, `inspect`, `profiling`, `creativeSpectator`, `pauseFocus`, `help`, `dumpDynamicTextures`, `reloadResourcePacks`, `openGamemodeSwitcher`, `pauseWithoutMenu`). Opened in game through Controls > Debug Keybinds or Mods > DebugKeybind > Config.
- `config/defaultoptions/keybindings.txt` does not work for it (the keys are not KeyMappings). The pack ships neither `keybindings.txt` nor any `key_` line in `options.txt` now.
- If a default is ever wanted: only `config/defaultoptions/extra/config/debugkeybind.json`, with only the changed keys (Gson fills the rest from the constructor defaults, inference). It is copied at `PRE_LOAD` only when the player has no file, and that happens before the mods are constructed (`Options.<init>` precedes `ClientModLoader.begin` in Minecraft's constructor; read, not run). Do not put the file directly under `config/`: the pack overwrites that folder on every update and would wipe each player's keys. Keys are hardware-dependent (a laptop Fn row), which the project rules keep out of shipped defaults.

## Constraints to record

- Add Debug Keybind and BoxLib together; both `side = "client"`; remove BoxLib with Debug Keybind.
- BoxLib must be an 11.x Forge build for 1.20.1 (`[11.0.0,12.0.0)`); never 10.x.
- Do not rebind the Debug key to a combo letter (A, B, C, D, G, H, I, L, N, P, Q, S, T) while BetterF3 is installed (BetterF3 issue 185, reported on Fabric 1.21.x).
- BetterF3's F3+F, F3+Ctrl+F and F3+M stay hard-coded; do not rebind a Debug Keybind action to F or M if those are wanted.
- Do not use the bare `/f3` command (1.20.2-only calls); the sub-commands are fine.
- The hold-to-crash combo is the Debug key held with `C`.
- Never ship `config/debugkeybind.json`; if a default is wanted, use `config/defaultoptions/extra/config/`.
- After `packwiz update`: re-check that the metafile of BoxLib still points at the Forge file and that Debug Keybind 9.1.1 still lists BoxLib `[11.0.0,12.0.0)`; a new 1.20.1 build would need the same scan.

## Risks and what was not checked

- Nothing was run in the game or on a server. First launch is the test: Mixin warnings from `debugkeybind.mixins.json` and `boxlib.mixins.json` in `logs/latest.log`, the Controls screen layout with Key Binding Patch and Controlling installed, rebinding F3 and one combo, F3+Q output next to BetterF3.
- The 9.1.1 file is built for 1.20.2; the mixin and member checks above are by reading. The `refreshEntry` inject uses `CAPTURE_FAILSOFT`; with `defaultRequire 1` a failed injection could stop the launch (all targets exist, so none is expected).
- Maintenance is thin: one author, 2 stars, 8 open issues (5 bugs; the only one on 1.20.1 is issue 19, the missing library; the others name 1.21.x), last 1.20.x release 2025-03-23. The author answers issues within weeks to months and keeps porting to new Minecraft versions (1.21.10 on 2025-10-20; a branch for 26.x exists). The mod is also tiny (25 classes), so a fork would be small if it were abandoned.
- Limits the issues name: keyboard keys only, no mouse buttons (issue 18, open; the jar uses `InputConstants.Type.KEYSYM`); no way to hide the Debug Keybinds screen from players (issue 20, open, asked by a modpack maker); a mod that rebuilds the Controls screen hid the button (issue 8, closed, fixed on the other mod's side). No installed mod hooks `ControlsScreen`, so the button should show.
- BoxLib's history: a 1.20-only build (10.4.0) was tagged 1.20.1 until 2024-12-19, and its 1.20.x builds needed Java 17 (issue 2). Its tracker has 0 open issues.
- Not read: the CurseForge-only 1.20.1 candidates (CurseForge was not searched), Better Gamemode and XYZ Copy beyond their pages, the Mods-screen config path under Forge Config Screens.
- Not compared: startup or frame-time cost (unmeasured; the hooks run on key events, and `isKeyDown` has one early compare).

## Records for the caller (after the user decides)

- `refs/list.md`, QoL: Debug Keybind, slug `debug-keybind`, modrinth, `github.com/Boxadactle/DebugKeybind`. Library: BoxLib, slug `boxlib`, modrinth, `github.com/Boxadactle/BoxLib`.
- `refs/notes.md`, Key Binding Mods: the constraints above. `refs/issues.md`: the open items under Risks. `refs/comparisons/index.md`: a row for `debug-keybind`.
- Not in `refs/settings.md` (nothing shipped).

## Evidence

`00_scope.md`, `products.csv`, `measurements.csv`, `sources.md`, `coverage_report.md`, `gh_issues.md`, `data/` (mixin annotations, installed hook table, reference checks, version tables, config keys), `scripts/`.

# Cubes Without Borders and the other borderless mods (Forge 1.20.1)

Status: provisional. Research date: 2026-11-23. Nothing was run in the game; every behavior below comes from reading the jar and the platform pages.

Decision (2026-11-24, user): Cubes Without Borders is in the pack, with `fullscreenMode = BORDERLESS` and `useDelayedFullscreen = false`, and Chloride stays installed with `fullscreen.mode = BORDERLESS`. The user wants Cubes Without Borders to lead. History: added 2026-11-23, removed the same day for Chloride's borderless mode, added again 2026-11-24.

Correction: this comparison took vanilla fullscreen as the baseline and did not check the installed mods for a built-in borderless mode. Chloride (a Sodium Extra fork) has one: `fullscreen.mode` (`WINDOWED`, `BORDERLESS`, `FULLSCREEN`), `attachModeF11` and `disableBorderlessOptimizations`, hooked through `BorderlessMixin$WindowMixin` and `BorderlessMixin$KeyboardHandlerMixin`. The facts about the other mods below stay as read.

## Overlap with Chloride (read from both jars 2026-11-24, not run)

| | Chloride | Cubes Without Borders |
| --- | --- | --- |
| Hook on `Window.setMode` | `@Redirect` on `glfwSetWindowMonitor` and `glfwGetWindowMonitor` | `@WrapOperation` on the same two calls (and `@Inject` around `toggleFullScreen`, `updateFullscreen`) |
| Startup | At `FMLClientSetupEvent`: if vanilla `fullscreen` differs from `mode != WINDOWED`, calls `setFullScreenMode(mode)` | At window creation: sets the window and the vanilla `fullscreen` option from `fullscreenMode`; with `useDelayedFullscreen = true` (default) it waits until the loading overlay ends |
| F11 | Cancels the vanilla toggle and cycles its own modes, in every `attachModeF11` setting | Not reached while Chloride cancels it |
| Can it be switched off? | No: its mixin plugin only gates the JEI, REI and EMI mixins | Config only |
| After `glfwSetWindowMonitor` | If not its own borderless path, sets `GLFW_DECORATED` to true | Calls the original unchanged, then adds its own handling |

- Mixin order cannot be set from a config. The pack keeps both mods in the same state instead: with `useDelayedFullscreen = false` the vanilla `fullscreen` option is already `true` when Chloride's startup check runs, so the check does nothing.
- Open risk: Chloride's `GLFW_DECORATED` reset may bring the title bar back. See `refs/issues.md`. Fallback: remove Cubes Without Borders.

## Headline

Cubes Without Borders is the clear leader on every measurable axis (downloads, activity, platform coverage). It does not optimize anything; it is a player preference. It is opt-in per player, so shipping it changes nothing until the player switches the video setting.

## Fact table

| | Cubes Without Borders | Fullscreen Tweaks | True Window |
| --- | --- | --- | --- |
| Downloads, Modrinth (all versions) | 30,365,660 | 17,889 | 4,176 |
| Downloads, Modrinth (Forge 1.20.1 files) | 867,004 (2 files) | 1,598 (5 files) | 649 (1 file) |
| Latest Forge 1.20.1 release | 5.0.0+1.20.0.forge, 2026-10-24 | 2.0.2+1.20.1-forge, 2026-10-05 | 1.0.1, 2026-08-03 |
| Repository | Kira-NT/cubes-without-borders, 42 stars, last commit 2026-11-23, 0 open issues | oggvik/stop-minimizing-on-focus-loss-mc | none linked |
| Side (Modrinth) | client required, server unsupported | client required | client required |
| Dependencies | none required (Cloth Config optional) | none | none |
| Declared incompatible | Borderless Mining, Borderless Window, Borderless Windowed, Borderless Fullscreen, Concentration, Windows Titlebar Delete, FW | not read | not read |

## Source, read (Cubes Without Borders jar 5.0.0+1.20.0.forge)

- Client mixins (`defaultRequire = 1`): `GuiMixin`, `MainMixin` (command line `--windowed`, `--borderless`), `VideoSettingsScreenMixin`, `WindowMixin`.
- `WindowMixin` wraps (MixinExtras `WrapOperation`) `GLFW.glfwWindowHint`, `glfwSetWindowMonitor`, `glfwGetWindowMonitor` and the monitor lookup of `Window`.
- Modes: `OFF`, `EXCLUSIVE`, `BORDERLESS`, `WINDOWED`. Config keys include `fullscreenMode`, `preferredFullscreenMode`, `useDelayedFullscreen`, `useScaledFramebuffer`, `pauseOnLostFocusDuringMultiplayer`. The player picks the mode in Video Settings; it is not on by default.
- The README (Claimed) says it keeps input latency low and supports Windows, Linux and macOS, and recommends Sodium alongside. It lists Windows cursor problems with Medal, OBS and pointer trails.

## Observations for this pack

- None of the declared-incompatible mods is installed.
- Ixeris and Embeddium are installed. Ixeris hooks `Window` too (`WindowMixin` around `glfwFreeCallbacks`); no shared injection point was found, not run.
- ThreatenGL (see `refs/comparisons/opengl-context/`) redirects the same `GLFW.glfwWindowHint` call in `Window.<init>` that Cubes Without Borders wraps. Do not add both without a test.
- First-launch default: shipped as `config/defaultoptions/extra/config/cwb.json` (`fullscreenMode`, `useDelayedFullscreen`). `fullscreen` is not set in `options.txt`: Cubes Without Borders overwrites the vanilla option from its own state when the window is created.

## Excluded

| Mod | Reason |
| --- | --- |
| Concentration | Description says Minecraft 1.20.6 and newer; also on the incompatibility list |
| Windows Titlebar Delete | Declared incompatible; Windows only; 3,131 downloads |
| Fullscreeno | Disables starting in fullscreen; different goal |

## Coverage

- Market from Modrinth only. Borderless Mining and similar CurseForge mods were not enumerated.
- Evidence levels: downloads and dates Measured, hooks Measured by reading, latency claims Claimed.

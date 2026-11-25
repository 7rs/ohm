# Mods that hide the experimental-settings warning (Forge 1.20.1)

Status: provisional (see `coverage_report.md`). Research date: 2026-11-22. Nothing was run in the game; every behavior below comes from reading code.

Decision (2026-11-22, user): Yeetus Experimentus was added to the pack.

## Headline

All four mods with a Forge 1.20.1 build remove the confirmation at world creation. None is clearly best. The choice depends on what you value:

- Narrowest and switchable: Experimental Settings Disabler (3 hooks, one config switch, no dependency). The source is not public and the last 1.20.1 build is from 2023.
- Most field-proven: Yeetus Experimentus (about 13.3 million Modrinth downloads for the Forge 1.20.1 builds, no dependency, no config). It also skips one more vanilla prompt on world load.
- Actively maintained with public source: Hide Experimental Warning. It needs Collective, a large library, and the real hooks live in Collective.
- Experimentalist is a different tool (global experimental features). Its Forge 1.20.1 build has 690 Modrinth downloads. Not a fit for this goal.

## Fact table (the four requested items)

| | Yeetus Experimentus | Experimental Settings Disabler | Hide Experimental Warning | Experimentalist |
| --- | --- | --- | --- | --- |
| Downloads, Modrinth (all versions) | 20,409,323 | 427,181 | 958,092 | 98,519 |
| Downloads, Modrinth (Forge 1.20.1 files) | 13,254,106 | 287,180 | 438,726 | 690 |
| Downloads, CurseForge (all versions) | not found | 9,753,326 | 3,151,207 | 218,157 |
| Latest Forge 1.20.1 release | 2.3.1, 2023-08-03 (2.3.0-build.4 is listed 2023-09-16) | 3.0, 2023-10-27 | 1.3, 2026-10-02 | 2.0.3, 2025-12-01 |
| Project last updated | 2026-09-19 (other Minecraft versions) | 2024-03-13 | 2026-10-28 | 2026-03-31 |
| Dependencies | none | none | Collective 8.40 or newer | none (MixinExtras bundled) |
| Public source | yes, but `main` is a newer layout, not the 1.20.1 code | no | yes (GitHub) | yes, but the 1.20.x Forge code is not on a visible branch |
| Config | none | `experimentalsettingsdisabler-client.toml`, `Experimental_futures_disabler = true` by default | none | `experimentalist.json` (feature toggles, all off by default) |

CurseForge per-file counters were not used (see `coverage_report.md`).

## README, read concretely

- Yeetus Experimentus: one sentence, "Disable's the Experimental Settings popup, which appears when you create or load world." plus an icon credit. No mechanism, no config, no compatibility notes.
- Experimental Settings Disabler: "Disables the experimental world icon, generation and loading warning settings during modded world creation." plus banner and social links. No technical detail.
- Hide Experimental Warning: hides the experimental warning "when creating or loading a modded world", and the yellow triangle in the world list; newer versions also hide the "Experimental" text. States it began as a fix for the author's own development environment. No dependency note in the README text itself, although `mods.toml` requires Collective.
- Experimentalist: removes the "Worlds using Experimental Settings are not supported" screen and lets you enable experimental features globally. Those features are on by default at world creation and hidden from the experimental features screen. Worlds using them are not flagged experimental. Config in `experimentalist.json`, applied after restart. States "no dependencies (not even Fabric API)".

## Source, read

### Yeetus Experimentus (jar 2.3.1 and 2.3.0-build.4, identical class sizes)

- Client mixins with a Forge refmap, `defaultRequire = 1`.
- `CreateWorldScreenMixin`: injects into `tryApplyNewDataPacks` before the `getRequestedFeatureFlags()` call, calls the pack-apply method `m_269431_` and cancels. This skips the confirmation of the datapack screen in world creation.
- `WorldOpenFlowsMixin`, hook 1: in `confirmWorldCreation`, replaces the first `setScreen` (the confirm screen) by running the creation `Runnable`.
- `WorldOpenFlowsMixin`, hook 2: at the head of `loadLevel` it calls `doLoadLevel` with `(false, false)` and cancels. Vanilla `loadLevel` passes `(false, true)` (read from the vanilla bytecode). The fourth argument gates a branch of `doLoadLevel` that opens a confirm screen through `m_233140_` (probably the backup confirmation; that name was not checked). So loading an existing world also skips that prompt, not only the experimental one.
- All hook targets exist in the Forge-patched 47.4.28 classes.

### Experimental Settings Disabler (jar 3.0, no public source)

- Three client mixins with `defaultRequire = 1`; the first has a Forge refmap, the other two use names Forge adds.
- `ExperimentalWorldCreationMixin`: in `confirmWorldCreation`, when the config is on, runs the creation `Runnable` and cancels.
- `ExperimentalLoadingInMixin`: `PrimaryLevelData.hasConfirmedExperimentalWarning()` returns the config value at the head.
- `ExperimentalIconMixin`: cancels `WorldListEntry.renderExperimentalWarning`, so the triangle icon is not drawn.
- One Forge client config key, default on. `clientSideOnly = true` in `mods.toml`.
- All hook targets exist in the Forge-patched 47.4.28 classes.
- It does not touch `loadLevel`, so the backup prompt of world loading stays.

### Hide Experimental Warning (jar 1.3, GitHub source read for `Common/`)

- Its own jar has one mixin: `LevelSummaryMixin` makes `isExperimental()` return false at the end (priority 1001). That hides the world-list icon.
- `ModCommon.java` says the mod holds no logic itself and only triggers Collective's mixins.
- Collective 8.87 (Forge) mixins `WorldOpenFlowsMixin` (in `confirmWorldCreation`, runs the `Runnable` and cancels) and `PrimaryLevelDataMixin` (`hasConfirmedExperimentalWarning` and `withConfirmedWarning`) are guarded by a check on the development environment and on `hideexperimentalwarning` being loaded.
- Collective is a large library: 1.1 MiB, 20 Forge mixin classes (many unrelated to this topic, such as `BlockEntityMixin`, `EntityMixin`, `ServerLevelMixin`), 155 Forge 1.20.1 releases since 2023-06-12 (newest 2026-11-15), and 71.9 million Modrinth downloads.
- All hook targets exist in the Forge-patched 47.4.28 classes.

### Experimentalist (jar 2.0.3 Forge, GitHub `main`-line source not matching)

- `LifecycleMixin` wraps `Lifecycle.experimental()` so it returns `STABLE` everywhere. This is global, not limited to the screens.
- `DataPackConfigMixin`, `FeatureFlagsMixin` and `ServerPacksSourceMixin` apply the feature toggles (all off by default). `ClientMainMixin` loads the config at client start.
- MixinExtras 0.5.0 is bundled through Jar-in-Jar; `defaultRequire = 1`.
- It hides the screens indirectly (a stable lifecycle never asks for confirmation). That the creation screen stays silent on Forge 1.20.1 follows from that, but was not run.

## Observations for this pack

- Forge 47.4.28 has no config key for this warning, so a mod is the only way.
- Installed ModernFix (`extra_experimental_screen`, injecting into `createNewWorld`) and The Aether (`doLoadLevel`, `openFresh`) already touch the same classes. None of the four candidates injects into those methods, but no combined test was run.
- Yeetus Experimentus and Experimental Settings Disabler both hook `confirmWorldCreation`. Do not install both.

## Excluded

| Mod | Reason |
| --- | --- |
| Shutup Experimental Settings! (CurseForge) | No Forge 1.20.1 build (Forge 1.18.1 to 1.19.2 only) |
| No Worldgen Warning (CurseForge) | Silences a log message; does not touch the screen |
| DirectEntry | Forge 1.21.1 only |
| Disable Custom Worlds Advice, Skip Backup Screen, Here Be No Dragons, I Know What I'm Doing | Fabric or Quilt only |
| DeclutterUI | NeoForge only |

## Files

- `00_scope.md`, `products.csv`, `measurements.csv`, `sources.md`, `coverage_report.md` in this folder.

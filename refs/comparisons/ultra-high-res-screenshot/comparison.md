# Ultra-high-resolution screenshots: comparison

Decision: pending (user).

Status: provisional, research date 2026-11-25. The convergence test did not pass in full (`coverage_report.md`). Nothing was run in the game: every statement is Measured, Measured by reading, Claimed or inference, as labeled. The user has not approved anything.

## Result

- Question: a mod for screenshots larger than the window (8K and up) that works with the Oculus 1.8.0 shader packs and Distant Horizons 3.3.3 of this pack.
- Recommendation: add HiResShot 0.0.1 (client-only, key F9), but only after a test in a scratch instance; hold Forgeshot as the fallback; no other candidate fits (BigShot and Pixelshot's default path render into a separate target and are reported to give black, blue or cropped images with Iris; Snapmatica freezes with Distant Horizons). If the real need is only sharper window-sized shots, "no mod" or RenderScale (not installed) is enough.

Conditional headline: HiResShot is the pick for "one big image up to the GPU limit". Nothing found makes real detail beyond the GPU limit reliable with shaders. The recommendation rests on code reading and on third-party reports about the other mods; nobody reported HiResShot with Oculus or DH, good or bad.

## What "no mod" already achieves, and what it cannot

- Vanilla F2 saves the main render target at the window's framebuffer size (Measured by reading, 1.20.1 client bytecode). A larger window (Prism window size, 4K monitor, DPI scaling) raises it; the ceiling is the monitor and OS window size and `RenderSystem.maxSupportedTextureSize()` (vanilla `RenderTarget.createBuffers` throws `IllegalArgumentException` above it). Whether a window can be created above the monitor size was not checked.
- RenderScale 2.0 (not installed): the world is rendered at a scale and brought down to the window; its own test asserts the same file size as a native shot, and its README sends users to Fabrishot for large screenshots (Measured by reading). It gives anti-aliased window-sized shots, not larger files.
- No shader pack has a screenshot mode (grep of the five installed zips; BSL's text only warns that its off-by-default `REFLECTION_PREVIOUS` can miss reflections "caused by screenshot size setting").
- Vanilla contains a tiled "huge screenshot" routine (`Minecraft.grabHugeScreenshot`, projection zoom and offset per tile) but no key calls it; Pixelshot's `tiledRendering` option calls it.
- Offline stitching of overlapping shots was not evaluated. With TAA and auto exposure in every installed pack the shots would differ in exposure.

## Candidates

All have a Forge 1.20.1 build (`mods.toml` with `javafml`, read). Modrinth and CurseForge list the same file and date for each of p01 to p06 (CurseForge widget), so Modrinth is the source; Snapmatica was not looked up on CurseForge. "File" = the Forge 1.20.1 file(s) on Modrinth. A project total counts all Minecraft versions: the large totals of BigShot and Forgeshot are mostly other versions.

| # | Candidate | Version | Last 1.20.1 release | Downloads project (Modrinth / CurseForge) | Downloads, 1.20.1 file | Side (jar) | Required dependencies |
| --- | --- | --- | --- | --- | --- | --- | --- |
| p01 | HiResShot | 0.0.1 | 2026-01-01 | 2,974 / 3,296 | 1,127 | client; no `clientSideOnly`; metafile `side = "client"` | Cloth Config >=11.1 (installed 11.1.136) |
| p02 | Forgeshot | 1.0 | 2024-01-23 | 413,871 / 283,172 | 7,865 | client | none |
| p03 | Power Screenshot | 1.0.1 | 2026-03-24 | 5,919 / 121,293 | 552 | client | none |
| p04 | Pixelshot | v20.1.0 | 2026-05-21 | 26,924 / 44,482 | 680 | client | Puzzles Lib >=8.1.30 (installed 8.1.36) |
| p05 | BigShot | 1.0.1 | 2023-12-07 | 414,437 / 185,380 | 5,987 | client | none |
| p06 | Picture Mode | 1.1.8 | 2026-11-10 | 245,879 / 85,014 | 11,746 (18 files) | client | none (YACL optional) |
| p07 | Snapmatica | 1.3.5 | 2026-09-25 | 1,707 / not checked | 74 (4 files) | client | none |

Side: none of the jars declares `clientSideOnly` (HiResShot and Power Screenshot carry the line as a comment); all use key mappings, `Window` and render classes, and Modrinth says client required and server unsupported. Set `side = "client"` for any of them. Downloads: Measured 2026-11-25.

## Function: capture method, limits, shader and Distant Horizons behavior

Why the capture target decides (Measured by reading):

- Oculus 1.8.0 `FinalPassRenderer` reads `Minecraft.getMainRenderTarget()` and writes its final image into it; `IrisRenderingPipeline` sizes all shader buffers from the main target's width and height (`RenderTargets.resizeIfNeeded`). So a mod that resizes the main target gets the shader output at the new size; a mod that renders into its own `TextureTarget` while the main target stays window-sized leaves that target without the shader image (inference from the code; the reports below match it).
- Distant Horizons 3.3.3 takes its viewport size from the main render target (`getTargetFramebufferViewportWidth/Height`) and sizes its own colour, depth and TAA textures from it, so it follows a main-target resize. It hooks `LevelRenderer.renderChunkLayer(..., Matrix4f)` for the projection (a tiled shot would pass a shifted matrix: inference).

| Candidate | Capture | Size limit and what happens beyond it | Shaders and DH: code | Shaders and DH: reports | Verdict |
| --- | --- | --- | --- | --- | --- |
| p01 HiResShot | Resizes the main target and window fields, waits `realtimeDelay` frames (20), reads the main target, restores, then calls `Iris.reload()` | Checks `maxSupportedTextureSize()` and shows a chat error instead of trying. Multiplier 2 to 64, custom size up to 64000. CPU_UPSCALE only bicubic-upsamples a render of at most 16384 px | Matches how Oculus and DH size themselves. Real-time mode is made for shaders (waits for TAA and exposure). Hides GUI, hand and the player | none either way; the author claims shader support | Best fit |
| p02 Forgeshot | Same idea (port of Fabrishot): window fields plus `resizeDisplay()`, `delay` frames (3), `glReadPixels`, PNG or JPG | None. Any size up to `Integer.MAX_VALUE`; above the GPU limit vanilla throws in frame 0 outside a try block (inference: crash report). The hook runs before and after each render, so the real wait is about half of `delay` | Same as p01. Fabrishot's own tooltip says the delay is "for better exposure with shaders" (claimed) | none (0 issues) | Fallback |
| p03 Power Screenshot | `/screenshot normal <w> <h>` (1 to 16384): framebuffer override plus `resizeDisplay()`, waits one tick | No GPU check; the command clamps to 16384 | Normal path is a main-target resize. Skybox and panorama faces use a separate target | Skybox black with Iris (open, 3 users) | Hold: command only, shortest settle time (the F8 clash is a rebind, not a reason) |
| p04 Pixelshot | Default: separate `TextureTarget`, `renderLevel` only. Option `tiledRendering`: vanilla tiles with a shifted projection | Default crashes above the GPU limit (config text); tiled can freeze the game ("rarely, indefinitely") | Default path leaves the main target window-sized. Tiles run the full shader pipeline per tile: screen-space effects and TAA history across tiles are not tile-safe (inference) | Blue image with Iris (open, 4 users); tiled helped one NeoForge user and did not help a Forge 1.20.1 + Oculus + Embeddium user; Voxy and FOV issues open | Hold: only candidate that can exceed the GPU limit, unproven here |
| p05 BigShot | Separate `TextureTarget` at 2x, 3x or 4x of the window | No GPU check; catches `Exception` only | Same weakness as the Pixelshot default path | Black image with Iris (open since 2023, no reply); cropped image with Iris, Sodium and DH (open) | Reject |
| p06 Picture Mode | Only from its isometric (orthographic) screen: window size times `res_multiplier` (default 1.0), main-target resize, `frame_delay` 5 | Fixed sizes only checked against 2^31 pixels; no GPU check | Hooks Embeddium's renderer (it maps `sodium` to Embeddium); nothing for Oculus or DH; its Voxy branch is unmerged | none found | Reject for this request (wrong tool: isometric only) |
| p07 Snapmatica | Camera simulation on a window-sized shot; no resize | none | Calls the DH terrain raycast on the render thread for autofocus | Render thread freezes forever with DH 3.3.3 (open, 2026-11-23, 1.21.1 report; the same `DhIntegration` file is in the 1.20.1 branch) | Reject |

Other things read: HiResShot's CPU_UPSCALE adds no detail, and the page's "arbitrary size, no VRAM crash" claim holds only in that sense (flag). Power Screenshot also records panoramas (a 360 strip stitch, a six-face skybox, a GIF); Pixelshot has a panorama key and an orthographic camera (F7).

## Limits and memory

Estimates, not measurements (`scripts/memory_estimate.py`, `data/memory_estimate.csv`). Shader buffers: the `colortexNFormat` lines declared by each pack, times two (Oculus keeps a main and an alt texture per target, read from its `RenderTarget` class), assuming every declared buffer is full size and allocated; Complementary sizes two buffers by `REFLECTION_RES`, so its figure is an upper bound. Other: 20 bytes per pixel (vanilla colour and depth 8, depth copies 4, DH colour and depth 8).

| Output size | Pixels | GPU, no shader pack | BSL | I Like Vanilla | Mellow | Solas | Complementary (upper) | CPU read-back, RGBA |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 4K (3840x2160) | 8.3 M | 0.15 GiB | 0.8 | 0.9 | 0.5 | 0.9 | 1.2 | 0.03 GiB |
| 8K (7680x4320) | 33.2 M | 0.6 GiB | 3.1 | 3.5 | 1.9 | 3.6 | 4.7 | 0.12 GiB |
| 15360x8640 | 132.7 M | 2.5 GiB | 12.4 | 13.8 | 7.4 | 14.3 | 18.8 | 0.49 GiB |
| 16384x16384 | 268.4 M | 5.0 GiB | 25.0 | 28.0 | 15.0 | 29.0 | 38.0 | 1.0 GiB |

- The hard limit is `GL_MAX_TEXTURE_SIZE` as probed by `RenderSystem.maxSupportedTextureSize()`; the value of this GPU is unknown (typically 16384 or 32768, claimed general knowledge). VRAM is the second limit: with a shader pack, 8K is a few GiB, 16K needs a large card.
- Beyond the limit: vanilla `RenderTarget.createBuffers` throws `IllegalArgumentException` for a side above the probe and `checkStatus()` throws `RuntimeException` for incomplete or out-of-memory framebuffers (read). HiResShot checks first and says so in chat; Forgeshot, Power Screenshot and Picture Mode do not (inference: exception in the render or tick loop, likely a crash report); BigShot catches `Exception` and reports a failure; Pixelshot builds its target outside the try block.
- Memory on the CPU side: HiResShot and Picture Mode read into a vanilla `NativeImage` (off-heap, 4 bytes per pixel); Forgeshot uses a direct `ByteBuffer` (3 bytes per pixel; the direct-memory limit defaults to the max heap, 4 GiB by Prism's default per `refs/issues.md`). HiResShot's CPU_UPSCALE builds a `BufferedImage` on the Java heap: avoid it with the 4 GiB default.
- Look at high resolution (inference): all five packs ship TAA, bloom, ambient occlusion or SSAO, whose radii may be defined in pixels; a 4x shot can look different from the on-screen frame. Compare a downscaled crop against a window-sized shot before trusting it.

## Conflicts with installed mods

Mixin scan of the 7 candidates against all 136 installed jars (Jar-in-Jar included; `data/mixin_overlap.md`). Rule: hard conflict = same `@Redirect` or `@ModifyConstant` call, or `@Overwrite` on a method another mod hooks. Names compared as written, so Mojmap against SRG spellings of one method are not matched; to cover that gap the SRG names of Embeddium's six `@Overwrite` methods on `LevelRenderer` were looked up in the refmaps of the candidates (see Picture Mode below).

- 0 hard conflicts for all seven (Measured by reading). HiResShot has only accessors (no injectors at all); BigShot hooks two methods no installed mod hooks.
- Plain shared hooks (no conflict by the rule): Forgeshot and `Minecraft.runTick` with Chloride, Embeddium, AsyncParticles, Ixeris, Xaero's World Map; Power Screenshot and `GameRenderer.render` with Embeddium, LR Tactical, ModernFix, Punchy! Moves, Remove Reloading Screen; Pixelshot and `GameRenderer.renderLevel` with Oculus, Chloride, Shoulder Surfing Reloaded, Superb Warfare, Punchy! Moves, Immersive Aircraft, and `LevelRenderer.renderClouds` with Distant Horizons, Embeddium, Oculus. Picture Mode: 173 same-method pairs (Camera.setup, getFov, renderLevel, Embeddium renderer classes), a reason to keep it out. Whether they coexist at run time was not tested.
- The one SRG-level hit: Picture Mode's `LevelRendererMixinVanilla` hooks `LevelRenderer.setupRender` (refmap: `m_194338_`), which Embeddium 0.3.31 overwrites. That is a hard-conflict pattern by the rule, but Picture Mode's own mixin plugin disables the class when `sodium`, `embeddium` or `rubidium` is present (platform helper bytecode read; the `!HAS_SODIUM` condition read from the plugin source on the rewrite branch, not from the jar's lambda). The scan itself missed it because of the Mojmap against SRG spelling. No other candidate touches Embeddium's overwritten methods (`m_109821_`, `m_109825_`, `m_172993_`, `m_194338_`, `m_109494_`, `m_109490_`).
- Key bindings (Measured by reading, jar bytecode): HiResShot F9 is free among the 136 jars. Power Screenshot F8 and Pixelshot F8 equal Punchy!'s `open_main_menu`; Forgeshot F6 equals Punchy!'s `save_session`; Key Binding Patch fires every binding on one key (`refs/issues.md`), so those pairs fire together until one key is rebound. The user ruled on 2026-11-26 that a key clash is not a reason to exclude a mod: rebind it (a shipped default goes in `config/defaultoptions/keybindings.txt`, which applies only when the player has no such file).
- RenderScale 2.0.0-beta.1 (candidate, not installed; `data/mixin_overlap_renderscale.md`): 0 hard conflicts with the candidates, but it returns scaled values from `Window.getWidth`, `getHeight` and `getGuiScale` and hooks Oculus's `RenderTargets.resizeIfNeeded`, the sizes a main-target resize changes (read). Fabrishot ships a mixin that cancels RenderScale's scaling while it captures; none of the Forge candidates has one, so with both installed the world would probably be rendered at target size times the scale (inference). Test before pairing.
- Oculus, Embeddium and Distant Horizons are not hooked by HiResShot at all; the only contact is its reflective `Iris.reload()` after a capture (the method exists in Oculus 1.8.0). Colorwheel and AsyncParticles also hook `Iris.reload` (`refs/notes.md`); they run on that reload as they do on F3+R.
- Existing DH report: window resize stopped LOD rendering on a 2.3.0 dev build (DH issue 850, closed). A main-target resize is the same class of event; whether 3.3.3 is affected is unknown.

## Settings the pick needs

HiResShot (`config/hiresshot-client.toml`, a Forge CLIENT config, read from `HRSConfig`):

- Does the mod disable its main feature by default? No: F9 is bound, `captureMode = REAL_TIME`, `multiplier = 4`, `realtimeDelay = 20`, `hideGui = true`, `hidePlayer = true`.
- Needs nothing shipped for the job. Writing only differing keys means shipping no file. Candidate tweaks, per player: `realtimeDelay` 40 to 60 if a shot looks dark or noisy under a pack (the author recommends 20 to 60); `useCustomResolution` with an exact size; leave `captureMode` on REAL_TIME (INSTANT calls `GameRenderer.render` in a loop from inside the key event handler, outside the game's own render loop; CPU_UPSCALE adds no detail).
- If a file were shipped it is a client setting, so it would go under `config/defaultoptions/extra/config/hiresshot-client.toml`, not `config/`.
- A 1080p window times 4 is 7680x4320; a 4K window times 4 is 15360x8640, under a 16384 limit but needing the VRAM in the table (12 GiB and more with BSL, I Like Vanilla, Solas or Complementary).

## What to avoid beside it

- Do not add another capture mod beside HiResShot (BigShot, Pixelshot, Forgeshot, Power Screenshot): no hard conflict, but duplicate jobs (the F8 and F6 key collisions with Punchy! are only a rebind).
- Do not add Snapmatica (Distant Horizons freeze report) or a Replay Mod port (video pipeline; a third-party pack page says it breaks Distant Horizons plus Iris, claimed).
- Do not add RenderScale and HiResShot together without a test (see above).
- Do not rely on CPU_UPSCALE for "real" resolution.

## Future

- HiResShot: one 1.20.1 release (2026-01-01); 133 commits over all branches, last 2026-01-17, none since (10 months); one author; MIT; branches for Forge 1.12.2, 1.18.2, 1.19.2, 1.20.1 and NeoForge 1.21.1 and 1.21.10. Direction unknown; risk of abandonment is real, but the mod is small (15 classes) and removable.
- Forgeshot: the project is active for new Minecraft versions (last commit 2026-10-18) but the 1.20.1 file has stood since 2024-01-23.
- Pixelshot: active (Fuzs, last commit 2026-09-24); 1.20.1 port 2026-05-21; 4 of 7 issues open, none answered about shaders beyond "use tiled".
- BigShot: 1.20.1 frozen since 2023-12; newer versions ported until 2025-12; shader issues unanswered.
- Power Screenshot: active, 28 commits, last 2026-06-28. Picture Mode: active (1.1.8 on 2026-11-10), different goal. Snapmatica: active; 371 of 490 commits are authored as "Claude".

## Ranking and conditions

1. HiResShot: add after a scratch-instance test (see below). Best code fit, young.
2. Forgeshot: hold as the fallback if HiResShot misbehaves (same method, no GPU check, 1.20.1 build frozen).
3. Power Screenshot: hold; useful only if panoramas or a command-line size are wanted (F8 is shared with Punchy!; rebind).
4. Pixelshot: hold; the only route past the GPU limit, not proven with Oculus (Forge 1.20.1 + Oculus report says tiled did not help).
5. No mod / RenderScale: enough if the need is sharper window-sized shots.
6. BigShot, Picture Mode, Snapmatica: do not add.

Scratch-instance test (suggested, not run): with Oculus and each of the five packs plus Distant Horizons on, shoot at multiplier 2 and 4 in a spot with LODs, water and a light source; check the image is not black or blue, that LODs and clouds are present, that a downscaled crop matches a window-sized shot, that no GL error appears in `logs/latest.log`, and watch GPU memory.

## What was not checked

- Nothing ran: no image, GPU memory, frame time or crash was observed. Every Oculus and DH statement is from reading code and reading other people's reports.
- The GPU model, its `GL_MAX_TEXTURE_SIZE` and VRAM are unknown.
- Which shader packs behave with a main-target resize; whether auto exposure and TAA settle in 20 frames at 8K.
- Whether a window above the monitor size can be created on this OS.
- Picture Mode's Codeberg tracker, HiResShot issue 1's text, Oculus issues 678, 679 and 691, ReForgedPlay and Recordium jars.
- Server-list labels for client-only mods without a `displayTest` (BigShot, Forgeshot, Snapmatica, Picture Mode) on a dedicated server.
- CurseForge was not crawled; CurseForge-only projects may be missing.

## Open questions for the user

1. Target size and purpose (wallpaper, poster, print)?
2. GPU and VRAM?
3. Shader pack used for the shots?
4. Panoramas wanted?
5. Ship the mod to all players or keep it in the user's instance?

## Files

`00_scope.md`, `products.csv`, `measurements.csv`, `sources.md`, `coverage_report.md`, `gh_issues.md`, `scripts/`, `data/` (`mixin_overlap.md`, `mixin_overlap_renderscale.md`, `mixins_renderscale.tsv`, `mixins_candidates_latest.tsv`, `mixins_installed_shared_targets.tsv`, `keyscan_installed.tsv`, `memory_estimate.csv`, `project_summary.csv`, `mr_merged.csv`).

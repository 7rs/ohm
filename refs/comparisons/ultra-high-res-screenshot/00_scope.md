# Scope: ultra-high-resolution screenshots

Research date: 2026-11-25. Nothing was run in the game. The user has approved nothing.

## Question

The user asked (Japanese, translated): "I want to add a mod for ultra-high-resolution screenshots." No more detail was given, so the questions Step 0 would ask are under "Open questions" below.

## Reading of the request (my reading, not the user's words)

"Ultra-high-resolution" means an image file larger than the game window, ideally 8K (7680x4320) and up to the GPU limit, taken with Oculus shader packs and Distant Horizons LODs on. Detail must be real (rendered), not interpolated.

| Approach | Counts? | Why |
| --- | --- | --- |
| Resize the main render target (and window fields) to the target size, render, read back | Yes, main case | One render, no tile seams. Limited by `GL_MAX_TEXTURE_SIZE` and VRAM |
| Render into a separate `TextureTarget` of the target size | Yes, but flagged | Oculus 1.8.0 writes its final pass into the vanilla main target, so this path is expected to fail with a shader pack (see `comparison.md`) |
| Tiled capture with a shifted projection (vanilla `grabHugeScreenshot`) | Yes, for sizes above the GPU limit | Seams in screen-space effects and TAA history across tiles are possible |
| Panorama / 360 / skybox | Secondary | Not "one big image"; reported when a candidate has it |
| CPU upscale of a smaller render | No | Adds no detail (bicubic); reported when a candidate has it |
| Render-scale supersampling (RenderScale) | No, baseline | Same file size as the window |
| In-world camera items, freecam, replay video render | No | Different function; read by description only |

## Market

Forge 1.20.1 mods (and resource/shader packs, none found) for big screenshots on Modrinth and CurseForge. Not a market of companies: no Company Dossier, `companies.csv`, retailer or price sources. The ledger is `products.csv` (author in the `company` column).

## Hard constraints (the project's)

- Forge build for Minecraft 1.20.1 (Forge 47.4.28). A Fabric, Quilt or NeoForge jar does not count.
- Shader path is Oculus 1.8.0 on Embeddium 0.3.31 (never Sodium or Iris). Distant Horizons 3.3.3 is installed. Five shader packs are installed (BSL 10.1, Complementary Reimagined r5.10, Mellow 3.5, I Like Vanilla 1.5.0b, Solas 3.9), all with `dh_*` programs.
- Client side only is expected. Side is read from the jar, not from the platform.

## Corrections to the brief

- RenderScale is not installed. `mods/` has no metafile for it; `refs/notes.md` lists RenderScale 2.0.0-beta.1 as a candidate of the 2025-11-25 optimization review (decision pending). It is treated as a baseline option here.
- No earlier comparison covers screenshots (`refs/comparisons/index.md` has no row). The statements in `refs/notes.md` that touch this topic are the Punchy! F8 key and the RenderScale candidate line.

## Baseline

"No mod" is a candidate: vanilla F2 (window-sized), a larger window, RenderScale 2.0 (not installed), a shader pack's own screenshot feature (none exists in the five installed packs, read from the zips), and offline stitching of overlapping F2 shots (not evaluated).

## Criteria (no weights, no tiers)

The result is a fact table plus a conditional recommendation.

1. Function: the source code or jar, not the description. Capture method, size limit, behavior when the limit is exceeded, shader and Distant Horizons behavior.
2. Future: release dates, repository activity, issue state, direction.
3. Download counts (project total and the 1.20.1 Forge file on Modrinth; CurseForge total where listed).
4. Forge 1.20.1 build, side, required dependencies.
5. Conflicts with installed mods: Mixin scan against all 136 installed jars (hard conflict = same `@Redirect` or `@ModifyConstant` call, or `@Overwrite` on a method another mod hooks) and default key bindings.
6. Settings the mod needs and where they would live.

## Open questions (Step 0, cannot be asked)

1. Target size and use: wallpaper (4K to 8K), print poster (8K to 16K and more), or "as large as possible"?
2. GPU model and VRAM, and monitor resolution. They set the practical ceiling (see the memory table in `comparison.md`).
3. Which shader pack is used for the shots (the five differ in buffers and temporal effects)?
4. Is a panorama (360) wanted as well?
5. Is the pack meant to ship the mod to every player (client-only, per-player setting) or is it for the user's own instance?

# Scope: Debug Keybind

Date: 2026-11-26. Research only; nothing was added, removed or updated, and nothing was run in the game.

## Question

The user wants to add Debug Keybind (Modrinth `debug-keybind`) to the ohm pack (Minecraft 1.20.1, Forge 47.4.28) and asked for the comparison and review first. The candidate file named in the request is `DebugKeybind-forge-9.1.1.jar`. The review has to say what the mod really does (which F3 combos and debug keys become rebindable), whether it is client-only, what it needs, how it fits the installed key-handling mods, and whether any shipped default is needed.

## Market and baseline

- Market: Forge 1.20.1 mods (and resource packs, shader packs: none apply) on Modrinth and CurseForge whose function is "change the keys of the F3 debug screen and its combos". Found by searching the function's terms (see `coverage_report.md`), not by crawling a category.
- Baseline (what covers the area now): nothing in `mods/`. The nearest installed mods are Key Binding Patch, Controlling, Mine Menu, Default Options and BetterF3 (see `refs/notes.md`, Key Binding Mods; `refs/list.md`). None of them rebinds F3 combos.
- "No mod" is a candidate: an operating-system or keyboard remap (Fn lock, a key remapper), which needs nothing in the pack.

## Hard constraints (the project's)

- A Forge build for Minecraft 1.20.1 (Forge 47.4.28). A Fabric or Quilt jar has no `mods.toml` and does not load.
- Side must be read from the jar, not from the platform's environment data.
- No shader pack is involved, so the Distant Horizons constraint does not apply.
- The user's standing rule: key clashes are a rebind, not a reason to exclude (2026-11-26).

## Criteria (no weights, no tiers: the caller gave none)

The result is a fact table plus a conditional recommendation. Facts compared per candidate:

1. Function: the author's description against the jar's classes and mixins.
2. Future: release activity, repository activity, issue handling.
3. Downloads on both platforms.
4. Forge 1.20.1 build: does the jar target 1.20.1, do its mixin targets and member references exist in the 1.20.1 / Forge 47.4.28 client, required dependencies.
5. Side, from the jar.
6. Conflicts with the installed mods: Mixin scan against the 138 installed jars, plus a behavior read for the mods that share a hooked class.
7. Shipped settings and where they would live.

## Questions Step 0 would ask (the researcher cannot ask; the caller decides)

- Which keys should players be able to move, and is the goal the laptop Fn row (F3 combos need Fn on many laptops)? The answer decides whether a shipped default makes sense (it does not, if the keys depend on the hardware).
- Does the pack want one jar fewer to manage (Debug Keybind 5.0.0 carries its library) or the newer 9.1.1 with a separate library?
- Is BetterF3's own set of combos (F3+F, F3+Ctrl+F, F3+M) expected to become rebindable too? Debug Keybind does not cover them.

## Evidence levels used

Measured (counts, dates, hashes), Measured by reading (mixin targets, config keys, zip and class contents, javap output), Claimed (an author's statement), inference (reasoned, not checked).

# Coverage report

Status: provisional. The convergence test of the comparison skill (3 snowball rounds, last round adds nothing, two reconciled third-party inventories) was not run. The result is a fact table for one candidate with a sample of alternatives.

## Candidates

- Researched in depth: Debug Keybind 9.1.1, Debug Keybind 5.0.0, BoxLib 11.3.2 (and BoxLib 9.0.0 inside 5.0.0).
- Listed, not read: Debug Keybind 9.1.0 and 1.1.0, XYZ Copy, Better Gamemode.
- Excluded with a reason: Thorough Keybindings, F3 CHANGER, RebindMyKeys, Rebind All The Keys (Fabric only), ReBind and Legacy Rebindable Keys (old Minecraft), no f3, DebugUtils, simpler keybinds (other function). See `products.csv`.
- "No mod" is included as a candidate (operating-system or keyboard remap); it was reasoned about and not tested.

## What was searched

- Modrinth search with the facets project type mod, category forge, version 1.20.1, 24 queries, one topic each: `f3 keybind`, `debug keys rebind`, `debug hotkeys`, `rebind f3`, `f3 shortcut`, `debug screen keys`, `chunk borders hotkey`, `hitboxes hotkey`, `F3`, `debug`, `debug menu`, `keybind`, `keybinds`, `hotkey`, `shortcut`, `f3 menu`, `function key`, `remap keys`, `laptop`, `rebind`, `remap`, `debug shortcut`, `keyboard`, `F3 combos`. Only Debug Keybind matched the function (a rebind of F3 combos) on Forge 1.20.1.
- Web search: 2 queries (listed in `sources.md`).
- CurseForge: the candidate's and the library's file lists through CFWidget, and the candidate page. CurseForge search itself was not run (no API key, the site blocks scripted search), so CurseForge-only mods are not enumerated.
- GitHub: both repositories, and issue searches in BetterF3, Key Binding Patch and Controlling for "debug keybind".

## What was not covered

- CurseForge-only candidates; Modrinth projects whose text does not contain the search words (the search is lexical).
- Fabric-only mods were listed from search results and Modrinth loader lists only; none was opened.
- The two partial-overlap mods (XYZ Copy, Better Gamemode) were read from their pages only.
- Nothing was run: no game, no server, no packwiz.
- Mods that read raw Forge key events, and the default keys of installed KeyMappings, were not scanned.

## Installed-mod scan

- 140 metafiles in `mods/` on 2026-11-26 (135 on `main` plus 5 untracked: improved-mobs, l2-complements, l2hostility, l2library, tenshilib). 138 jars downloaded and extracted; GT CRAFT and the Official Content Pack skipped (assets only, as in earlier comparisons). Every downloaded jar's hash equals its metafile.
- 104 classes carry the Mixin annotation and name one of the target classes anywhere in their constant pool; 47 of them (25 mods) target one of the nine classes (`data/installed_hooks_of_interest.tsv`, 58 injector rows). One nesting level of Jar-in-Jar was read.
- Names compared as written (Mojmap and SRG spellings are not matched). Mixins that a plugin disables at load are not known. A scan cannot see behavior, registries or world generation.

## Evidence levels

| Level | Where used |
| --- | --- |
| Measured | download counts, dates, hashes, issue counts, file lists |
| Measured by reading | mixin annotations, config fields, key defaults, `mods.toml`, class lists, member references, bytecode of vanilla and Forge classes |
| Claimed | the page text of Debug Keybind, Modrinth environment data, issue reports by third parties |
| inference | server behavior without the mod class guards, effect of the missing `hideGui` field in 5.0.0, F3+Q help interplay with BetterF3, error handling of the bare `/f3` command, `displayTest` behavior in the server list, Default Options timing |

# Third-party problem reports

Read on 2026-11-26 with the GitHub API. Full text of the ones quoted is in `data/gh_*.txt`. These are reports by others, not tests: evidence level Claimed.

## Boxadactle/DebugKeybind (21 issues, 8 open)

| Issue | State | Minecraft | What | Bearing on the pack |
| --- | --- | --- | --- | --- |
| 19 "boxlib not tagged as required?" | open, 2026-04-16 | 1.20.1 | The game stopped at first launch with an error screen about missing BoxLib; the reporter expected it to be downloaded | Real: Modrinth lists no dependency for 9.1.1 (measured). packwiz will not add BoxLib. Add `boxlib` by hand |
| 4 "set bind resets when starting minecraft/changing the world" | closed 2024-08-28 | not stated | Keys were lost when the screen was left with Esc instead of Done; the author (2024-08-18) said it would be fixed in the backports | The 1.20.x batch of 2024-08-20 (9.1.0) probably carries the fix (inference); 5.0.0 probably still has the bug |
| 9 "game crashes after i try to change binds" | closed 2025-04-27 | 1.21.4 | Crash when opening the screen; the author: a bug in the library mod, update it | A BoxLib bug of a newer line; BoxLib 11.3.2 is the last 1.20.1 build, whether it carries that bug is unknown |
| 8 "Compatability issues with too-many-shortcuts" | closed | 1.21.4 | The "Debug Keybinds..." button vanished on the Controls screen | Fixed in the other mod; no installed mod hooks `ControlsScreen` (scan) |
| 14 "require debug keybind keeps resetting to true" | open | newer line | A setting that exists only in newer versions; a media key toggled it | Not in 9.1.1 (no such field in `KeybindConfig`) |
| 12, 10 chunk border message twice / not shown | open | 1.21.4, 1.21.1 | Hard to reproduce, unconfirmed | Not on 1.20.1 |
| 16 "Weird error message" | open | unknown | The author: probably an old Java version | None |
| 18 mouse buttons | open | n/a | Feature request: side mouse buttons; the mod takes keyboard keys only | Limit of the mod |
| 20 hide the options menu | open | n/a | A modpack maker asked to hide the screen from players | Not possible; the screen stays |
| 21 rebind Toggle HUD (F1) | open, 2026-07-18 | not stated | A macOS user asked to rebind F1 (hide HUD) and found only Fabric mods | 9.1.1 has a Hide GUI key (read from the jar); the report names no version |

Closed and not relevant to 1.20.1: 17, 15, 11, 7, 6, 5, 3, 2, 1 (ports, an old crash with another mod, and a first-version display bug).

## Boxadactle/BoxLib (9 issues, 0 open)

| Issue | Bearing |
| --- | --- |
| 4 "Version downgraded?" (Forge 1.20.1, 2024-12-08) | BoxLib 10.4 was tagged 1.20.1 by mistake; the author: 10.4 is for 1.20 only, 11.3.2 is the right one for 1.20.1. Fixed in the tags (Modrinth lists 10.4.0 for 1.20 only now) |
| 2 "BoxLib 1.20.4 not working" | A Java 21 build against pre-1.20.6 Minecraft; not the 1.20.1 Forge build |
| 3 "Game fails to launch" (Fabric 1.20.1, 2024-07-26) | Closed with a newer version; Fabric |
| 9, 8, 7, 6, 5, 1 | Newer Minecraft versions, 1.16.1 and a maven outage |

## Other repositories

- TreyRuffy/BetterF3 issue 185, open, 2025-11-09: "Crashes if DebugKeybind mod rebinds f3 to specific keys". With BetterF3 16.0.3 on Fabric (Minecraft 1.21.x) and Debug Keybind, pressing the Debug key crashes when it is bound to a key that is also a combo key (B, V, E); not with BetterF3 removed. The log link (mclo.gs) has expired. The pack has BetterF3 7.0.2 on Forge 1.20.1; the code differs, so this is a warning and not a finding.
- jaredlll08/Controlling issue 237, open, 2026-07-11: "Do not show key bind duplicates from debug menu". It is about the debug keys that vanilla 26.x registers as KeyMappings and Controlling's conflict display; it does not apply to 1.20.1 or to Debug Keybind's own objects. Recorded because the search matched it.
- Key Binding Patch: no issue mentions Debug Keybind.

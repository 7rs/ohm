# Scope: Superb Warfare (Forge 1.20.1)

Date of research: 2026-11-24. Nothing was added. The decision is the user's.

## Question

The user asked whether `https://modrinth.com/mod/superb-warfare` can be added to the pack ohm (Minecraft 1.20.1, Forge 47.4.28).

## Comparison type

Fit review. The pack already has a gun system (TaCZ plus LR Tactical, both under Main Feature), so the comparison is Superb Warfare against the installed TaCZ ecosystem and against "no mod". A market enumeration of other gun or vehicle mods was not made.

## Criteria

| Criterion | Evidence level |
| --- | --- |
| Forge 1.20.1 build, release channel, date, downloads, side, dependencies (Modrinth API, 2026-11-24) | Measured |
| Loader, required libraries, bundled libraries (`mods.toml` and `META-INF/jarjar` of `superbwarfare-0.8.9.2-mc1.20.1-65d985a64-all.jar`) | Measured by reading |
| Mixin conflicts against 111 jars (the 91 installed mods, the 14 mods added the same day with their libraries): class, method, and for `@Redirect` and `@ModifyConstant` the same `@At` target (`refs/comparisons/content-additions/scripts/`) | Measured by reading; not run |
| Item tag overlap with installed mods (`forge:` and `c:` item tags in the jars) | Measured by reading |
| Reported problems (GitHub issue search of Mercurows/SuperbWarfare) | Claimed by third parties |

## What was not done

- Nothing was run in the game.
- All Japanese Translate (jtrans, CurseForge only) was not scanned.
- Config defaults were not read except where stated by the mod page.
- Alternatives (other gun or vehicle mods) were not enumerated.

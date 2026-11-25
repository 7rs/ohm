# Enhanced Boss Bars and the other boss bar mods (Forge 1.20.1)

Status: provisional. Research date: 2026-11-23. Nothing was run in the game; every behavior below comes from reading the jar and the platform pages.

Decision (2026-11-23, user): Enhanced Boss Bars was added to the pack.

## Headline

Enhanced Boss Bars is the fit. It is client-only, needs only Cloth Config (already installed at the required version), has one HUD mixin, and ships designs for The Aether and The Twilight Forest bosses, both installed. No other mod on Forge 1.20.1 comes close in downloads or per-boss designs.

## Fact table

| | Enhanced Boss Bars | Refined Bossbars | Boss Bar Begone |
| --- | --- | --- | --- |
| Downloads, Modrinth (all versions) | 2,145,812 | 4,731 | 708 |
| Downloads, Modrinth (Forge 1.20.1 files) | 1,984,290 (5 files) | 4,731 (2 files) | 9 (2 files) |
| Latest Forge 1.20.1 release | 1.1.3-1.20.1-forge, 2026-11-07 | 1.1, 2025-02-21 | 1.0.3, 2026-11-06 |
| Side (Modrinth) | client required, server unsupported | client required | client required |
| Dependencies | Cloth Config 11.1.136 or newer | none | none |
| What it does | Replaces boss bars with generic designed ones, per-boss designs, position and stacking | Restyles the vanilla bar (description: "a refined look") | Hides bars by name |

## Source, read (Enhanced Boss Bars jar 1.1.3-1.20.1-forge)

- `clientSideOnly = true`. Mixins (client, `defaultRequire = 1`): `BossHealthOverlayMixin` and `ClothConfigScreenMixin`. No network API references in the jar (byte scan).
- Config keys: `enhanced_boss_bars_enabled`, `override_all_boss_bars`, `horizontal_alignment`, `vertical_direction`, `position_x`, `position_y`, `scale`, `max_boss_bars`, plus a per-boss map. Default values were not read.
- Per the author's list (Claimed): designs for The Aether (Slider, Sun Spirit, Valkyrie Queen) and The Twilight Forest (Naga, Hydra, Ur-Ghast, Snow Queen, Alpha Yeti, Twilight Lich), and for Mowzie's Mobs, L_Ender's Cataclysm, Bosses of Mass Destruction, Cracker's Witherstorm and Alex's Mobs (not installed).
- Designs can be added with a resource pack that holds JSON files in a folder `enhanced_boss_bars`.
- The author says all vanilla bars are replaced by the generic ones, so bars from other mods are affected too.
- The linked repository is a 1.21.1 NeoForge repository (branch `master`). The 1.20.1 Forge code is not there, so only the jar was read.

## Observations for this pack

- Installed Cloth Config is `11.1.136+forge`, which meets the minimum exactly.
- It is `side = "client"`; the Modrinth listing agrees.
- Whether the main feature is on by default depends on `enhanced_boss_bars_enabled`; the default was not read, so it must be checked in the game after adding.

## Excluded

| Mod | Reason |
| --- | --- |
| Mini Boss Boss Bars, EEEAB's Mobs custom bossbars, Minibossbars, Bossbar Expansion | Add bars for mobs (gameplay), not restyle them |
| Souls Combat HUD, VitalBar | Larger HUD or mob health bars; different goal |
| Bossbar Timer, TabTPS | Timers and TPS display in a boss bar |

## Coverage

- Market from Modrinth only.
- Evidence levels: downloads and dates Measured, hooks and deps Measured by reading, bosses covered Claimed.

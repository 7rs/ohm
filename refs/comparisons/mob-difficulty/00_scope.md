# Scope: making enemies harder (2026-11-24)

Date of research: 2026-11-24. Nothing was added. The decision is the user's.

## Question

The user finds the pack too easy for its power level (TaCZ guns, Touhou Little Maid maids that use guns, Superb Warfare vehicles). They do not want gun damage lowered; they want enemies made stronger. After a first plan, they asked:

1. Gun enemies: TaCZ NPCs, or Simple Enemy Mod with TaCZ Combined Arms, not all of them?
2. Zombie Awareness: turn every feature on, already in the Overworld.
3. In Control!: is it built from our own config files?
4. Champions Unofficial and Enhanced Celestials: they want to add both. Is that safe?
5. Clanging Howl (CurseForge): is it a good fit?

## Comparison type

Fit review with light market enumeration per topic, like `content-additions/`. Every topic lists the alternatives found (Modrinth search with the facets Forge and 1.20.1, plus web search for CurseForge), but only the candidates the user named were read in depth. No weights or scores.

| Topic | Deep (jar, issues) | Light record only |
| --- | --- | --- |
| Elite mobs | Champions Unofficial | Infernal Mobs (CurseForge), Brutal Nightmare, ZG Mobs, Advanced Mobs, D2 Affix, Mob Dice Attributes, Summoner's Mod, Apotheosis, In Control! rules (no new concept) |
| Lunar events | Enhanced Celestials 1 and Enhanced Celestials 2 (Core, Default Lunar Events, Shader Support) | Lunar, Blood Moon (RRC Horde Nights), Bloodmoon Update (CurseForge), The Hordes, Undead Nights, Apocalypse addon; "no mod": Zombie Awareness `wanderingHordes` |
| Gun enemies | TaCZ NPCs, Simple Enemy Mod, TaCZ Combined Arms | TaCZ More Level, [TACZ] Biome Soldiers, Command Soldiers, Project TaCZ, Dochi's Warfare, CNPC TaCZ Fire, Gunfight NPCs |
| New hostile content | Clanging Howl | none (the user named one mod) |

## Criteria (all from the project rules)

| Criterion | Evidence |
| --- | --- |
| Forge 1.20.1 build, channel, date, downloads, declared dependencies | Modrinth API, CurseForge page (via fetch), fetched 2026-11-24 |
| Required dependencies and ranges | `mods.toml` and `MANIFEST.MF` of the downloaded jars |
| Mixin conflicts against the 124 installed jars | `../content-additions/scripts/scan.ts` and `conflicts3.ts`, plus `scripts/targets.ts` (same class and method) |
| TaCZ coupling | class references to `com/tacz/guns/...` checked against the TaCZ 1.1.8-hotfix2 jar (class level only, not members) |
| Function | jar data files, config spec strings, language files; Champions affix logic from its 1.20.1 branch source; Clanging Howl buff logic from its `master` source; TaCZ damage source from its `1.20.1` source |
| Reported problems | GitHub issues of each repository (all states, up to 200 per repository) |

## What was not done

- Nothing was run in the game or on a server. No TPS or FPS was measured.
- Installed jars: 112 from the local Prism instance plus 12 downloaded from the metafiles (the five vehicle mods that were being added in the working tree at the time are included).
- Enhanced Celestials 1 uses SRG method names in its mixins, while the scanner matches names as written, so its same-method overlaps are under-counted.
- Champions Unofficial 20.1.1.6 has no matching public source: the `1.20.1` branch stops at 2025-08 and has an older class layout. Affix behavior was read from that branch and checked against the strings in the 20.1.1.6 jar. Its default numbers were read from the constant pool and mapped by position (marked as inferred).
- TaCZ NPCs has no public repository; its defaults were read from strings in the jar.
- Clanging Howl's 116 CurseForge comments were not read.
- Infernal Mobs: a 1.20.1 Forge build is implied by an add-on page and a third-party listing; the file was not seen.

## Scripts

`scripts/dl.ps1` (Modrinth downloads), `scripts/gh-issues.ps1` (issue lists), `scripts/targets.ts` (same-method overlaps; run with Bun next to `fflate`). Jars and the raw issue list were kept in the session scratchpad only.

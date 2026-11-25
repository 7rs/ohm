# Scope: more difficulty (2026-11-25)

Date of research: 2026-11-25. Nothing was added. The decision is the user's.

## Question

The user wants to add a mod that raises the difficulty. On the first question they chose four directions at once (an "Other" answer added the fourth):

| Axis | Meaning |
| --- | --- |
| scaling | Time and progress scaling: enemies get stronger with days, player progress, dimension or area |
| survival | Survival load on the player: thirst, temperature, injury, bleeding, stamina, hunger and similar |
| content | High-difficulty content: new bosses, dungeons, dimensions |
| enemy | More kinds of enemies, "like Simple Enemy" (new factions, armed or organised enemies, hordes, variants) |

## What the pack already has (so it is not asked for again)

Added on 2026-11-24 (`refs/notes.md`, "enemy difficulty"): Simple Enemy and Combined Arms (armed Russian and American units), Enhanced Celestials 2 (blood moons), Clanging Howl (time-scaled techno-flesh), Zombie Awareness with hordes, Guard Villagers. Also installed: True Ending, End Remastered, Deeper and Darker, The Twilight Forest, The Aether, Iron's Spells 'n Spellbooks, Zombie Awareness with TACZ-Sound Attracts Zombies. On hold since 2026-11-24: Champions Unofficial, In Control!. Rejected: TaCZ NPCs (one gun-enemy system only), Wither Storm, Enhanced Celestials 1.

The pack's power sources that the difficulty has to answer: TaCZ guns and attachments, Touhou Little Maid maids with guns, Superb Warfare and Immersive Vehicles vehicles, Iron's Spells, Create, Mekanism, AE2. The user does not want gun damage lowered (`refs/comparisons/mob-difficulty/00_scope.md`).

## Comparison type

Fit review with light market enumeration, like `mob-difficulty/` and `content-additions/`. No weights or scores: the facts are listed per candidate and the result is a conditional recommendation per axis. The project rule applies: "no mod" (a config-only change to an installed mod) is a candidate on every axis, and nothing is added without the user's approval.

## Discovery (rounds)

Modrinth search with the facets project type mod, Minecraft 1.20.1 and Forge, 40 hits per query, sorted by relevance. One concept per query.

| Round | Queries | Unique projects | New projects |
| --- | --- | --- | --- |
| 1 | 65 (4 axes) | 1,257 | 1,257 |
| 2 | 80 | 1,211 | 1,033 |
| 3 | 60 | 903 | 662 |

Rounds 2 and 3 still brought new relevant mods (Mowzie's Mobs, Aquamirae, Born in Chaos, Goety, First Aid in round 2; Meet Your Fight, The Graveyard, Qliphoth Awakening, Threateningly Mobs, Mob AI Tweaks in round 3), so the convergence test of the comparison skill (a round with 0 new relevant mods) was not met. The candidate list is therefore not exhaustive. The list below is a sample taken by downloads, keywords and the user's context (see `coverage_report.md`).

CurseForge was checked only through web search (Infernal Mobs, Eldritch Mobs). CurseForge-only mods can be missing.

## Criteria (from the project rules)

| Criterion | Evidence level |
| --- | --- |
| Forge 1.20.1 build, channel, date, downloads, side, required dependencies (Modrinth API, 2026-11-25) | Measured |
| Required dependencies, mod ids and platform ranges (`mods.toml` of the downloaded jars) | Measured by reading |
| Maintenance: date of the newest Forge 1.20.1 file, channel, number of builds | Measured |
| Mixin conflicts against the 135 installed jars (same `@Redirect` or `@ModifyConstant` call, `@Overwrite`) | Measured by reading; not run |
| Fit with guns: how the mod treats TaCZ bullets (damage message id, indirect damage), read from the jar strings and data | Measured by reading |
| Overlap with installed mods (features, libraries, AttributeFix, Zombie Awareness, Simple Enemy, Clanging Howl) | Measured by reading |
| Reported problems (GitHub issues of finalists) | Claimed by third parties |

## Hard constraints

- A Forge build for Minecraft 1.20.1 must exist (project rule). Fabric-only jars are excluded.
- Libraries are installed only when a mod requires them (project rule).
- No lowering of gun damage (user, 2026-11-24).
- Only Distant Horizons compatible shader packs are in the pack (project rule): a candidate that changes rendering or sky is checked against that.

## Exclusions logged

- (a) Outside the category: total conversion mods Advent of Ascension and DivineRPG (they replace the whole game, not raise difficulty). Not downloaded.
- Mods above 140 MB were not downloaded (none of the finalists).
- (d) Hard constraint: Fabric-only builds (Eldritch Mobs); mods needing Fabric API.

## What was not done

- Nothing was run in the game or on a server. No TPS or FPS was measured (see `refs/issues.md`, General).
- CurseForge descriptions and comments were not read.
- Mixin scanning finds conflicts on the same method and hooked call. It does not find behavior conflicts (two mods changing the same mob, damage or spawn rule).
- Config defaults were read only where noted.
- The candidate list is a sample (see Discovery).

## Scripts

`scripts/` holds PowerShell and Bun scripts (`enum.ps1`, `enum2.ps1`, `enum3.ps1` with `terms3.json`, `fetch-cands.ps1`, `dl-cands.ps1`; the Bun scripts of `content-additions/scripts/` and `vehicles/scripts/` were reused unchanged). Jars were kept in the session scratchpad only.

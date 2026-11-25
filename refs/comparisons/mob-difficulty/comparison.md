# Making enemies harder (Forge 1.20.1)

Status: provisional. Research date: 2026-11-24. Nothing was run in the game. Scope and limits: `00_scope.md`. Candidates: `products.csv`. Sources: `sources.md`.

## Result

| Topic | Result |
| --- | --- |
| Gun enemies | Pick one line: TaCZ NPCs, or Simple Enemy Mod (with TaCZ Combined Arms as an optional add-on). No blocker in either. |
| Zombie Awareness | Only `wanderingHordes` is off among its gameplay features; everything else already runs from day 0 in every dimension. Two "off" switches should stay off. |
| In Control! | Rules are JSON files we write under `config/incontrol/`. It clashes with Champions on health (Champions issue 145). |
| Champions Unofficial | Can be added (no hard conflict), but four of its default affixes work directly against guns, and its maintainer advises against using it with True Ending (installed). Needs a shipped server config to be usable here. |
| Enhanced Celestials | Use Enhanced Celestials 2 (Core, Default Lunar Events, Shader Support), not Enhanced Celestials 1. No blocker. |
| Clanging Howl | Fits the goal (time-scaled enemies, infection pressure). Its damage resistance grows to 50 % against every weapon, removed by fire. No blocker. |

## Shared facts

- TaCZ 1.1.8-hotfix2 builds every hit as `new DamageSource(type, bullet, shooter)` (`ModDamageTypes.Sources.bullet`, source), so the direct entity is the bullet and `isIndirect()` is true. All four bullet damage types share the message id `tacz.bullet`. Each hit is split into `tacz:bullet` and `tacz:bullet_ignore_armor` (tag `bypasses_armor`) by the gun's `armor_ignore` (jar data).
- Mixin scan (124 installed jars): 0 hard conflicts and 0 `@Overwrite` pairs for every candidate and library below.
- TaCZ class references resolve against 1.1.8-hotfix2 for TaCZ NPCs (40), Simple Enemy (31) and Combined Arms (27). Members were not checked. TaCZ 1.2.0 (not installed) can break all three.

## Gun enemies

| Item | TaCZ NPCs 2.1.0 | Simple Enemy 0.1.6-beta-hotfix | TaCZ Combined Arms 0.1.7 |
| --- | --- | --- | --- |
| Downloads, date | 210,605, 2026-07-12, release | 49,651, 2026-09-14, beta | 30,668, 2026-10-25, release |
| Size, mixins | 84 KB, none | 1.3 MB, none | 19.6 MB, 77 targets (Xaero's World Map `GuiMap` for its order screen; `HumanoidModel.setupAnim` like TaCZ, Touhou Little Maid, Punchy! Moves, Superb Warfare) |
| Required (`mods.toml`) | Forge, Minecraft only (TaCZ is required on Modrinth but not declared) | TaCZ 1.1.4+. Optional: GeckoLib, Curios, Cloth Config (all installed) | Superb Warfare 0.8.9.1+ (pack 0.8.9.2), Simple Enemy 0.1.6-beta-hotfix+, TaCZ 1.1.4+ |
| What spawns | Replaces mobs in structures by chance: pillagers in outposts, pillagers and vindicators in mansions become "illager" gunners; villagers in the four village types become "villager" gunners (opposed to illagers and monsters). Also `/summon` with a template | Russian and American soldier factions, recruitable PMC allies (16 emeralds, item configurable). Timed events per player: patrol, faction battle, cave extraction; soldiers in villages (switch) | Simple Enemy units ride or spawn with Superb Warfare vehicles |
| AI | Player-like TaCZ shooting through TaCZ's operator API; melee fallback; alerts allies | Cover search, flanking, squads, suppression; budgets per tick to protect TPS (config) | Vehicle crews and orders |
| Config | JSON: factions, loadouts, structures; loot tables by data pack | Difficulty preset, accuracy, burst, drop chances, event chances and squad sizes, faction friendliness | Wiki |
| Source | none public | GitHub, 11 issues (10 open) | GitHub, 6 issues (1 open) |
| Reported | none (no tracker) | 2: world-bricking ticking entity with the mod Zero Contact (not installed). 12: Superb Warfare barbed wire is not seen as a hazard | 3: `ConcurrentModificationException` in Simple Enemy `VillageGarrisonHandler.onLevelTick` (closed). 2: `NoSuchFieldError` from a version mismatch (closed) |

- They are two separate NPC systems. Installing both doubles the AI and spawn logic with no gain, so it is one or the other.
- TaCZ NPCs puts guns on enemies that already exist (outposts, mansions) and arms villages on the player's side. Simple Enemy adds new factions and roaming events, which is the larger difficulty change, and its page states the goal "to balance the presence of weapons in the game". Its recruitable allies add player power again.
- Combined Arms is the only candidate that answers Superb Warfare vehicles with enemy vehicles. It is locked to Simple Enemy's version, and its past crashes came from version mismatches.

## Zombie Awareness 1.13.1 (installed)

Read from the instance's generated config files and the jar.

| File and key | Default | Note |
| --- | --- | --- |
| `Features.toml` `wanderingHordes` | `false` | The only gameplay feature that is off. Turning it on is the "everything on" step |
| `Features.toml` `awareness_Sound_OverworldOnly` | `false` | `false` already means every dimension. `true` would limit sound senses to the Overworld |
| `Features.toml` `soundAlertsForAllAttackingMobs`, `soundUseAlternateAlertNoise` | `false` | Sounds only |
| `General.toml` `omniscient` | `false` | Every enhanced mob always targets the closest player; the file marks it performance sensitive |
| `General.toml` `seeThroughWalls` | `false` | Skips the line-of-sight check; marked performance sensitive |
| `General.toml` `awareness_Light_OnlyZombies` | `true` | `false` lets non-zombies follow light too |
| `General.toml` `daysBeforeFeaturesActivate` | `0` | Already active from the first day |
| `General.toml` `blockBreakEvent_PlayersOnly` | `false` | Machines already make sound senses (Create, Mekanism) |
| `MobLists.toml` `enhancedMobs` | 7 vanilla mobs | `enhanceableMobs` lists about 130 candidates, including Aether, Twilight Forest, Deeper and Darker, Iron's Spells and the Touhou Little Maid fairy |

- `ZAConfigSpawning` (extra spawning) exists in the jar but no class references it, so 1.13.1 has no extra-spawning setting.
- TACZ-Sound Attracts Zombies (installed) already makes gunfire a sound sense.

## In Control! 9.5.1 (not installed)

- Rule files under `config/incontrol/` (names from the jar): `spawn.json`, `spawner.json`, `summonaid.json`, `phases.json`, `loot.json`, `experience.json`, `effects.json`, `events.json`, `breakevents.json`, `placeevents.json`, `leftclicks.json`, `rightclicks.json`, `areas.json`. Gameplay rules, so they would be enforced (`config/`).
- Champions issue 145 (open, 2026-05-13): health set by In Control applies to normal mobs and Infernal Mobs, but champions spawn below their maximum health. The Champions maintainer: use Champions' built-in data pack for attributes, or turn In Control off.

## Champions Unofficial 20.1.1.6

| Item | Value | Evidence |
| --- | --- | --- |
| Build | 20.1.1.6-forge, release, 2026-09-06; 593 KB; 100,428 downloads, 42 followers | Modrinth API |
| Dependencies | Architectury API (9.2.14 for 1.20.1; not installed). Its `mods.toml` uses the NeoForge layout (`[[mods.dependencies.champions]]`, `type = "required"`, mod id `neoforge`), which Forge 47 does not read, so Forge does not check them (inference). Mixins are declared in `MANIFEST.MF` and load | jar |
| Mixins | 1 (`Minecraft.pickBlock`, client), shared with AE2 and Platform | scan |
| Who becomes a champion | Tag `champions:allow_champions`: 37 vanilla hostile mobs, including `ender_dragon` and `wither`. No modded mob by default (issue 80) | jar data |
| Spawn chance | 0.1 (inferred: first double in the spec) | jar constant pool |
| Affixes | adaptable, arctic, dampening, desecrating, enkindling, hasty, infested, knocking, lively, magnetic, molten, paralyzing, plagued, reflective, shielding, wounding | jar classes |
| Config | Server config (issue 94 calls it `champions-server.toml`). Issue 92 (open): it writes to `defaultconfigs/` when a world is made | GitHub |

Affixes against guns (logic from the `1.20.1` branch, config text from the 20.1.1.6 jar):

| Affix | What it does | Effect on TaCZ | Default (inferred) |
| --- | --- | --- | --- |
| adaptable | Each consecutive hit with the same damage message id adds reduction, up to a cap | Every bullet is `tacz.bullet`, and each hit is two damage events, so automatic fire reaches the cap within a few shots | +0.15 per hit, cap 0.9 |
| dampening | Reduces damage when `source.isIndirect()` ("direct melee/projectile damage" in the 20.1.1.6 text) | TaCZ bullets are indirect, so every shot is reduced | 0.3 base, scales with strength, hard cap 90 % |
| shielding | Every 40 ticks, a chance to raise a shield that blocks all damage except void | Bullets do nothing while it is up | 0.4 (inferred) |
| reflective | Returns part of the damage to the attacker | Rapid fire returns damage many times | up to 0.35, capped |

The archetype `modded_mob` puts adaptable, shielding and reflective in tiers 3 and 4, dampening from tier 1. The archetype `boss_line` gains +25 % attack below half health.

Reported (GitHub, 50 issues, 12 open):

- 72 (closed): with True Ending, a champion Ender Dragon spawns below its maximum health. True Ending sets the dragon's health to 300 by functions and does not support health above 1024. The maintainer: "i don't recommend champions and true end mod install together".
- 145 (open): In Control health (above).
- 65 (closed): a 5-affix vindicator hit for 360 damage; tune with `growthFactor` or the attribute data pack.
- 96 (open): attribute operations are always applied as `MULTIPLY_TOTAL`. 94 (open): the `[growth]` section has no effect on Forge 1.20.1. 146 (open): relogging sometimes gives mobs champion ranks. 89 (open): a freeze, cause unknown. 149 (open): Wounding ignores Protection.

What it would need here:

1. A server config with `dampeningReduction`, `adaptableMaxReduction` and `shieldingChance` set to 0 (or low) and `reflectiveMax` lowered, shipped through a `defaultconfigs/` folder, which the pack does not have yet (a structure change; issue 92 makes the exact path uncertain).
2. A decision on the Ender Dragon and Wither: removing them needs a data pack that replaces `champions:allow_champions`. The pack has no way to ship a global data pack today (True Ending is a data pack wrapped as a mod; the same trick, or a global data pack mod, would be needed).
3. No In Control health rules on the mobs that can become champions.

## Enhanced Celestials

| Item | Enhanced Celestials 1 (5.0.3.3) | Enhanced Celestials 2 (Core 1.0.3.4 + Default Lunar Events 1.0.0.7 + Shader Support 1.0.0.5) |
| --- | --- | --- |
| Date, downloads | 2026-08-07, 2,559,118 | 2026-11-05 (all three), 91,127 / 82,032 / 69,581 |
| Dependencies | Data Anchor 1.0.0.13+, CorgiLib 4.0.3.2+ | Data Anchor 1.0.0.24+, CorgiLib 4.0.3.5+; Shader Support also needs Oculus and Embeddium (installed) and is client-only |
| Blood moon | chance 0.1 per night, at least 4 nights apart; monster spawn cap ×2.25; surface spawning forced; sleeping blocked; no mob effects | the same multiplier, surface spawning and sleep block, plus village siege probability 0.5 and a monster spawn distance of 64; built from separate modifier files |
| Super blood moon | chance 0.05, full moon only, 20 nights apart; ×4.5 | same idea, modular |
| Shaders | Red tint does not show with BSL or Complementary (issue 214; the author: no API) | Shader Support draws the tint through the Iris API in Oculus (`LunarTintOverlay`, a plain inject into `LevelRenderer.renderLevel`) |
| Nag screen | Shows "Enhanced Celestials 2 is here!" on every world join; "Dismiss" hides it until the next join (`EC2AnnouncementScreen`); issue 265: no way to turn it off | none |
| Mixins | 24 targets incl. `NaturalSpawner`, `LightTexture`, sky | 19 targets incl. `NaturalSpawner` (`isValidPositionForMob` like Botania), `LevelRenderer.renderSky` (like Botania and Oculus), `LightTexture.updateLightTexture` (like Distant Horizons, Kerria, Oculus, Vanilla Backport, Superb Warfare), `Mob.finalizeSpawn` (like Let Me Despawn and Vanilla Backport) |

- Enhanced Celestials 1 and 2 must not be installed together (two event schedulers). Enhanced Celestials 2's own page calls it the rewrite; the first mod advertises it.
- Reported (182 issues, 7 open): Botania crash with Mekanism (198, fixed in Botania); Create 6.0.2 contraption crash (233, fixed by updating Data Anchor); Data Anchor 1.0.0.21 broke worlds (252, fixed 2026-03); hostile spawns stayed lower after removing the mod from a server (242). Open 258: on the Fabric 1.21.1 port of Touhou Little Maid, natural fairy spawns stop; Forge 1.20.1 was not reported or tested. The fairy is the pack's source of power points.
- The blood moon is mostly more spawns, as its author confirms (issue 237); the size of the effect depends on the spawn cap and on Let Me Despawn.

## Clanging Howl 1.1.0

| Item | Value | Evidence |
| --- | --- | --- |
| Build | `clanging-howl-[Forge]_1.20.1_1.1.0.jar`, release, 2026-05-31, 5.4 MB; 524,783 downloads; Forge 1.20.1 only; last commit 2026-06-01 (Polarice3, mongoose_artist) | CurseForge page, GitHub |
| Required | GeckoLib, Curios (both installed). JEI optional | `mods.toml` |
| Mixins | 14 targets: `FogRenderer` (like Distant Horizons, Chloride, Oculus), `LevelRenderer.renderSky` (like Botania, Oculus), `LightTexture` (like DH, Kerria, Oculus, Vanilla Backport, Superb Warfare), `GameRenderer.getNightVisionScale` (like Oculus), `ServerLevel` (like Harium, Immersive Optimization, ModernFix, Leaves Be Gone), `Entity.getTeamColor` (like Iron's Spells) | scan |
| Content | Techno-flesh mobs that infect animals, villagers, illagers and zombies; 6 of 8 can spawn only from day 15; meteor showers every 15 days for 180 s that block sleeping; cold-biome structures with a respawning nest; energy tools (drill, chainsaw, chainsword, flamethrower) | page, config text |
| Scaling | From each full day, stats ×(1 + 0.005 × days), capped at ×6 (day 1000); damage resistance of days ÷ 2 percent, capped at 50 % (day 100). The resistance applies to every damage type except `bypasses_resistance` and is off while the mob burns | `MobUtil.buffTechnoFlesh`, `CHEvents` (source) |
| Config | `TechnoFleshBuff`, `TechnoFleshBuffDayTime`, `FixedAdaptationStage`, `MeteorShower` and its interval and length, camera shake, per-mob spawn weight, group size and first day (`-1` disables) | jar |
| Reported | 13 issues, 7 open: 12 night-vision goggles flicker (and crash with BlockShot, not installed); 8 the drill and Waystones under a custom tier data pack; 6 log spam from the drill; 4 and 5 drill behavior with two other mods | GitHub |

- The 50 % resistance hits guns and every other weapon alike, but it is a cap reached at day 100 and fire removes it; Clanging Howl's own flamethrower and fire spells from Iron's Spells are counters.
- Meteor showers and blood moons both block sleeping; with both, more nights cannot be skipped.
- Infection of villagers can empty villages, which also affects Touhou Little Maid fairies' surroundings and TaCZ NPCs' armed villagers if those are added. Not tested.

## Decision (2026-11-24, user)

Added: Simple Enemy and Combined Arms, Enhanced Celestials 2 (Core, Default Lunar Events, Shader Support) with CorgiLib and Data Anchor, Clanging Howl. Zombie Awareness: `wanderingHordes = true`, `awareness_Light_OnlyZombies = false`. On hold: Champions Unofficial, In Control!. Not added: TaCZ NPCs, Enhanced Celestials 1. Later the same day: Zombie Awareness `enhancedMobs` gained spiders and illagers, and Guard Villagers 1.6.19 was added with Simple Enemy's village garrison switched off (`config/sem-common.toml`, `general_settings.enableVillageGarrison = false`).

## Village defense: Guard Villagers (reviewed after the decision)

| Item | Value | Evidence |
| --- | --- | --- |
| Build | 1.6.19, release, 2026-08-23, 205 KB; Modrinth 13,981,950 downloads, CurseForge 94,612,045; CurseForge has no newer 1.20.1 Forge file | Modrinth API, CurseForge page |
| Dependencies | none (Forge 46+, Minecraft 1.20 to 1.20.1) | `mods.toml` |
| Side | client and server required on Modrinth; the jar has no client-only flag | Modrinth API, jar |
| Mixins | 5 targets: `VillagerModel`, `VillagerGoalPackages` (core, meet, idle), `DefendVillageTargetGoal.canUse`, `Villager` save data (same methods as Superb Warfare), `SinglePoolElement.place` (same method as Waystones). 0 hard conflicts against the 132 jars after this batch | scan |
| Maintenance | 251 issues, 0 open; repository pushed 2026-10-05 | GitHub |
| Function | Guards spawn in villages in groups of six with an iron sword or a crossbow; nitwits and unemployed villagers become guards with a sword or crossbow; guards can be given armor, shields and food; with Hero of the Village they follow the player; clerics heal and smiths repair golems; witches attack villagers (configurable) | Modrinth page |

Fit with what is installed now:

- Simple Enemy's village garrison is on by default (`enableVillageGarrison = true`, `ruUnitsFriendly = false`, `usUnitsFriendly = false`, read from its `main` branch source). The first time any villager joins a world (generation, loading after install, breeding, curing), it queues a squad: after 100 ticks, if no Simple Enemy unit is within 40 blocks, 2 to 4 Russian or American soldiers (random) spawn near it. Units extend `Monster`, so iron golems and Guard Villagers' guards treat them as enemies. With Guard Villagers, every village would start with guards (swords and crossbows) fighting a hostile TaCZ squad.
- Threats to villages already in the pack: blood moon village sieges (Enhanced Celestials 2, probability 0.5), Zombie Awareness hordes, Clanging Howl infection, Simple Enemy garrisons. Guards help against the first three.
- Guards add player power too (following guards with Hero of the Village), like the maids.
- Reported (closed): 314 a 1.20.1 `ConcurrentModificationException` in `GoalSelector` on a zombie, which the author traced to other AI mods (the report listed Enhanced AI, Zombie Awareness and others); 278 a crash with Enhanced AI (not installed); 301 a `RepairGolem` crash in 1.6.17 with a test fix; 305 a 1.20.1 lag report the author attributed to vanilla. None open.

Alternatives (light): no mod (iron golems); Simple Enemy itself with `usUnitsFriendly = true` or `ruUnitsFriendly = true` (that faction's village garrisons and events become allies with TaCZ guns, the other stays hostile); Villager Recruits (469,413 downloads, player-commanded armies, more player power); Knights and Castles (28,794); Customizable Guards (1,090, last 2024-04); Guard Villagers Automatic Guard Conversion (6,320, an add-on).

Result: it can be added (no blocker). The decision that matters first is Simple Enemy's village garrison: keep it (villages are contested, and guards would fight it), turn it off (guards defend against mobs only), or make one faction friendly instead of adding guards.

Friendly faction plus guards (checked after the user asked, `main` source): a friendly faction still fights in villages. Its units keep an iron-golem target goal that sits outside the friendly check (`USunitEntity` priority 4, `RUunitEntity` priority 3), golems target every `Enemy` mob, and Guard Villagers' guards attack all hostiles by default (`AttackAllMobs`). Guard Villagers' `MobBlackList` can make guards ignore `simpleenemymod:usunit`; no config stops units and golems. Half of the garrisons (the other faction) stay hostile.

## What the user has to decide (before the decision above)

1. Gun enemies: TaCZ NPCs (armed outposts and villages, light) or Simple Enemy (new factions and events, beta), and whether Combined Arms joins Simple Enemy.
2. Zombie Awareness: `wanderingHordes = true`, and whether to switch `awareness_Light_OnlyZombies` to `false` and extend `enhancedMobs`.
3. Champions: whether to accept the shipped-config work (anti-gun affixes, the dragon with True Ending) or drop it. If kept, In Control is limited to non-health rules on vanilla hostiles.
4. Enhanced Celestials 2 instead of 1.
5. Clanging Howl: as is, or with `TechnoFleshBuff` or the meteor shower changed.

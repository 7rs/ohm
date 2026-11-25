# Raising the difficulty (Forge 1.20.1)

Status: provisional. Research date: 2026-11-25. Nothing was run in the game. The candidate list is a sample, not exhaustive (the convergence test of the comparison skill was not met; see `coverage_report.md`). Scope and limits: `00_scope.md`. Ledger: `products.csv` (121 rows, 17 finalists, 7 exclusions). Sources: `sources.md`.

## Result

| Axis | Best fit found | Why | Main risk | Alternative |
| --- | --- | --- | --- | --- |
| Time and progress scaling | L2Hostility 2.5.19 | Only candidate whose level follows the player's kills, dimension, biome and distance, and drops after deaths; ships entity configs for installed The Twilight Forest and for Cataclysm, Mowzie's Mobs and Ice and Fire; replaces the on-hold Champions | Its traits from level 100 work against bullets (Adaptive, Reflect, Repelling, Dementor); the numbers are data files | Improved Mobs 1.13.7 (time based, stats only, no traits) |
| Survival load | Cold Sweat 2.4.5 plus one thirst mod (Thirst Was Reclaimed 3.0.5, or Homeostatic if thirst and temperature should be one mod) | Mature, active, no dependency (Cold Sweat) | Not tested with Weather Refined, shaders or Distant Horizons | TaCZ Bleeding 1.7 as the light gun-linked injury; First Aid only with the TaCZ add-on |
| High-difficulty content | L_Ender's Cataclysm 3.31 | Largest boss and dungeon mod (19.6 M downloads, release 2026-06); L2Hostility ships level configs for its mobs | 70.5 MB, new structures and bosses, Distant Horizons and shader behavior not collected | Mowzie's Mobs 1.8.2 (34 MB, GeckoLib only), Legendary Monsters 2.2.4 (43 MB, server side optional) |
| More enemy kinds, "like Simple Enemy" | No Mindless Shooting 2.3.0 (gunfire builds noise and spawns mobs) | Makes the pack's own power source (TaCZ guns) cost something; 0 hard conflicts; 10 of 10 TaCZ class references resolve | Small mod (22.8 k downloads, one author); config format not read | Mutant Monsters 8.0.8 and Illager Invasion 8.0.7 (no new library: Puzzles Lib is installed) |

"No mod" baseline: Clanging Howl, Enhanced Celestials 2, Zombie Awareness and Simple Enemy already have difficulty settings (see `refs/settings.md`); turning those up costs no new mod. Not measured whether the pack is still too easy after the 2026-11-24 additions, since nothing was run.

## Shared facts

- Installed jars scanned: 135 (112 from the Prism instance, 22 downloaded from metafiles, Clanging Howl from the CurseForge CDN). Candidate jars: 119. Libraries pulled by Modrinth and `mods.toml` requirements: 45.
- Mixin scan (same `@Redirect` or `@ModifyConstant` call, or `@Overwrite`, as in the earlier comparisons): 0 hard conflicts for all 119 candidates and all 45 libraries. Two overwrite pairs: Block Factory's Bosses (BossesRise) and AllTheLeaks both overwrite `GeoModel.applyMolangQueries`; Marium's Soulslike Weaponry injects into `KeyMapping.m_90837_`, which Key Binding Patch overwrites. Neither is a finalist. Raw output: `mixin_conflicts.txt`, shared-method counts: `mixin_shared.txt`.
- Fabric-only jars in Forge listings (excluded under rule (d)): Custom Entity Attributes, Mob AI Tweaks, Mebahel's Zombie Horde, Mebahel's Dwarven Automatons, Eldritch End. Data packs wrapped as mods (no `[[mods]]` entry): Brutal Nightmare, Hostile Mobs Improve Over Time, Chaos Core, Harder Difficulty, Incendium, Ultris.
- TaCZ bullets are indirect damage with one message id (`refs/comparisons/mob-difficulty/comparison.md`, Shared facts). Anything that reduces indirect, projectile or physical damage works against guns.
- Libraries already installed that candidates need: Curios, Patchouli, GeckoLib, Puzzles Lib, Cloth Config, AttributeFix. Not installed and needed by finalists: L2 Library and L2 Complements (L2Hostility), TenshiLib (Improved Mobs), Majrusz Library (Majrusz), GlitchCore (Tough As Nails, beta), WhiteNoise (Homeostatic), Lionfish API (Cataclysm).
- The pack has no channel for a global data pack (`refs/notes.md`, Champions entry). Settings that live in data files, not in a Forge config, cannot be shipped without a wrapped data pack (True Ending is one).

## Axis 1: time and progress scaling

| Item | L2Hostility 2.5.19 | Improved Mobs 1.13.7 | Majrusz's Progressive Difficulty 1.9.10 | Hostile Mobs Improve Over Time 1.9.1 | Scaling Health 8.0.2 | Dungeon Difficulty 3.8.0 |
| --- | --- | --- | --- | --- | --- | --- |
| Release, date | release, 2026-03-26 | release, 2026-06-19 | release, 2024-04-26 | release, 2024-08-06 | release, 2025-04-05 | release, 2026-09-13 |
| Downloads | 2,949,512 | 654,845 | 1,137,789 | 238,126 | 404,165 | 792,531 |
| Needs (not installed) | L2 Library 2.5.7, L2 Complements 2.6.1 | TenshiLib 1.7.6 (2024-04) | Majrusz Library 7.0.8 (2024-04) | none (data pack wrapper) | Silent Lib 8.0.0 (2023-06) | none |
| What scales | Mob level from player difficulty (kills, deaths), dimension, biome, distance, chunk; traits unlock by level | Difficulty value rises with time; attributes, equipment, ladders, block breaking, stealing | Three stages: Normal, Expert (first player enters the Nether), Master (Ender Dragon dead); Undead Army raid | Per-player score rises every 20 minutes; 100 function files per mob | Per-player difficulty rises with time; player health too | Location (dimension, biome, structure) difficulty plus loot scaling |
| Adds player power | 28 curios and 2 enchantments (earned from trait drops) | Mobs steal items | Treasure bags | none | Heart crystals | Scaled loot |
| Maintenance | Active, 31 issues listed, 9 open | Active, 21 open of 196 listed | 54 open of 160 listed, several 1.20.1 crashes (265, 270, 273) | Last build 2024-08 | Author says it is no longer maintained | 6 open of 45 listed, two 1.20.1 (36 server freeze, 24 Lodestone crash) |
| Mixins, shared hooks, hard conflicts | 13, 4, 0 | 21, 3, 0 | 8, 0, 0 | 0, 0, 0 | 0, 0, 0 | 12, 0, 0 |

L2Hostility (jar read):

- Difficulty comes from `LHConfig$Common` and data files. Common keys (names from the jar): `killsPerLevel`, `maxPlayerLevel`, `maxMobLevel`, `playerDeathDecay`, `healthFactor`, `damageFactor`, `dimensionFactor`, `distanceFactor`, `globalApplyChance`, `globalTraitChance`, `allowLegendary`, `allowSectionDifficulty`, and one block per trait (`adaptFactor`, `reflectFactor`, `dementorDamageFactor`, `dementorDamageReductionBase`, `teleportRange`, `repellRange`, `repellStrength` and more). Defaults of these keys were not read.
- Base levels (data `difficulty/*.json`): Overworld biomes 5 to 50 (35 entries, biome scale 0 to 0.5; dimension base 0, scale 1, variation 4); Nether base 20, scale 1.2, variation 9; End base 40, scale 1.5, variation 16. These are starting points; the player's own level (kills) is added on top.
- Trait unlock levels (from `l2hostility_config/trait/*.json`): level 20: Cursed, Fiery, Poison, Slowness, Tank, Wither. 40: Blinder, Distorter, Weakener. 50: Freezing, Invisible, Levitater, Protected, Regenerating, Speedy, Arena. 60: Counter Strike. 70: Shulker, Soul Burner. 80: Gravity, Moonwalk. 100: Adaptive, Drain, Grenade, Growth, Pulling, Reflect, Repelling, Reprint. 120: Split. 150: Dementor, Dispell, Teleport, Undying. 200: Corrosion, Erosion, Master. 300: Killer Aura. 600: Ragnarok.
- Against guns: Adaptive (stacks reduction per damage type taken), Reflect (reflects direct physical damage as magic), Repelling ("immune to projectiles", pushes away), Dementor ("resistant to physical damage, damage bypasses armor"), Teleport ("avoid physical damage") and Undying (back to full health on death) from level 100 to 150. These are the same kind of effects as Champions' anti-gun affixes. The values are in data files (`min_level`, `weight`, `cost`) and in the Common config (factors).
- Which mobs are leveled: the default whitelist and blacklist tags are empty; the mod's own text says it applies to enemies, so (inference) every `Enemy` mob including Simple Enemy units and Clanging Howl techno-flesh would get levels. Not verified.
- It carries `l2damagetracker`, `l2modularblock` and `mob_weapon_api` as Jar-in-Jar. L2 Library hooks `LocalPlayer.aiStep` through `@WrapOperation`, the same method TaCZ wraps (shared, not exclusive).
- Entity data for other mods is inside the jar (`l2hostility_config/entity`, counted from the file list): Cataclysm 18 entities, The Twilight Forest 8 (installed), Ice and Fire 5, Bosses of Mass Destruction 4, Mowzie's Mobs 3, Mutant Monsters 1. Iron's Spells, The Aether, Deeper and Darker, TaCZ and Simple Enemy have none, so their mobs use the generic rules (inference).
- Champions Unofficial (on hold) and L2Hostility do the same job (elite mobs with affixes or traits); the L2Hostility page itself names Champions as the similar mod. Install at most one.

Improved Mobs (jar and page read):

- Scales stats (damage, health, speed, knockback resistance) with a time-based difficulty; equips all hostile mobs with enchanted gear from any mod; lets them break blocks, climb ladders, steal from chests. Mostly server side; the client only shows a difficulty meter.
- No effect specific to guns. Closed feature request 296 (2026-08) asked for TaCZ compat (flying-player chasing, skeleton weapons); no answer read.
- Open issue 326: difficulty increase speed wrong on a server; 354: deadlock while saving.
- `Mob.finalizeSpawn` and `read/addAdditionalSaveData` are also hooked by Enhanced Celestials 2 Core, Vanilla Backport, Almanac and Let Me Despawn (plain injects).
- It adds mob goals like Zombie Awareness does; Guard Villagers issue 314 (closed) shows goal-selector clashes between AI mods on 1.20.1. Not tested together.

Other findings: Hostile Mobs Improve Over Time and Brutal Nightmare are data packs wrapped as mods (functions and scoreboards; no config file; settings through `/function`). Scaling Health is unmaintained. Majrusz's Progressive Difficulty is the only candidate whose stages follow vanilla milestones, but its last build is 2024-04 and its tracker lists 1.20.1 crashes. Dungeon Difficulty also adds scaled loot (more player power). Threateningly Mobs adds biomes and a dimension and warns against existing saves.

## Axis 2: survival load

| Item | Cold Sweat 2.4.5 | Tough As Nails 9.2.0.171 | Homeostatic 2.9.16.2 | Thirst Was Reclaimed 3.0.5 | Thirst Was Taken 1.4.0 | Legendary Survival Overhaul 2.4.7 | First Aid 1.1 | TaCZ Bleeding 1.7 |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| Function | Temperature, armor insulation, blocks | Thirst and temperature | Temperature and thirst | Thirst | Thirst | Temperature, thirst, limbs, hearts | 8 body-part health bars, no natural regeneration | Light and heavy bleeding, bandages, tourniquet, salve (jar language file) |
| Channel, date | release, 2026-11-01 | beta, 2024-10-16 | release, 2025-11-16 | release, 2026-09-10 | release, 2025-06-17 | release, 2026-08-09 | release, 2024-07-14 | release, 2026-11-18 |
| Downloads | 1,206,248 | 2,228,584 | 331,518 | 55,325 | 1,055,976 | 141,369 | 675,965 | 62,970 |
| Needs (not installed) | none | GlitchCore 0.0.1.1 (beta) | WhiteNoise | none | none | none | none | none |
| Open issues (listed) | 6 of 190 | 66 of 152 | 25 of 113 | 3 of 45 | 140 of 189 | 28 of 33 | 98 of 181 | no repository |
| Mixins, shared hooks, hard conflicts | 44, 10, 0 | 12, 3, 0 | 5, 1, 0 | 34, 2, 0 | 33, 2, 0 | 0, 0, 0 | 0, 0, 0 | 0, 0, 0 |
| TaCZ link | none | none (issue 897 is a load error report, not TaCZ related) | none | none | none | none | needs an add-on for hit locations | no class reference (generic) |

- Cold Sweat is the only temperature mod with a current release, no dependency and a short open-issue list. Its shared hooks (`LivingEntity.canFreeze`, `HumanoidModel.setupAnim`, `ItemInHandLayer.renderArmWithItem`, `GameRenderer.renderLevel`) are plain injects also used by Aether, Superb Warfare, Punchy! Moves and TaCZ.
- Tough As Nails and Cold Sweat both do temperature; do not install both. Tough As Nails' newest 1.20.1 file is a beta from 2024-10 and needs GlitchCore (beta).
- Thirst Was Taken and Thirst Was Reclaimed share the mod id `thirst`: install one. Reclaimed has the newer release (2026-09) and 3 open issues; it has far fewer downloads (55 k against 1.06 M). Thirst Was Taken has 140 open issues, including Create crashes (190, 193, 200, 207) and a Cold Sweat compatibility issue (267).
- First Aid replaces the health bar and turns vanilla natural regeneration off; its own page says the game rule stays off even after removing the mod. Its single 1.20.1 build is from 2024-07 with 98 open issues. TaCZ First Aid Compat 1.0.0 (55 k downloads, 2026-01-22, 4 TaCZ class references, all resolve in 1.1.8-hotfix2 and 1.2.0-hotfix) maps the TaCZ hit location to a body part. Its newer sibling "First Aid New Compat" 1.0.4 has 52 downloads.
- TaCZ Bleeding 1.7: the jar has Light and Heavy Bleeding effects, Dirty and Sterile Bandage, Tourniquet and Medical Salve. The Modrinth page text says "any physical damage has a 5 % chance to cause bleeding for 10 seconds", which may describe an older build (a web snippet says 1.6 split light and heavy bleeding). It has no class reference to TaCZ, so a TaCZ update cannot break it, and (by the page text) it is not gun-specific: any physical damage counts. Its source is not public.
- Stamina: Peak Stamina overlaps ParCool's stamina (installed). Vantage TaCZ Compat 2.0.0 (793 downloads, beta) is a whole system (weight, injuries, stamina, AI enemies) built for another pack; not a fit.
- Not recommended here: Legendary Survival Overhaul (28 of 33 issues open), Hardcore Survival (alpha), IguanaTweaks Reborn (123 mixin classes, 13 shared hooks, a whole gameplay overhaul), Sanity (last build 2023), Project Atmosphere (overlaps Weather Refined and shader clouds), season mods (not difficulty by themselves).

## Axis 3: high-difficulty content

| Item | Cataclysm 3.31 | Mowzie's Mobs 1.8.2 | Legendary Monsters 2.2.4 | Mutant Monsters 8.0.8 | Illager Invasion 8.0.7 |
| --- | --- | --- | --- | --- | --- |
| Date, downloads | 2026-06-14, 19.6 M | 2026-04-02, 9.0 M | 2026-10-23, 8.4 M | 2025-11-17, 5.3 M | 2025-02-14, 8.4 M |
| Size, needs (not installed) | 70.5 MB, Lionfish API 3.0 | 34.4 MB, none (GeckoLib installed) | 42.9 MB, none | 1.3 MB, none (Puzzles Lib installed) | 2.2 MB, none |
| Side | both required | both required | optional on both | both required | both required |
| Mixins, shared hooks, hard conflicts | 25, 3, 0 | 1, 0, 0 | 7, 0, 0 | 2, 0, 0 | 8, 0, 0 |
| Reported | repository not readable (403) | repository path 404 | no repository listed | 58 open of 125 listed; shader issues 124 and 129 (Endersoul) | 45 open of 117 listed |

- Cataclysm: "difficult dungeons, challenging boss fights". Shared hooks: `ItemEntity.hurt` (AE2), `HumanoidArmorLayer.renderArmorPiece` (Create, Oculus), `HumanoidModel.pose*Arm` (Vanilla Backport, Punchy! Moves); all plain injects. L2Hostility carries 18 entity configs for it.
- The pack already has high-end structure and boss content: The Twilight Forest, The Aether, Deeper and Darker, End Remastered, True Ending, plus Iron's Spells. More content means more world generation next to Distant Horizons; Deeper and Darker already has an open hang report with generation (`refs/issues.md`).
- Meet Your Fight 1.6.2 (22.6 MB, Curios only, 1 open issue), Born in Chaos 1.7.5, Aquamirae 6.4.0 (needs Obscure API) and The Graveyard 4.0.1 (needs Villager Trading Plus) were read as jars only; none shows a hard conflict. BossesRise has the AllTheLeaks overwrite pair. Bosses of Mass Destruction (last 2024-01, 14 of 26 issues open) and Terramity (2025-01) are old.
- Ice and Fire CE stays on hold since 2026-11-24. Total conversions (Advent of Ascension, DivineRPG) were excluded under rule (a).
- Not checked for any of these: Oculus, Embeddium and Distant Horizons behavior (except the two Mutant Monsters shader issues), Fresh Animations and EMF compatibility, TaCZ damage handling against bosses.

## Axis 4: more kinds of enemies

| Item | Result | Evidence |
| --- | --- | --- |
| No Mindless Shooting 2.3.0 | Recommended to review further | TaCZ shots add noise points; at the threshold it spawns a horde or mobs near the player; silencers reduce the points; keys read: `threshold`, `hearingRadius`, `spawnRadius`, `cooldown`, `timeLimit`, `excludedWeapons`, `gunPoints`, `silencerModifiers`, `mobs`, `spawnCount`, `ignoreEncased`, `useHorde` (`hordeSpawnTable` and `hordeDuration` only apply with The Hordes). With `useHorde` off it spawns the entities in `mobs` (default `minecraft:zombie`) near the player; the config comment says "hordeless mode may have issues, please report them". 2 issues listed, 0 open, 22.8 k downloads, no dependency. Overlaps TACZ-Sound Attracts Zombies only in theme: that mod alerts zombies already in range, this one spawns more |
| TaCZ More Level 1.4.2 | Not recommended | A full second system: armed NPCs, weapon quality tiers (adds player damage), armor, bosses, a black market; 562 TaCZ string hits, 32 class references resolve. Simple Enemy is the pack's gun-enemy system (`refs/notes.md`: one system only) |
| Insurgents 1.2.0 | Not recommended | AI with firearms but no guns of its own and no TaCZ class reference; overlaps Simple Enemy |
| Hostile Humans, Immersive Pillagers | Not recommended | Melee and armed humans in structures; pillager hordes and camps. Overlap Simple Enemy events and Guard Villagers' defense role |
| Mutant Monsters 8.0.8, Illager Invasion 8.0.7 | Option (non-gun variety) | No new library (Puzzles Lib is installed), small jars, same author as Leaves Be Gone. Mutant Monsters: 58 open issues, two shader rendering reports |
| Undead Unleashed 2.0.6, Variants and Ventures 1.0.30, Zombies Reworked, The Knocker, Obsessed, Arphex, Dontcry | Option | Jars read: no hard conflict. Variants and Ventures needs Resourceful Lib; Dontcry is 102 MB; stalker mobs are scare-themed |
| The Hordes, Undead Nights, Zombie Apocalypse Addon, Enhanced Hordes | Not recommended | Overlap Zombie Awareness wandering hordes, Enhanced Celestials 2 blood moons and Clanging Howl; The Hordes has 81 open of 175 listed |
| More Mob Variants, Zombie Variants, Luminous Monsters | No difficulty effect | Cosmetic or spawn variety |

## Follow-up 2026-11-25 (the user's questions)

Evidence: `followup_products.csv`, `content_counts.csv`. Six more jars were read (Monsters Level Up 1.6, Mod Scaling 1.0.0, Advanced Mobs 2.0.0, D2 Affix 0.1.3, In Control! 9.5.1, Mob Dice Attributes 1.0.0): 0 hard conflicts and 0 overwrite pairs for all six; none of them has more than one shared hook class.

### F1. L2Hostility, Champions, Improved Mobs, and similar mods

| Item | Champions Unofficial 20.1.1.6 | L2Hostility 2.5.19 | Improved Mobs 1.13.7 |
| --- | --- | --- | --- |
| Idea | A mob randomly spawns as a champion (chance 0.1, inferred) with tier-based affixes | Every enemy gets a level; the level comes from the player's progress, dimension, biome and distance; traits unlock by level; mobs also get gear (weapon and armor data) | Every hostile mob scales with a difficulty value that rises with time; equipment, block breaking, ladders, stealing |
| What sets the strength | Random roll and tier; no link to player progress | Player level (kills up, deaths down), Overworld biome base 5 to 50, Nether 20, End 40 | Time (default); config-driven |
| Which mobs | Tag `champions:allow_champions`: 37 vanilla hostile mobs including Ender Dragon and Wither; no modded mob by default | All enemies (inference: tags are empty); entity data for Twilight Forest 8, Cataclysm 18, Ice and Fire 5, Bosses of Mass Destruction 4, Mowzie's 3, Mutant Monsters 1; vanilla Wither and Ender Dragon are base level 50 | All hostile mobs, modded gear included |
| Against guns | Adaptable, Dampening, Shielding and Reflective affixes work against bullets from tier 1 or 3 (`mob-difficulty/`) | Adaptive, Reflect, Repelling, Dementor, Teleport and Undying from level 100 to 150; factors in the Common config | None; stats and gear only |
| Not installed dependency | Architectury API 9.2.14 (its `mods.toml` is in the NeoForge layout, so Forge does not check it; inference) | L2 Library 2.5.7 and L2 Complements 2.6.1 (Curios and Patchouli already installed) | TenshiLib 1.7.6 |
| Config route | Server config (`defaultconfigs/` path uncertain, issue 92), attribute data pack | Common config (Forge) plus data files; to override data files the pack needs a data pack channel: Open Loader 19.0.5 (2026-02-12, 7.7 M downloads, no required dependency) is one | Config files; server side |
| Known clashes | True Ending: champion Ender Dragon spawns below full health, maintainer advises against (issue 72); In Control! health rules (issue 145) | True Ending with the level-50 Ender Dragon: not checked | Enhanced Celestials 2, Vanilla Backport, Let Me Despawn hook the same `Mob` methods (plain injects) |
| Maintenance | release 2026-09-06; 50 issues, 12 open | release 2026-03-26; 31 issues listed, 9 open; 2.9 M downloads | release 2026-06-19; 196 issues listed, 21 open |

Similar mods found (all Forge 1.20.1, jar read):

| Mod | Downloads, date | What it is | Difference from the three |
| --- | --- | --- | --- |
| Monsters Level Up 1.6 | 8.7 k, 2026-11-04 | Mobs level up by milestones: iron armor, diamond armor, enchanting, Nether, Ender Dragon; new gear, shields, reinforcements, behaviors; GeckoLib optional | Progress based like L2Hostility but by fixed milestones, gear and behavior only (no traits), small user base |
| Mod Scaling 1.0.0 | 3.5 k, 2024-11-15 | Gear and effects by progress (iron, diamond, totem, Nether, stronghold, dragon) | Gear only; no stat scaling |
| Advanced Mobs 2.0.0 | 2.6 k, 2026-10-28 | Elite versions of zombies, skeletons, blazes scaled by the vanilla difficulty setting; needs GeckoLib (installed) | Few mobs, vanilla difficulty setting as the only scale |
| D2 Affix 0.1.3 (beta) | 198, 2026-08-02 | Diablo 2 style elite tiers, affixes and auras, data driven | Champions-like; beta, tiny user base |
| Summoners 1.0.1 | 2.2 k, 2026-07-31 | 5 % of hostile mobs become summoners that call reinforcements | One behavior only |
| In Control! 9.5.1 | 4.2 M, 2026-10-25 | Rule files for spawns, with attribute changes under conditions; no dependency; slug is `in-control` | Rules you write yourself; no built-in progression; on hold since 2026-11-24 |
| Majrusz's Progressive Difficulty 1.9.10 | 1.1 M, 2024-04-26 | Stages by Nether and Ender Dragon, Undead Army raid | Dated build, 54 open issues |
| Scaling Health 8.0.2, Hostile Mobs Improve Over Time 1.9.1, Brutal Nightmare | see axis 1 | Time based or data pack based | See axis 1 |
| Infernal Mobs, Eldritch Mobs | CurseForge | Classic elite-mob mods | No 1.20.1 Forge file found (Eldritch Mobs is Fabric only) |

Result: no other mod combines progress-based levels, traits and per-mod entity data at this scale (next best in the same idea: Champions at 0.1 M downloads, Monsters Level Up at 8.7 k). Champions and L2Hostility are the same kind of mod (install one). Improved Mobs and L2Hostility both raise the stats and give gear of the same mobs, so running both would apply two scalings to one mob ("double scaling"; whether they add or multiply depends on each modifier's operation, not computed; not tested); choose one for the stats and use In Control! or Monsters Level Up only if a specific behavior is missing.

### F2. How much content: Cataclysm, Mowzie's Mobs, Legendary Monsters, Mutant Monsters

Counts come from the jars (`content_counts.csv`): "entity lang keys" counts every named entity type, so it includes projectiles and effects; "mob classes" counts non-abstract classes whose parent chain reaches a vanilla mob class. Boss names are my reading of the language files; the script's own boss detection undercounts (0 for Cataclysm) and is not used.

| Mod | Entity types (lang keys) | Structures (JSON, NBT) | Named content |
| --- | --- | --- | --- |
| Cataclysm 3.31 | 97 | 14, 188 | Bosses by name: Ender Guardian, Netherite Monstrosity, Ignis, The Harbinger, The Leviathan, Ancient Remnant, Scylla, Maledictus; mini-bosses and elites such as Amethyst Crab, Coralssus, Wadjet, Kobolediator, Aptrgangr, Royal Draugr; mobs such as Deepling (5 kinds), Draugr, Ignited Berserker, Koboleton |
| Mowzie's Mobs 1.8.2 | 19 | 4, 111 | Bosses by name: Ferrous Wroughtnaut, Umvuthi (the Sunbird), Frostmaw, Tongbi the Sculptor; mobs: Foliaath, Umvuthana (several kinds), Grottol, Lantern, Naga, Bluff, Elokosa |
| Legendary Monsters 2.2.4 | 37 | 13, 71 | The page says "early, middle, late game bosses"; the lang file has Skeletosaurus, Overgrown Colossus, Frostbitten Golem, Lava Eater, Chorusent, Withered Abomination, Ancient Guardian, Possessed Paladin, The Obliterator, Fractured Apostle and others; which are bosses was not separated |
| Mutant Monsters 8.0.8 | 16 | 0, 0 | Mutant Zombie, Skeleton, Creeper, Enderman, Snow Golem and Zombie Villager; Spider-Pig; their minions and body parts. No structures, no dimensions |
| For scale: The Twilight Forest (installed) | 81 | 16, 65 | 21 biomes, 1 dimension |

So per mod: Cataclysm has about 2.6 times the entity types of Legendary Monsters and 5 times those of Mowzie's, and 1.7 to 2.6 times their structure templates. Mowzie's is a small boss set (4 bosses, 111 structure templates). Mutant Monsters is a mob-variant mod without structures.

Larger content mods (storage is no issue per the user). Same measure:

| Mod | Entity types | Structures (JSON, NBT) | Biomes | Notes |
| --- | --- | --- | --- | --- |
| Goety 2.5.60.6 | 302 (284 mob classes) | 16, 259 | 0 | Necromancy and magic mod with many mobs and structures; 91 MB; overlaps Iron's Spells 'n Spellbooks |
| Alex's Mobs 1.22.9 | 117 (page: 89 mobs) | 0, 0 | 0 | Mostly real-world creatures plus a few fantasy ones; boss mobs exist; release 2024-09-06 (last 1.20.1 build); 15.8 M downloads; not a difficulty mod and not in the ledger before |
| Cataclysm 3.31 | 97 | 14, 188 | 0 | |
| Fungal Infection: Spore 2.2.0j | 96 | 13, 21 | 0 | 111 MB; mods.toml Minecraft range `[1.20,1.20.1)` excludes 1.20.1 as written (read, not run) |
| Born in Chaos 1.7.5 | 86 | 31, 27 | 0 | Aggressive mobs; 31 structures |
| Alex's Caves 2.0.2 | 81 | 14, 91 | 6 | 71 MB |
| Ice and Fire CE 1.2.7 | 53 | 13, 26 | 2 | On hold since 2026-11-24; the original (beta) has 60 |
| Blue Skies 1.3.31 | 46 | 14, 569 | 23 | A dimension mod; 80 MB; release 2024-01 |
| Advent of Ascension, DivineRPG | not counted | | | Total conversions, excluded under rule (a) |

Weight in the sense of TPS or FPS was not measured for any of them. The only proxies here are entity types, structures and Mixin classes (Cataclysm 25, Goety 47, Alex's Mobs and Alex's Caves not scanned).

Correction (same day): the heaviness of Alex's Mobs is not explained by its content size. The reports name per-tick AI searches (elephant item targeting, crow path finding), long-distance block searches (leafcutter ant queen), unlimited population (leafcutter ants, cachalot whales, catfish, pupfish) and, with Citadel, a nesting `level.dat`. Details, issue numbers and the same check for the candidates: `followup_alexsmobs_perf.md`. The maintained 1.20.1 line is Alex's Mobs Continued 2.3.0 (2026-11-07).

### F3. No Mindless Shooting and Zombie Awareness

- No code link: its jar has no reference to Zombie Awareness and no Mixin. It listens to TaCZ's `GunShootEvent` (server) and to the player-logout event, adds noise points per shot (gun and silencer values from the config), and at the threshold its `TriggerHandler` spawns `spawnCount` entities from the `mobs` list (default `minecraft:zombie`, with `useHorde` off) at `spawnRadius` around the player and gives `PathfinderMob`s a `NearestAttackableTargetGoal` and `HurtByTargetGoal` toward the player. With The Hordes installed and `useHorde` on, it starts a Hordes event instead (optional integration). The config marks the hordeless mode as possibly buggy.
- Zombie Awareness 1.13.1 (installed) gives senses to its listed mobs at `MobSpawnEvent.FinalizeSpawn` and through sound and block events. TACZ-Sound Attracts Zombies (installed) calls `ZAUtil.hookSoundEvent` on TaCZ gunfire and reload. So one shot would do two separate things: attract mobs already in range (sound sense through Zombie Awareness) and add noise points that spawn new mobs later.
- They stack and do not clash (different events, no shared hook, 0 Mixin in No Mindless Shooting). Silencer rules exist twice (its `silencerModifiers` and the `/tsaz` silencer command), so they have to be set by hand to agree.
- Not checked: whether mobs spawned by No Mindless Shooting pass through `FinalizeSpawn` (then Zombie Awareness would enhance them if the type is in `enhancedMobs`); whether non-vanilla ids such as Simple Enemy units work in `mobs` (the mod falls back to `minecraft:zombie` when no id is valid).
- Pressure per shot rises with all three together. Run in game before tuning.

### F4. Replace an installed difficulty mod?

| Installed | Overlapping candidate | Result |
| --- | --- | --- |
| Zombie Awareness 1.13.1 (last build 2024-09, 9.3 M downloads) | Zombie Game Reborn 2.1.0 (14.7 k, TaCZ hooks), The Hordes, Undead Nights | Keep: none replaces the senses system; the others are horde events |
| Enhanced Celestials 2 (Core, Default Lunar Events, Shader Support) | Zombie Apocalypse Addon 1.15.0 (301 k, 2026-11-10, server side) | Possible swap, not recommended by evidence alone: its Standard preset is much stronger (blood moons on 15 % of nights with x5.0 spawn chance, hordes every 5 days, difficulty scaling from day 3 to 50) but zombies only, with no sky or lunar visuals and no shader support. Two blood-moon systems must not both run (inference) |
| Clanging Howl 1.1.0 | L2Hostility | Not a replacement. Its own scaling (stats x(1 + 0.005 x days) up to x6, resistance up to 50 %) would stack with L2Hostility levels; switch `TechnoFleshBuff` off or accept double scaling |
| TACZ-Sound Attracts Zombies 1.1.0 | No Mindless Shooting | Different jobs (attract versus spawn); keep both, align silencer values |
| Simple Enemy 0.1.6 (beta) | TaCZ More Level 1.4.2, Insurgents 1.2.0, TaCZ NPCs 2.1.0 | Keep: none covers its factions and events; TaCZ More Level adds player power and is a second gun-enemy system |
| True Ending, End Remastered, Deeper and Darker, The Twilight Forest, The Aether | EDF Remastered (last 2023-08), Wither Reincarnated, Alternative Twilight | Keep: the candidates are older or add less |
| Guard Villagers, Spawn Animations | none found | Keep |

Result: no case found where a candidate clearly beats an installed difficulty mod. The two points to settle are config ones (Clanging Howl against L2Hostility, the silencer values), and Champions stays unneeded if L2Hostility is chosen.

### F5. Feature overlap: Improved Mobs, L2Hostility, Zombie Awareness and the rest

Source: Modrinth pages (full text), `Config$CommonConfig` key names and class list of Improved Mobs 1.13.7, `l2hostility_config` data of L2Hostility 2.5.19. "Overlap" means the installed or candidate mod does a similar job; "unique" means none of the installed mods or candidates read does it.

| Feature | Improved Mobs | L2Hostility | Zombie Awareness (installed) | Others installed | Overlap |
| --- | --- | --- | --- | --- | --- |
| Difficulty value that drives the rest | Yes. `difficultyType`: time (default), PLAYERMAX, PLAYERMEAN, PLAYERSUM, DISTANCE, DISTANCESPAWN; can read Scaling Health, PlayerEx, LevelZ | Yes. Level from dimension, biome, position, nearby player difficulty and entity type; player and chunk difficulty rise on kills, fall on death | No (`daysBeforeFeaturesActivate` only delays its features) | Clanging Howl (days, its own mobs only) | Improved Mobs and L2Hostility |
| Higher health, damage, speed, knockback resistance | Yes (`healthIncrease`/`healthMax`, `damageIncrease`, `speedIncrease`, `knockbackIncrease`) | Yes (`healthFactor`, `damageFactor`; traits Tanky, Speedy, Protected, Regenerating) | No | Clanging Howl (its own mobs) | Improved Mobs and L2Hostility |
| Resistance by damage kind | Magic, projectile and explosion resistance by difficulty (`magicResIncrease`, `projectileIncrease`, `explosionIncrease`; applied in `EventCalls` through `DamageTypeTags`) | Traits Dementor, Dispell, Reflect, Repelling, Adaptive and others (level 100 and up) | No | Clanging Howl: up to 50 % resistance on its mobs | Partly |
| Gear on mobs (armor, weapons, enchants) | Yes, all hostile mobs, modded gear included (`baseEquipChance`, `equipmentModWhitelist`, enchant chances) | Yes, data files `weapon/vanilla.json`, `armors.json` and per-mod files with enchant chances by level | No | Simple Enemy units carry their own loadouts | Improved Mobs and L2Hostility |
| Special abilities | Item use (ender pearl, flint and steel, TNT, snowballs, lava bucket, bows, splash potions, enchanted-book buffs and fangs), water and flying mounts (guardian, parrot or phantom) | 37 traits on the page (39 data entries): potion, aura, projectile, split, undying, teleport, gravity and more | No | none | Unique on both sides |
| Mobs break blocks, climb ladders actively, steal from opened chests | Yes (`mobListBreakWhitelist`, `LadderClimbGoal`, `StealGoal`) | No | No | none (Zombie Apocalypse Addon has optional block breaking, not installed) | Unique to Improved Mobs |
| Villagers targeted by all hostiles, aggressive endermen | Yes (`targetVillagerWhitelist`, `neutralAggroWhitelist`) | No | No | Guard Villagers is the counter | Unique to Improved Mobs |
| Sight and targeting changes | Yes (`genericSightIgnore`, `breakerSightIgnore`, mixins `EntitySensingMixin`, `TargetGoalMixin`, `NearestTargetGoalMixin`) | No | Blood, sound and light senses, wandering hordes; `seeThroughWalls` and `omniscient` (off) | Simple Enemy has its own tactical AI | Improved Mobs and Zombie Awareness meet at targeting |
| Pathfinding performance mixins | Yes (`mixin/pathfinding/performance`) | No | No | AI Improvements ("performance improvements for vanilla AI") | Improved Mobs and AI Improvements (not tested together) |
| Per-mod boss and mob data | No | Yes: The Twilight Forest 8, Cataclysm 18, Ice and Fire 5, Bosses of Mass Destruction 4, Mowzie's 3, Mutant Monsters 1; vanilla Wither and Ender Dragon level 50 | No | none | Unique to L2Hostility |
| Safe zones, spawners, progression items | No | Hostility Orb (chunk without leveled mobs), Hostility Spawner, Detector, 28 curios, 2 enchantments, trait symbols that craft gear | No | none | Unique to L2Hostility (and it adds player power) |
| Pet armor and pet protection | Yes | No | No | Touhou Little Maid has its own | Unique |

Reading:

- Zombie Awareness overlaps with neither mod on stats, gear or abilities. It decides where and when mobs notice and come; the other two decide how strong and how special they are. The only meeting point is targeting (sight and goal changes in Improved Mobs against the senses of Zombie Awareness).
- Improved Mobs and L2Hostility overlap on 3 of 12 rows (difficulty value, stat increase, gear), with part of resistance. Improved Mobs' unique part is behavior (break, climb, steal, mounts, item use, villager and neutral targeting). L2Hostility's unique part is traits, per-mod boss data, safe zones and progression items.
- The overlap rows are numbers and gear, which Improved Mobs lets you switch off one by one (the page: all features can be turned on and off; keys `enableDifficultyScaling`, `mobAttributeWhitelist`, `armorMobWhitelist`, `heldMobWhitelist`). So Improved Mobs for behavior and L2Hostility for strength is a possible split (not tested).
- Corrections to earlier lines: L2Hostility's page lists 37 traits (39 data entries), not 40. Improved Mobs is time based by default but can be driven by player or distance difficulty. It also has projectile resistance by difficulty; TaCZ's jar does not add its bullet damage types to `minecraft:is_projectile` (it adds only `bypasses_armor` and `bypasses_invulnerability` entries and its own `tacz:bullets` tag), so (inference, the exact check was not decompiled) bullets are probably not reduced by it.
- Risk is in behavior overlap, not in numbers: two mods changing targeting or goals on the same mob. Guard Villagers issue 314 (closed) is an example between AI mods. Not tested here.

## What each axis adds to the pack

- Scaling: L2Hostility, L2 Library, L2 Complements (3 jars, 3.4 MB). Or Improved Mobs and TenshiLib (2 jars, 0.7 MB).
- Survival: Cold Sweat (2.6 MB), Thirst Was Reclaimed (0.2 MB), TaCZ Bleeding (0.3 MB). First Aid and its compat add 1.3 MB and turn natural regeneration off.
- Content: Cataclysm and Lionfish API (about 70 MB of jar; the `.mrpack` grows by about that much).
- Enemy: No Mindless Shooting (about 20 KB).
- All are `both` by Modrinth data except Improved Mobs (client optional) and Legendary Monsters (both optional). No jar was found client-only.

## What the user has to decide

1. Scaling: L2Hostility (progress based, anti-gun traits by level 100 and above, numbers in data files) or Improved Mobs (time based, stats only) or neither (turn up Clanging Howl, Zombie Awareness and Simple Enemy settings).
2. Survival: temperature (Cold Sweat) and thirst (Reclaimed or Homeostatic). TaCZ Bleeding is on hold: the user will try it first (2026-11-25). First Aid is not wanted unless asked.
3. Content: Cataclysm, or a lighter boss mod (Mowzie's Mobs, Legendary Monsters), or none; see F2 for sizes.
4. Enemy: No Mindless Shooting (compatible by code with Zombie Awareness, see F3), and whether non-gun variety (Mutant Monsters, Illager Invasion) is wanted.
5. Data pack channel: Open Loader would be needed to ship L2Hostility trait and level data (a new mod; needs approval like any other).
6. Whether the test is a staged add: one axis first, then measure with the same world before the next.

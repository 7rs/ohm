# Reported problems found by GitHub issue search (2026-11-24)

Method: GitHub search API, `repo:<repo> "<keyword>"`, keywords Oculus, Embeddium, Distant Horizons and a few mod names (`scripts/gh-issues.ps1`). The issue bodies listed below were then read (`scripts/gh-read.ps1`). A keyword match is not proof: many hits only contain the word in a crash header (for example Embeddium's "tainted by mods" line) or in an item name (Ars Nouveau's Scryer's Oculus). Reports are third-party claims. Most were not on this pack's versions. Nothing was reproduced.

## Reports that fit this pack's stack (Forge 1.20.1, Oculus 1.8.0, Embeddium, Distant Horizons 3.3.3)

| Mod | Issue | State | What it says | Fit |
| --- | --- | --- | --- | --- |
| Cracker's Wither Storm | #2505 | open | The Wither Storm vanishes when far away with Distant Horizons. The author: probably DH's dither fade; needs proper DH support. A 2025-11-30 comment reproduces it with Oculus, Embeddium and DH | Same stack, 1.20.1 Forge, mod 4.2.1 (the version in the table) |
| Cracker's Wither Storm | #2293 | open | Distant render layers are broken with Oculus (screenshots with and without) | Same stack |
| Ice and Fire (original) | #5416 | open | 1.20.1 Forge, 2.1.13 beta 5 with Citadel 2.6.0: crash while waiting for Distant Horizons to load chunks, generating a hydra cave | Same loader, DH; the log is external and was not read |
| Ice and Fire (original) | #5610, #5538, #5589 | open | Ghosts intermittently invisible with shaders; transparent dragon; lag hovering over fairies with shaders | Shader issues on 1.20.1 |
| Touhou Little Maid | #1146 | open | "Exception ticking world" at random, on `PersistentEntitySectionManager.tick` and `processUnloads`. Confirmed on 1.20.1 Forge 47.4.16 on 2026-11-16: three `ConcurrentModificationException` crashes after long-distance `/tp` (several thousand blocks); also 1.21.1 NeoForge. The mod's own Mixin hooks `PersistentEntitySectionManager.tick` at `processUnloads()` (read from the jar) | Server crash risk. Waystones teleports are long-distance too (inference) |
| Botania | #3951 | open | Shader packs break Botania's own shaders: sparks invisible, mana pools look empty, pylons part invisible. The thread says to disable the shader use in Botania's client config; the jar has the key `useShaders` (`ForgeBotaniaConfig$Client`) | Reported on 1.18; whether Oculus 1.8.0 with build 456 still has it is unknown. Its default was not read |
| Vanilla Backport | #89 | open | After a portal trip the screen froze; turning shaders on then crashed (Oculus) | One report, modpack not this one; the mod version is not given |
| Spawn Animations | #53 | open | Spiders invisible until the player is a few blocks away; the reporter suspects the Fresh Animations pack and entity culling (Minecraft 1.21.11) | The pack has Fresh Animations and Entity Culling; not reproduced by the author |
| 3D Skin Layers | #165 | open | The first-person hand layer warps backward while ParCool's own sprint is active (3D Skin Layers 1.6.6, ParCool 3.2.1.2) | Old versions; the pack has 1.11.4 and ParCool 4.0.2.0 |
| Deeper and Darker | #441 | open | Loading into the Otherside freezes on 1.20.1 Forge; one comment blames Embeddium, a later one traces it to `OthersideColumnFeature` and `CrystallizedAmberBlockEntity.generateFossil()` while flying through unexplored chunks, and says Embeddium is not involved | World generation hang; DH's distant generator may reach the same code (inference) |

## Reports that were closed or do not apply

- Distant Horizons misread Deeper and Darker's dimension name (Deeper and Darker #386, closed 2024-11-06, before 1.3.3 of 2024-11-16).
- Create Crafts & Additions #1063 and #899 (open): crashes with Create 6.0.1 to 6.0.6 and Create Crafts & Additions 1.3.2 or older ("expected flywheel 0.6.9", "expected create 0.5.1"). Version 1.3.3 requires Create 6.0.3 or newer in its `mods.toml`, and the pack has 6.0.8. Not verified in the game.
- AE2 #8772 (closed 2026-10-28): a client crash when auto-filling the wireless crafting terminal; the AE2 author says the error is in FastSuite. It is on Minecraft 1.21 with NeoForge, and the pack has FastSuite 5.1.2 on 1.20.1. Check with spark after adding AE2.
- Mekanism #8609 (closed 2026-11-04): TaCZ's hand animation breaks while wearing the Mekasuit chestplate (1.21.1 NeoForge). A commenter says the Create netherite backtank does the same, and the Mekanism author doubts it is theirs. The pack has TaCZ 1.1.8-hotfix2 and Create; not tested on 1.20.1.
- Botania #4580 (1.20.1, animations broken with Sodium or Embeddium) and #5036 (a particle shader sampler fix) are closed.
- Ice and Fire Community Edition: no issue matched Oculus (0) and one closed issue matched Distant Horizons (#116, about replacing the original). A smaller user base means fewer reports, not proof of none.
- Zombie Awareness #136 (open, a feature proposal for more sound sources) is the only TaCZ mention. Gunshots are not covered by the mod.

## Raw output

`gh_raw_search.txt` (all queries) and `gh_raw_issues.txt` (the issue bodies read).

# Scope: Japanese localization for the ohm pack

Research date: 2026-11-24. Trigger: the user asked whether All Japanese Translate (jtrans, CurseForge) is a good choice ("the biggest of the Japanese localization mods?").

## Market and goal

- Market: sources of Japanese text for Minecraft 1.20.1 Forge mods that do not ship (complete) Japanese themselves. Forms: a mod that injects translations, a resource pack with `ja_jp.json` files, a machine-translation mod, or "no mod" (a resource pack written for this pack).
- Goal: the player sees Japanese in the mods the pack installs (`lang:ja_jp` is already the first-launch default in `config/defaultoptions/options.txt`). The pack is performance-tuned, so a candidate that hooks rendering paths counts as a risk.
- Comparison type: product comparison, with the current state (official `ja_jp.json` only) as the baseline.
- Baseline: official `ja_jp.json` files inside the 91 installed jars.

## Hard constraints

- Forge 1.20.1 must be able to load it (or it must be a resource pack).
- Must not need a server-side install (the pack ships one client set).

Everything else is a preference or a tag.

## Criteria and weights (fixed before ranking)

| Criterion | Weight | Evidence wanted | Scale (0 = worst, 100 = best) |
| --- | --- | --- | --- |
| Coverage of this pack's text keys | 40 | Measured: key-level match against the 91 pack jars | 61.3 % (official only) = 0, 100 % = 100 |
| Runtime risk and compatibility | 20 | Read from jar or source; "not run" is stated | resource pack with no code = 100; code that hooks hot render paths without a run = 40 |
| Maintenance and direction | 15 | Release dates and counts | stale for 2 years = 10; weekly releases by one author = 70 |
| Translation quality | 10 | Evaluated: own reading of random samples (not independent) | judged natural and context-aware = 80 |
| Distribution footprint | 10 | Measured: file size | 5 MB = 100, 50 MB = 20 |
| Install effort | 5 | Read | drop-in = 100 |

Quality is the only criterion whose evidence is the author's own reading; it carries 10 % and the result is also shown without it.

## Tier rules

S 85 or more, A 70 to 84, B 55 to 69, C below 55. Candidates with only Claimed evidence go to "Unverified". Candidates whose upper bound cannot reach A go to "Bounded".

## Exclusions (reasons from the allowed list)

- (a) outside the category: Chinese-language tools (VM Translation Utility, Masa Mod Translation Pack, Sodium Chinese Localization Pack, i18nUpdateMod), FTB Quests key libraries, language tools that translate nothing (Texture Locale Redirector, Language Reload).
- (a) none of the pack's mods are translated by it: single-mod packs for mods that are not installed (Mya's masady mods, Relics, Simply Swords, Create Aeronautics, Blockfront, and similar), a pack made for another modpack (Craft to Exile 2).
- (b) no 1.20.1 build: More ja_jp (1.12.2 only).

## Not used as criteria

Licence and redistribution terms (the user will check them in bulk later).

## Method limits

- Key matching is by key presence, not by translation text. A present key may hold a weaker translation than the official one.
- Data-driven text (Patchouli books, quests, advancements, gun-pack lang files nested in jars) was not counted. The TaCZ default gun pack has an official `ja_jp.json` inside `assets/tacz/custom/tacz_default_gun/` (checked).
- Nothing was run in the game.

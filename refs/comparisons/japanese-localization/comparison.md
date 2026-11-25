# Japanese localization for the ohm pack (Forge 1.20.1)

Status: provisional (see `coverage_report.md`). Research date: 2026-11-24. Nothing was run in the game; every behavior below comes from reading jars and web pages. Decision (2026-11-24, user): both jtrans and Japanese Language Pack were added to the pack.

## Headline

jtrans (All Japanese Translate) is worth adding on coverage: for this pack it lifts the share of text keys that have Japanese from 61.3 % (official `ja_jp.json` only) to 90.7 %. It is the largest all-in-one Japanese localization mod for 1.20.1 (3,268 mods on its 1.20.1 page). It is not the best choice on every axis:

- It is a code mod that hooks text drawing (`Font.drawInBatch`, `GuiGraphics.drawString`, tooltips, `LiteralContents`) in a pack tuned for frame time. The cost was not measured.
- Japanese Language Pack (a resource pack, no code) reaches 86.2 % alone, and covers Punchy! (710 keys), AsyncParticles, Optimized Block Entities and Cubes Without Borders, which jtrans does not.
- The two together reach 98.1 % (251 keys left).

If zero runtime risk matters most, Japanese Language Pack alone ranks first. If coverage matters most, both together rank first. jtrans alone ranks below the combination, and below Japanese Language Pack alone on the weights in `00_scope.md`; it ranks above Japanese Language Pack only if both the risk and the footprint criteria are ignored.

## Is it "the biggest"?

- Biggest all-in-one for Japanese: yes (3,268 mods listed for 1.20.1, 3,533 `ja_jp` namespaces in its 1.20.1 pack, 31,465 CurseForge downloads; the Modrinth slugs `jtrans` and `all-japanese-translate` return 404 and its site names CurseForge as the official source).
- Biggest by downloads among Japanese-related projects: no. Sodium 日本語訳 has 39,480 Modrinth downloads (two mods only). AutoTranslation has 277,650 CurseForge downloads (online machine translation for any language, last updated 2023-12).

## Measured coverage (13,177 text keys, 56 namespaces, 91 pack jars)

| Source | Keys with Japanese | Share | Keys it fills |
| --- | --- | --- | --- |
| Official `ja_jp.json` only (baseline) | 8,075 | 61.3 % | n/a |
| + jtrans 1.9.1 | 11,956 | 90.7 % | 3,881 of 5,102 missing |
| + Japanese Language Pack V57 | 11,362 | 86.2 % | 3,287 of 5,102 missing |
| + both | 12,926 | 98.1 % | 4,851 of 5,102 missing |

Where they differ (key counts of the missing keys filled):

- jtrans only: Xaero's Minimap 459, Shoulder Surfing Reloaded 360, Create 266 (mostly EMI category keys), LR Tactical 107, The Aether 79.
- Japanese Language Pack only: Punchy! 710, AsyncParticles 156, Optimized Block Entities 63, Cubes Without Borders 36.
- Both: Distant Horizons 488, Twilight Forest 383, Xaero's World Map (326 and 289), EMF 287, ETF 307 and 311, Chloride (173 and 155), Dynamic FPS 85, Sodium (Embeddium) 65.
- Left after both (251): Punchy! Moves 134, Remove Reloading Screen 29, Bedrockoid 25, Shoulder Surfing 23, Punchy! 18, Weather Refined 6, JEI/EMI Optimizations 6, Fast Items 5, Key Binding Patch 3, Distant Horizons 1, Chloride 1.

Limits: key presence, not text quality; Patchouli, quests and nested gun-pack lang files are not counted.

## What jtrans is (read from the jar)

- One universal jar for Forge, NeoForge, Fabric and Quilt (Minecraft 1.12.2 to 26.3). 52.7 MB for 1.9.1. CurseForge file ID 9731652 (packwiz picks it for 1.20.1 Forge), CurseForge environment "Client".
- Translations are stored in a custom database (`META-INF/jtrans/db/v1/*.bin`, magic `JTD2`). The resource pack inside the jar (`resourcepacks/jtrans_1201`) holds 153-byte stub `ja_jp.json` files that point to a block. A Mixin on `Language.loadFromJson` (`NamedLanguageMixin`) expands the stub when the game reads it.
- Hard-coded English in other mods' screens is replaced through Mixins (`FontStringMixin`, `GuiGraphicsStringMixin`, `ForgeTooltipGatherMixin`, `LiteralContentsMixin`) plus per-mod ones (Essential, Enchanted, MCA, ReAvaritia, and others). All use `required: false` and `defaultRequire: 0` with a plugin that gates them, so a missing target does not stop the game.
- `mods.toml` has 1,376 `[[dependencies.jtrans]]` blocks; all but Forge and Minecraft are optional with `ordering = "AFTER"`. `displayTest` is `IGNORE_ALL_VERSION` (no red X on servers). Inference, not run: loading after those mods puts its pack after theirs, so jtrans text wins over a mod's own Japanese for the same key.
- Its text equals the official Japanese for the large mods (Create 99.4 %, EMI 99.9 %, Twilight Forest 99.2 %, TaCZ 99.3 %, Xaero's Minimap 98.3 %), and differs a lot for others (ModernFix 9.3 %, JEI 21.9 %, The Aether 35.3 %, BetterF3 37.3 %, Jade 48.8 %). For those it replaces the official wording (inference from the load order above).
- No reference to `java/net/http`, `HttpURLConnection`, `Socket`, `ProcessBuilder` or `URLClassLoader` in any class (static string check, not a security audit).
- `packwiz modrinth export` works with it (it is bundled into the zip; a scratch pack with only jtrans exports to 48.9 MB). The ohm `.mrpack` is 23.6 MB now, so expect roughly 70 MB.
- Quality sample (my own reading, not independent): natural and context-aware (for example Xaero's settings tooltips, Distant Horizons options, Chloride options). The author's notes list audits, placeholder checks and fixes of machine-translation wording.

## Risks of jtrans (all unverified in a run)

1. Hot-path hooks: `Font.drawInBatch(String...)` and `GuiGraphics.drawString` are also the paths ImmediatelyFast (`MixinDrawContext`, `MixinFontManager`, `MixinTextRenderer_Drawer`), Embeddium, Gnetum, EMI and BetterF3 work on (mixin scan in `data/mixin-hits.csv`). jtrans injects `@ModifyVariable` on the string argument inside `Font` and `GuiGraphics`. Whether that clashes with their injections was not checked method by method, and no run confirmed either way. The per-frame cost of the lookup is unknown; check frame time with and without it.
2. One author, fast churn: about 23 releases between 2026-09-02 and 2026-11-21, size from 8.2 MB to 78.1 MB (1.8.3) and 52.7 MB (1.9.1). The author's own notes say the final jars of some releases were not smoke-tested in the game.
3. Translations match one version of each mod. For this pack the keys line up well (Create 3,646 of 3,646, Twilight Forest 1,488 of 1,488, Xaero's Minimap 646 of 646), so the pinned versions match today; a mod update can drift.
4. Size: +52.7 MB in the pack and the download.
5. The 1.20.1 Villagers Reborn dialogue patch works in single-player only (not installed here, so not relevant).

## Candidates and tiers

| Candidate | Evidence | Tier |
| --- | --- | --- |
| Japanese Language Pack V57 (P02) | measured 86.2 %, zip read | A (weighted 77.7) |
| jtrans + Japanese Language Pack (P16) | measured 98.1 % | B with the risk criterion (68.8), A without it (76.0) |
| jtrans 1.9.1 (P01) | measured 90.7 %, jar read | B with the risk criterion (63.4), B just under A without it (69.3) |
| AutoTranslation 1.2.1 (P03) | page and README only | Unverified. Online (Google Translate by default), last release 2023-12, author calls screen translation experimental and heavy |
| AutoTranslation AI fork (P04) | README only | Unverified. Created 2026-10-09, tuned and tested for Turkish, sends text to a translation service |
| Own resource pack for the leftover keys (P15) | not built | Bounded. Needs writing and upkeep; only worth it for the 251 keys left after both |
| Single-mod and per-mod packs (P05 to P14) | catalogue text only | Bounded. They cover mods that jtrans or Japanese Language Pack already cover, or mods that are not installed |

Weights: coverage 40, risk 20, maintenance 15, quality 10, footprint 10, install 5 (`00_scope.md`). Scores used (0 to 100): coverage jtrans 76.0, Japanese Language Pack 64.3, both 95.1; risk 40, 100, 40; maintenance 70 for all; quality 80 for all (own reading); footprint 15, 100, 8; install 100, 70, 70. The risk score is an inference (not run), so the ranking was also computed without it (renormalized): both 76.0, Japanese Language Pack 72.1, jtrans 69.3. With coverage 60, risk 10, maintenance 10, quality 5, footprint 10 and install 5 the order is both 76.4, Japanese Language Pack 73.1, jtrans 67.1. With risk and footprint ignored (remaining weights renormalized) the order is both 85.7, jtrans 77.0, Japanese Language Pack 68.1.

## Placement notes if added

- jtrans: `side = "client"` (packwiz marks it `both`; the CurseForge environment is Client and its hooks target client classes). CurseForge source.
- Japanese Language Pack: resource pack, `pack_format` 15 (no `incompatibleResourcePacks` entry needed). The author asks for it to sit above other packs. It would be enabled at first launch through the `resourcePacks` key, which names the file (`AzukiV57.zip`), so the key must be updated whenever the file name changes (same upkeep as Fluid & Foolish). Modrinth first.
- A resource pack above jtrans wins for the same key, so Japanese Language Pack text would override jtrans text where both have a key.
- Existing instances keep their own `options.txt`; they must enable the resource pack by hand.

## Options for the user

1. jtrans + Japanese Language Pack (98.1 %, the most coverage, most upkeep).
2. Japanese Language Pack only (86.2 %, no code risk, small).
3. jtrans only (90.7 %, no Punchy!, AsyncParticles, OBE text).
4. Neither (61.3 %).

# Sources

Round 1 (discovery):

- CurseForge page of jtrans (via Exa fetch): https://www.curseforge.com/minecraft/mc-mods/jtrans
- jtrans official site, 1.20.1 list, mod pages (HTML fetched, parsed): https://jtrans.aoiserver.com/ , https://jtrans.aoiserver.com/minecraft/1.20.1/
- Minecraft Japan Wiki, mod list "言語・翻訳": https://minecraftjapan.miraheze.org/wiki/MOD%E4%B8%80%E8%A6%A7
- Modrinth API search (queries: japanese, 日本語, translation japanese, ja_jp, localization, jtrans, translate mods, language pack mods; project types mod, resourcepack, modpack): https://api.modrinth.com/v2/search
- Web search (Exa): Japanese localization mods and packs for Forge 1.20.1.

Round 2:

- Modrinth API, wider terms (日本語化, japanese localization, japanese translation, mod translation, ja-jp, nihongo, 和訳, 翻訳, translate, auto translate, autotranslation; offsets 0 and 100): 597 unique projects, filtered by title and description.
- CurseForge pages found through web search: Japanese Language Pack, More ja_jp, MOD Japanese translation, Mya's masady mods jp translation.
- Site catalogues: https://craft-palette.net/mods/ , https://ykpiece.github.io/minecraft-ja-packs/
- Articles: https://note.com/den2_nova/n/n504374acaa0f , https://note.com/ebkn_no_note/n/na788f9408a7f , https://note.com/azutani/n/ne65c79cb7bc7

Round 3:

- AutoTranslation: https://www.curseforge.com/minecraft/mc-mods/autotranslation , https://github.com/Moirstral/AutoTranslation , https://github.com/yuefdev/minecraft-ai-translator
- GitHub: https://github.com/twister716/Twister716s-JP-Translations-for-Minecraft-mods , https://github.com/suthibu/ja_jp.json , https://github.com/pazakasin/CraftToExile2-Japanese

Files read directly (measured):

- jtrans-1.9.1.jar (CurseForge file 9731652, SHA-1 2bf8f454ceb577316fa40345fb7a024e3c33455b; packwiz and local hash agree), including `META-INF/mods.toml`, `META-INF/MANIFEST.MF`, `jtrans.mixins.json`, class constant pools of the main jar and `jtrans-runtime-modern-1.8.0.jar`, `META-INF/jtrans/CHANGELOG-1.8.3.md`, and the `JTD2` database blocks.
- AzukiV57.zip (Modrinth `japanese-language-pack`, version V57).
- The 91 jars of the pack's `mods/` (Modrinth URLs from the metafiles; CurseForge ones from the CDN path built from the file ID).
- CurseForge file list of jtrans: https://www.curseforge.com/minecraft/mc-mods/jtrans/files/all

Scripts: `scripts/` (PowerShell, no Python).

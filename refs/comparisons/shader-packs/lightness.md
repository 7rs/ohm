# Lightness (FPS cost) of the shader packs

Date of research: 2026-11-23. The first round (see `comparison.md`) gave performance weight 0 because it had only the authors' tags. This file adds the measurements that exist. Nothing was run on the ohm pack. Every number below comes from another machine, another Minecraft version or another loader, so only the relative order is usable, and even that is unverified for Minecraft 1.20.1 with Oculus 1.8.0.

## Source 1: The Mod Hunter (third party, 13 packs, one scene)

Minecraft 26.3 (Fabric), Iris 1.11.7, Sodium 0.9.2, Ryzen 9 3900X, RTX 4070 Ti SUPER, 1080p, render distance 16, OBS recording, every pack on its default settings (Sildur's Vibrant: Extreme profile). F3 read once a second, median after 2.5 s. Vanilla without Sodium: about 470 FPS. Pack versions: Complementary r5.9.3, BSL 10.1.8, Solas 3.8, Mellow 3.4.1a, MakeUp 9.6, Photon v1.4, Bliss 2.1.2, Noble 1.9.9, I Like Vanilla v1.5.0b.

| Pack | Median FPS | Range | Share of vanilla | In the pack |
| --- | --- | --- | --- | --- |
| Mellow | 151 | 144 to 152 | 32% | no |
| MakeUp - Ultra Fast | 96 | 94 to 99 | 20% | no |
| Complementary Reimagined | 92 | 86 to 95 | 20% | yes |
| I Like Vanilla | 91 | 87 to 92 | 19% | no |
| BSL | 90 | 87 to 92 | 19% | yes |
| Solas | 89 | 84 to 90 | 19% | no |
| Complementary Unbound | 88 | 85 to 89 | 19% | no |
| Sildur's Vibrant (Extreme) | 86 | 83 to 87 | 18% | no |
| Photon | 77 | 75 to 78 | 16% | no |
| Bliss | 75 | 74 to 76 | 16% | no |
| Noble | 67 | 62 to 69 | 14% | no |

Also in that test (not DH-gated, for scale): Miniature 158 and AstraLex 61. Reading: Mellow is the only DH-capable pack with a clear lead; MakeUp, Complementary, I Like Vanilla, BSL, Solas and Sildur's sit within 10 FPS of each other, which is about the size of the run-to-run range, so their order is not meaningful; Photon, Bliss and Noble are about 10 to 30% below that group. The same author measured Complementary Unbound with Distant Horizons 3.3.4 at 55 to 57 FPS against 110 to 120 without shaders (default HIGH profile, a driver cap of 120 FPS was in place).

Source: https://themodhunter.com/mods/minecraft-26-3-shader-packs-ranked/ (published 2026-11-13, updated 2026-11-19), https://themodhunter.com/mods/ultra-realistic-minecraft-26-3/

Correction (2026-11-23, found while adding the packs): Mellow's default has `DYNAMIC_SHADOWS` off, so its default shadows are lightmap based and no shadow map is drawn; the option's tooltip says "Performance impact: EXTREME". Mellow's 151 FPS is a figure without shadow-map shadows, which the other packs in the table draw by default (Complementary, BSL, Solas, Photon, Bliss, Noble, I Like Vanilla; MakeUp has a shadow option too). The lead of Mellow in this table is therefore not a like-for-like result, and "Mellow is the lightest" should not be read as "the lightest with real shadows". Its code does contain the shadow-map path, which is why it passed the feature gate.

## Source 2: VerveCode (third party, 3 packs)

Minecraft 26.3, Iris 1.11.7, Sodium 0.9.2, i7-12700, RTX 3070, 1080p, render distance 32, default settings, six F3 readings averaged. Shaders off 282 FPS; Complementary Reimagined r5.9.3 78; BSL 10.1.8 82; MakeUp 9.6 107.

Source: https://vervecode.dev/en/games/minecraft-iris-shaders/ (2026-11-12)

## Source 3: the I Like Vanilla author (one machine, profile ladders, with DH)

GTX 1070, 1080p, 16 chunks, Distant Horizons on, Fabulously Optimized, Linux. The author says "I'm not sure how trustworthy these results are" and makes a competing pack, so this is a measurement by an interested party. It is the only source that lists profiles, and the only one with Distant Horizons on.

| Pack | Lowest profile | Mid | High | Top |
| --- | --- | --- | --- | --- |
| MakeUp - Ultra Fast | 235 (No Effects) | 170 (Medium) | 163 (High) | 137 (Extreme) |
| BSL | 147 (Minimum) | 120 (Medium) | 106 (High) | 104 (Ultra) |
| Photon | 112 (Low) | 96 (Medium) | 90 (High) | 70 (Ultra) |
| Complementary Reimagined | 136 (Potato) | 86 (Medium) | 76 (High) | 41 (Ultra) |
| I Like Vanilla | 225 (Vanilla, Potato) | 120 (Vanilla, Medium) | 92 (Vanilla, High) | 79 (Vanilla, Ultra) |
| Sildur's Vibrant Extreme | 105 (default) | | | |

No shaders: more than 250. Complementary has the widest spread (Potato to Ultra is a factor of 3.3), BSL the narrowest (1.4). In this table BSL High (106) is 40% faster than Complementary Reimagined High (76), which Source 1 and 2 do not show (92 against 90, 78 against 82), so the BSL against Complementary order depends on the machine and settings.

Source: https://modrinth.com/shader/i-like-vanilla (description of the pack)

## Other evidence

- Bloop's own page has a table on a Ryzen 9 7900X integrated GPU (1080p, render distance 8): shaders off 180 FPS, Bloop Lowest 45 FPS, Low 40, Med Low 30, Medium 20. Shaders cost most of the frame rate on integrated graphics even at the lowest profile (only Bloop was measured).
- DERCODE's page: 100 to 130 FPS on a GTX 1650 laptop at 22 chunks on Minecraft 1.21.11 with Sodium and Iris (author statement).
- The TACZ 1.1.7-hotfix notes say TACZ with the Accelerated Rendering mod gains 2 to 3 times FPS "under ideal conditions", depending on shader settings. That mod was not found on Modrinth and was not checked.

## Packs with no measurement found (DH-capable, ranked)

Lumina Event Horizon (tags high/screenshot; the author lists a separate "Lumina Shader - Lite" for low-end PCs), Glimmer (tag low; presets Potato, Toaster, Integrated Graphics and Dedicated Graphics), Pegasus (potato to screenshot), Rethinking Voxels (medium/high/screenshot; an edit of Complementary Reimagined with colored-light shadows), Spooklementary, Spring (high), Aurora Fantasy (balanced profile asks for a GTX 1660), Bloop, E-LITE, Visual Vibrance (low), Hysteria, Vanilletix, ArtShade, Allium, Shrimple and the rest of `dh_ranking.md`. For these only the authors' tags exist, so they are Unverified for lightness.

## What it means for the pack

- Measured as lighter than the rest: Mellow (about 1.6 times the FPS of the group in Source 1).
- Measured as equal within noise: Complementary Reimagined, BSL, Solas, MakeUp, I Like Vanilla, Sildur's.
- Measured as heavier: Photon, Bliss, Noble.
- Complementary Reimagined scales down further than BSL through its profiles (Source 3), which suits a pack that ships both.
- None of the measurements used Oculus 1.8.0, Minecraft 1.20.1 or Embeddium. The ohm pack's own cost is unmeasured; `spark` or the F3 screen with each pack is the only valid test.

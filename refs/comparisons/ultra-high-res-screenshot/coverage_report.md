# Coverage report

Status: provisional. The skill's convergence test did not pass in full (see "Convergence"), so the result is not called exhaustive.

## Rounds and counts

| Round | Platforms and terms | New functional candidates (Forge 1.20.1, bigger capture) |
| --- | --- | --- |
| 1 | Modrinth API, 12 terms: screenshot, screenshots, high resolution screenshot, large screenshot, big screenshot, panorama, 360, hires, tiled, gigapixel, photo mode, camera | HiResShot, Forgeshot, Power Screenshot, Pixelshot, BigShot, Snapmatica (and borderline: Panoramica, Super Resolution, RenderScale, camera items) |
| 2 | Modrinth API, 37 more terms (hi-res, high-res, resolution, supersampling, 4k, 8k, 16k, poster, capture, screen capture, image export, photography, photo, cinematic, freecam, picture, snapshot, stitch, mosaic, ultra, wallpaper, print, framebuffer, render scale, upscale, downscale, screenshot size/resolution/upload/viewer/manager, better screenshots, screenshot plus); web searches (CurseForge, English, Japanese, Chinese); CurseForge widget for about 13 known slugs | Picture Mode (found by the web search, not by the first two rounds of Modrinth terms), ReForgedPlay, Recordium, Screenshot Plus (CurseForge), Nicephore |
| 3 | Modrinth API, 27 more terms (picture mode, screenshot filter/enhance/tool/mod, huge/ultra/super screenshot, screenshot scale/multiplier, render resolution, QDAA, anti-aliasing, SSAA, screen resolution, window size, replay, replay mod, reforgedplay, isometric, orthographic, cinematic camera, video recording, time lapse, timelapse, render frames); about 30 more CurseForge slug probes (guessed names); 2 web searches | none |

Totals: 76 Modrinth query files; 1,385 distinct projects returned (project type mod, no loader or version filter, so Fabric-only and old-version projects are in the ledger); 365 of them list Forge and 1.20.1; the keyword filter (`data/mr_merged.csv`) kept 829 relevant by text, 67 of those with Forge 1.20.1 under the strict screenshot terms. The query "camera" has 333 hits and only the first 300 were fetched. `products.csv` has 7 researched candidates, 4 baselines, 11 read by description or header, 14 exclusion rows (several rows group many projects).

## Convergence (skill Step 1.4, adapted)

- At least 3 rounds: yes. The last round added no functional candidate: yes.
- Two independent third-party inventories reconciled: no. Only the platforms' own search and web search were used. No retailer, modpack-index or wiki inventory was reconciled.
- Ledger larger than the seed list: yes (the seeds from memory were BigShot, Fabrishot, Mineshot, Panorama mods, Resolution Control).
- CurseForge was not crawled (search is behind Cloudflare). CurseForge-only projects can be missing; the ones found came from web search and slug guesses.

## Spot check

Three of the least familiar names from the search results were confirmed in the ledgers: PictureCam (`r05`), CameraCraft (`r06`), Snapmatica (`p07`). Wiki Zoomer (isometric blocks for wiki editors) was seen and judged out of function; it is not in `products.csv`.

## Evidence levels of the researched candidates (7)

| Level | What |
| --- | --- |
| Measured | release dates, file sizes, hashes, downloads (2026-11-25), repository commit counts, issue lists as shown by the platforms |
| Measured by reading | source and jar of all 7 (capture method, limit logic, defaults, keys, Mixin targets), the five shader pack zips, Oculus 1.8.0, DH 3.3.3, Embeddium 0.3.31, Punchy! 3.2b, vanilla 1.20.1 bytecode, FML 47.4.28 |
| Claimed | author pages (HiResShot's shader and VRAM statements, Fabrishot tooltip), the `Replay Mod breaks DH plus Iris` line on a third-party pack page |
| inference | what the code reading implies for Oculus and DH, memory estimates, behavior when a limit is exceeded |
| Not obtained | any run in the game: no capture, no GPU memory, no frame time, no image |

## Not enumerated or not checked

- CurseForge-only projects without a Modrinth page; mcmod.cn and other Chinese catalogues; GitHub code search for forks of Mineshot or Fabrishot for Forge.
- Whether the original Mineshot (ata4) has a 1.20.1 build; the Resolution Control forks' Forge builds (listings say Fabric only).
- Replay Mod ports (ReForgedPlay 0.3.1, Recordium): jars not read.
- QDAA (search snippet says cancelled), Upsczle, UpscaleCraft: render scaling, not read.
- The Codeberg tracker of Picture Mode; the text of HiResShot issue 1; Oculus issues 678, 679, 691.
- Server-list behavior of client-only mods that declare no `displayTest` (BigShot, Forgeshot, Snapmatica, Picture Mode) on a dedicated server without them.

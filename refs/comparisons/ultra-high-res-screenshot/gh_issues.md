# Third-party problem reports

Read on 2026-11-25 with WebFetch on the public issue pages (the GitHub API and `gh` were not available for repositories outside the session, and GitLab notes need a login: only issue titles and bodies were read for Distant Horizons). Report text is summarized; versions are the reporters'. None of these were reproduced.

## Reports that match this stack (shader pack, Distant Horizons)

| Project | Issue | State | Reporter's setup | Symptom | Maintainer |
| --- | --- | --- | --- | --- | --- |
| BigShot | [2](https://github.com/jaredlll08/bigshot/issues/2), 2023-12-27 | open | Fabric 1.20.2, Iris 1.6.14, Sodium 0.5.5, BigShot 2.0.5 | every screenshot black; three more users added "same" (2024-08, 2025-10, 2026-04) | no reply |
| BigShot | [5](https://github.com/jaredlll08/bigshot/issues/5), 2026-02-10 | open | Fabric 1.21.11, Iris, Sodium, Distant Horizons, pack not named | cropped image: a 1080p rectangle in the bottom-left corner; looked different per shader pack; fine with shaders off | no reply |
| Pixelshot | [2](https://github.com/Fuzss/pixelshot/issues/2), 2025-12-19 (duplicate: 4) | open | NeoForge 1.21.1, Sodium, Iris, Pixelshot 21.1.0, Puzzles Lib (Iris identified as the cause) | screenshots all blue (Fullscreen, Windowed, Huge, Panoramic) | Fuzs (2025-12-20): enable the tiled rendering option; reporter says it works for huge shots, not for panoramic. A user on Forge 1.20.1 with Pixelshot 20.1.0, Oculus and Embeddium (2026-05-26) says tiled did not help |
| Power Screenshot | [1](https://github.com/xkball/PanoramicScreenshot/issues/1), 2026-05-16 | open | Sodium plus extensions including Iris; versions not given | skybox/panorama images black; one reporter also saw a freeze | no reply |
| Snapmatica | [6](https://github.com/shuntilettuce/photographica/issues/6), 2026-11-23 | open | Fabric 1.21.1, Snapmatica 1.3.5, Distant Horizons 3.3.3 (and 3.3.2), Iris 1.8.14, Windows 11 | render thread freezes forever; thread dump in `DhApiTerrainDataRepo.getTerrainDataColumnArray` called from `DhIntegration.queryLookDistance`; also with shaders off | no reply |
| Distant Horizons | [850](https://gitlab.com/distant-horizons-team/distant-horizons/-/issues/850), 2024-10-26 | closed | NeoForge 1.21.1, DH 2.3.0 dev build, Photon, Iris 1.8.0 beta | after F11 or a window resize the LODs stop rendering until DH rendering is toggled | closed; fix version not read |

## Other reports of interest

- Pixelshot [6](https://github.com/Fuzss/pixelshot/issues/6) (open, Fabric 1.21.11): high-resolution shots use a different FOV than the game and chunk culling follows the game's FOV. Pixelshot [5](https://github.com/Fuzss/pixelshot/issues/5) (open): compatibility with Voxy (a LOD mod). Pixelshot 7 (closed 2026-09-02): crash on the next page of its settings screen.
- HiResShot: one issue, [1](https://github.com/DHJComical/HiResShot/issues/1) (closed 2026-02-10), "incompatibility with a super-resolution mod". Text not read.
- Forgeshot: no issues. Picture Mode: none on the GitHub mirror (its tracker is on Codeberg and was not readable).

## Searches that found nothing

- Distant Horizons GitLab issue search for "screenshot", "fabrishot", "bigshot", "high resolution": only unrelated hits (the Fabrishot hit #859 is a Bliss render report that lists Fabrishot in its mod list).
- Oculus (GitHub Asek3/Oculus) issues 678, 679, 691 came up in a web search for large framebuffers with Oculus; they were not read (678 is the out-of-memory report already in `refs/issues.md`).

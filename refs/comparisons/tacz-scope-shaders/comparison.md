# TACZ scopes with shader packs (Oculus 1.8.0, Forge 1.20.1)

Status: provisional. Research date: 2026-11-23. Nothing was run in the game. Decision: pending (the user decides whether to update TACZ).

## Problem

Installed: TACZ 1.1.8-hotfix2, LR Tactical 0.4.3, Oculus 1.8.0, Embeddium 0.3.31, Distant Horizons 3.3.3.

| Report | Status | What it says |
| --- | --- | --- |
| Oculus issue 797 (2025-04-15) | open, no reply | On Oculus 1.8.0 and Embeddium 0.3.31, a TACZ scoped weapon causes rendering errors at once. With Photon the game crashes after a few minutes; with BSL the errors stay until the shader is reloaded |
| TACZ issue 662 (2026-03-25) | open | Aiming through a scope with Distant Horizons and a shader pack (Bliss, Complementary) shows a black band or black screen; the scope pulls in the LOD geometry. Worse after toggling F11. Reloading the shader or toggling DH does not fix it for good. Reported on TACZ 1.1.7-hotfix2 |
| TACZ issue 755 (2026-10-11) | closed 2026-11-06 | Out-of-memory crash with TACZ and Hysteria Shaders on Oculus 1.8.0, TACZ 1.1.8-hotfix and hotfix2. A commenter traced it to TACZ rendering with Oculus "separate entity draws"; it did not reproduce with Photon. The TACZ developer said 1.2.0 overhauled some rendering methods and may fix it more fundamentally |
| Oculus issue 678 (2024-08-22) | closed | Photon plus a TACZ weapon, out-of-memory after about five minutes; the Oculus maintainer said it is not an Oculus bug |

## Candidates

| Candidate | Fixes the scope problem? | Evidence |
| --- | --- | --- |
| No mod, config only | No setting found. Turning DH on and off does not fix TACZ issue 662 | TACZ issue 662 |
| TACZ 1.2.0 (2026-11-06) and 1.2.0-hotfix (2026-11-15), Forge 1.20.1, no declared dependencies | Not confirmed. It adds VBO acceleration for third-person, dropped and displayed guns, new scope lens effects, a fix for flickering black spots on some scopes with lens effects (hotfix). The TACZ developer said it may address the cause of issue 755 (not confirmed by the reporter). Nobody has reported the DH scope band fixed or unfixed in 1.2.0 | TACZ changelogs, issue 755 |
| LR Tactical 0.4.4 (2026-11-09) | Not a fix. Its notes say "Requires TACZ 1.2.0", so a TACZ update needs this update too. The pack has 0.4.3 | Modrinth version list |
| TaCZ:Accel 1.3.0 (Forge 1.20.1, 36,419 downloads, 2026-10-13) | No. A performance add-on (GPU-resident gun geometry, scope geometry caching "while keeping TaCZ stencil behaviour"); its page says Iris and Oculus packs keep their own framebuffer handling. It does not mention the scope band | Modrinth page |
| TACZ PIP (shader-compatible picture-in-picture scopes) | Not for 1.20.1: its listing targets Minecraft 1.21.1 | Web search result of its CurseForge page; the Modrinth slug `tacz-pip` does not exist |
| [TaCZ] Optimization | No. Already rejected (see `refs/notes.md`): its mixin targets the 1.1.8 `BulletHoleParticle` | notes |
| CGC Compat: Shader | Not for TACZ. It serves Custom Gun Continued (a separate gun mod) | TACZ issue 755 comments |
| Shader Carry | Unrelated: fixes Carry On rendering with shaders (Fabric) | Modrinth page |

A Modrinth search of Forge 1.20.1 mods for "tacz shader", "tacz oculus", "tacz iris" and "timeless classics shader fix" returned no result; "tacz scope" returned only TACZ Scope Zeroing (a ballistics mod).

## Result

No mod fixes the scope problem. The closest thing is the TACZ update itself, together with LR Tactical 0.4.4. It is a content update (many guns, attachments, configuration and recipes) and the pack's `refs/notes.md` already records that a rejected add-on breaks on 1.2.x, so it needs a test world, not a blind update. Whether 1.2.0 clears issue 662 is not known; the only way to know is to test a scope with each shader pack and Distant Horizons on.

## Not done

- Nothing run. TACZ 1.2.0 was not installed in a test.
- The Oculus issue 797 reporter's Distant Horizons version is not stated, so whether DH 3.3.3 changes the result is unknown.
- CurseForge-only add-ons were not enumerated.

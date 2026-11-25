# Third-party reports (GitHub), 2026-11-24

Source: GitHub issue search (anonymous, per repository and keyword) and reading of single issues. Raw output: `gh_raw_search.txt` and `gh_raw_issues.txt`. A search hit only means the word appears; the issues below were read. Reports are claims by the reporters. Nothing was reproduced.

Repository activity (2026-11-24): Valkyrien Skies 329 open issues and pull requests, last push 2026-11-22; Steam 'n' Rails 49, 2026-08-27; Immersive Aircraft 11, 2026-11-02; Man of Many Planes 0, 2026-10-10; Immersive Vehicles 101, 2026-11-23; Small Ships 26, 2026-10-16.

## Valkyrien Skies (ValkyrienSkies/Valkyrien-Skies-2)

| Issue | State | What it says | Fit with the pack |
| --- | --- | --- | --- |
| 1896 | open | With Distant Horizons 3.0 and an Oculus shader pack (tested on a VS 2.5.0 playtest jar), ships are not drawn beyond a distance, whatever the ship load distance | The pack has Distant Horizons 3.3.3, Oculus and shader packs |
| 1300 | open | Ships are partly invisible with Distant Horizons because of LOD fade; VS would need to declare ships through Distant Horizons' render API | Same |
| 1534 | open | Create shafts are invisible on assembled ships (Forge 1.20.x, only VS and add-ons); a comment says use Embeddium instead of Xenon; last comment 2026-11-22: not reproducible on the latest playtest, "fixed" | Create 6.0.8 and Embeddium are installed; the fix is in a playtest build |
| 1112 | open | Parts of a very large ship are invisible until relog (not tied to Sodium or Embeddium) | Fixed in the 2.5 playtests according to a commenter |
| 1929 | closed | A player is thrown around while using a Eureka helm. A maintainer: "we've encountered this issue before and believe it's a mod conflict. Can you try without entity culling and immersive optimisations?" The reporter removed both with no change; closed as not reproducible | Entity Culling and Immersive Optimization are installed |
| 1980 | closed | Block entities render with wrong transforms (VS, Clockwork, Trackwork, Create, Embeddium, Oculus; Forge 47.4.13); the cause is Litematica's renderer | Litematica not installed |
| 728 | closed | Block entities do not render on ships with Embeddium (1.18.2, Embeddium 0.2.5 or newer); a maintainer cannot reproduce on the newest Embeddium and Oculus | Embeddium 0.3.31 |
| 913, 986 | closed | Crashes with Distant Horizons (VS 2.3 beta, 2024) or an unrelated mod (Puzzle); described as fixed | Old |
| 1744 | open pull request | Says some compat code for other mods does not work and ships do not render correctly with Sodium on a 1.21 branch | Unclear for 1.20.1 |

## Create: Steam 'n' Rails (Layers-of-Railways/Railway)

| Issue | State | What it says | Fit with the pack |
| --- | --- | --- | --- |
| 768 | open | With Flywheel's `instancing` backend and many cased tracks, severe FPS drop; `indirect` is smooth; a commenter blames cased tracks building a new model every time and offers a patch | Create 6.0.8 and Flywheel 1.0.5 are installed; Colorwheel changes the Flywheel pipeline |
| 740 | closed | Tracks placed before 1.7.0 were not recognized because of a data fixer; restore from a backup; fixed in the release | The pack has no world with them yet |
| 752 | open | Snow turns a wide tieless track into random blocks; cannot reproduce | Create 6.0.8, Flywheel 1.0.5 |
| 727 | closed | POM shader glitch on the boiler with Bliss and Pegasus (BSL is also in the screenshots); turning POM off in either fixes it; the maintainer sends it to the shader authors | A shader-pack matter |
| 712 | closed | The game closed at startup with Steam 'n' Rails 1.6.7 and Create 6.0.7; 1.6.14 added support for Create 6.0.7 and 6.0.8 | Old |

## Immersive Aircraft (Luke100000/ImmersiveAircraft)

| Issue | State | What it says | Fit with the pack |
| --- | --- | --- | --- |
| 246 | closed | Other players are disconnected when an aircraft is placed on a server; tied to the add-on "Better Engines" | Add-on not installed |
| 329 | closed | Many tries are needed to mount an aircraft (version 1.4.0, Forge 47.4.10, with Valkyrien Skies and Create); no cause stated | Version 1.5.0 is newer |
| 111 | closed | "Distant aircrafts?" (2024) | Distant Horizons is installed |

## Immersive Vehicles (DonBruce64/MinecraftTransportSimulator)

| Issue | State | What it says | Fit with the pack |
| --- | --- | --- | --- |
| 2008 | closed | Crash with OptiFine or its replacements (Oculus too); the author: bad texture-loading return calls, fix on his Discord | Version not stated |
| 1980 | closed | PBR reflections of a shader pack turned off with Embeddium 0.3.31 and Oculus 1.8.0 on 1.20.1; the author: addressed in 23.0.0 | Same Embeddium and Oculus as the pack |
| 2159 | open | Instruments break with shaders (two of three render modes); "Missing program mts:mts/entity_translucent" in Iris; the author: shaders are hard with this rendering, the slow mode should be shader-compatible. Reported on a NeoForge 26.1 build 25.0.0 | Not this build, same renderer family |
| 2185 | open | A dedicated server fails to load (IV 22.18.0, Forge 47.4.18): client class `PoseStack` on the server; a commenter suspects a mod that alters the renderer (the author asks about Sodium); unconfirmed | Pack is also run as a server |
| 2194 | closed | Could not join a server; cause: a content pack version differed between client and server | Keep pack versions equal |
| 2265 | open pull request | Mobs' damage to vehicles scaled by vehicle health; TaCZ bullets did not damage vehicles and are patched in it | TaCZ is installed |

## Small Ships (talhanation/smallships)

| Issue | State | What it says | Fit with the pack |
| --- | --- | --- | --- |
| 54 | open | Forge 1.20.1, Small Ships 2.0: with Shoulder Surfing's "replace default perspective" on, the ship's third-person view is Shoulder Surfing's and the scroll wheel does not zoom | Shoulder Surfing Reloaded is installed |
| 57 | open | NeoForge 1.21.1, 2.0.1: startup crash because two mods `@Redirect` `Camera.setPosition` | The 1.20.1 jar uses `@WrapOperation` there; the other mod is not installed |
| 47 | open | The Bamboo Galley is uncraftable (2025-10) | Minor |

## Shoulder Surfing Reloaded (Exopandora/ShoulderSurfing)

- 477 (closed, 2026-10-05): "Incompatible with Small Ships". The maintainer says it should be a compatibility plugin by Small Ships using the Shoulder Surfing API (`ComputeTargetCameraOffsetEvent`) and sends the reporter to Small Ships' tracker (their #54).

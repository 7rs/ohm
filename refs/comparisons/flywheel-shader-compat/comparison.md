# Iris & Oculus Flywheel Compat against Colorwheel (Forge 1.20.1)

Status: provisional. Research date: 2026-11-23. Nothing was run in the game; every behavior below comes from the platform data and the existing notes.

Decision: pending (user). The earlier rule in `refs/notes.md` ("never add Iris & Oculus Flywheel Compat") stands on this evidence.

## Scope

Mods that keep Flywheel (bundled in Create 6) running under Oculus shader packs. Candidate: Iris & Oculus Flywheel Compat. Installed: Colorwheel. Create is not installed yet. Modrinth searches were not repeated; the candidate was named by the user. Ocuwheel was already checked on 2026-11-22 (see `refs/notes.md`).

Criteria: download count and release date (Measured), declared incompatibility (Measured, Modrinth dependency data of the pinned Colorwheel version).

## Headline

Not needed, and it cannot be installed with Colorwheel. The pinned Colorwheel version (`colorwheel-forge-1.3.2+mc1.20.1`) lists Iris & Oculus Flywheel Compat as `incompatible` in its Modrinth dependency data (checked 2026-11-23), and the existing notes record the same declaration in its `mods.toml`.

## Facts

| | Iris & Oculus Flywheel Compat | Colorwheel (installed) |
| --- | --- | --- |
| Downloads, Modrinth (all versions) | 4,538,237 | not collected |
| Downloads, Modrinth (Forge 1.20.1 files) | 1,274,893 (11 files) | not collected |
| Latest Forge 1.20.1 release | 2.0.3, 2025-06-25 | 1.3.2+mc1.20.1 (pinned) |
| Side (Modrinth) | client required, server unsupported | client |
| Relation | Declared incompatible by Colorwheel | Declares the incompatibility |

## Observations for this pack

- Create is not installed, so neither mod has anything to do yet (see `refs/notes.md`).

## Coverage

- Evidence levels: downloads and dates Measured, incompatibility Measured (platform data). The jars were not read in this pass.

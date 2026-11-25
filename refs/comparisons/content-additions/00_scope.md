# Scope: content additions proposed on 2026-11-24

Date of research: 2026-11-24. Nothing was added. The decision is the user's.

## Candidates

The user pasted 19 Modrinth projects and asked whether adding them is a good idea, suspecting that some of the features already exist in the pack.

| Group | Candidates |
| --- | --- |
| Change | Almost Unify Everything, Vanilla Backport |
| Graphics | Spawn Animations (listed as a data pack), 3D Skin Layers |
| Item/Mob | Zombie Awareness, End Remastered, True Ending (listed as a data pack), Cracker's Wither Storm Mod, Deeper and Darker |
| Concepts | Waystones, Ice and Fire, Touhou Little Maid |
| Engineering | Mekanism, Mekanism Generators, Create Crafts & Additions, Applied Energistics 2 |
| Magic | Iron's Spells 'n Spellbooks, Ars Nouveau, Botania |

Added during the research: Almost Unified (the base mod of Almost Unify Everything), Ice and Fire Community Edition (a maintained 1.20.1 Forge fork of Ice and Fire), and every required library found in the jars.

## Goal

Decide, per candidate, whether it can join the pack ohm (Minecraft 1.20.1, Forge 47.4.28) and what it needs: libraries, settings, and decisions from the user. The user gave no optimization angle; these are content mods.

## Comparison type

Fit review, not a market comparison. The candidates are mostly different features, so there is little to rank against each other. Alternatives were only checked where a candidate overlaps an installed mod or another candidate (Vanilla Backport and Bedrockoid, Ice and Fire and its fork, the three magic mods). "No mod" is the baseline for every candidate.

## Criteria

| Criterion | Evidence level |
| --- | --- |
| Forge 1.20.1 build, release channel, date, downloads, side, dependencies (Modrinth API, fetched 2026-11-24) | Measured |
| Required dependencies and platform ranges (`mods.toml` of the downloaded jars) | Measured by reading |
| Mixin conflicts against the 91 installed mods: class, method and, for `@Redirect` and `@ModifyConstant`, the same `@At` target (`scripts/scan.ts`, `scripts/conflicts3.ts`) | Measured by reading; not run |
| Feature overlap with installed mods (jar contents: language files, data files) | Measured by reading |
| Reported problems with Oculus, Embeddium or Distant Horizons (GitHub issue search, Distant Horizons wiki) | Claimed by third parties |

No weights or scores. The result is a fact table plus a conditional recommendation.

## Hard constraints

- A Forge build for Minecraft 1.20.1 must exist (project rule). All candidates have one.
- Libraries are installed only when a mod requires them (project rule).

## What was not done

- Nothing was run in the game, so every result below is a static reading. `refs/issues.md` records that no FPS or TPS has been measured for the pack.
- The six CurseForge installed jars were scanned (their CDN links worked); nested Jar-in-Jar jars were scanned two levels deep.
- Mixin scanning finds conflicts on the same method and the same hooked call. It does not find behavior conflicts (two mods changing the same mob), registry clashes, or world-generation overlaps.
- Config keys were not read except where noted. Default values of the candidates are unverified.
- Server load (TPS) was not measured.
- Alternatives to Mekanism, AE2, Waystones and the other single-purpose mods were not enumerated.

## Scripts

`scripts/` holds the PowerShell and Bun scripts used (`fflate` is installed with `bun add fflate` next to `scan.ts`). Downloaded jars were not kept.

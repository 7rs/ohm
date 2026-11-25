# Redirected against Harium's `enum_values` mixins (Forge 1.20.1)

Status: provisional. Research date: 2026-11-23. Nothing was run in the game; every behavior below comes from reading the jars and the platform pages. This re-checks the 2026-11-22 note "Redirected overlaps Harium's `enum_values` mixins" (`refs/notes.md`).

Decision: pending (user). The earlier decision, not to add, stands on this evidence.

## Scope

Mods that cut memory allocation by replacing `Enum.values()` array clones with shared arrays. Candidate: Redirected. Installed: Harium (a Lithium port) with `alloc.enum_values`. Modrinth searches were not repeated for this topic; the candidate was named by the user. CurseForge was not enumerated. Redirected is a port of Redirector (CurseForge, not enumerated).

Criteria: download count and release dates (Measured), mixin targets read from both jars (Measured by reading). No weights; no score.

## Headline

Redirected covers far more sites than Harium (more than 100 per its description), but on at least two methods both mods redirect the same `Direction.values()` call. Two redirects on one call site do not both apply. Harium sets `defaultRequire = 1`, so it fails hard if Redirected is applied first; Redirected sets no require and would be skipped quietly in the other order. The result depends on load order. Do not add it beside Harium without a test.

## Fact table

| | Redirected | Harium (installed) |
| --- | --- | --- |
| Downloads, Modrinth (all versions) | 5,887,957 | not collected |
| Downloads, Modrinth (Forge 1.20.1 files) | 2,839,774 (1 file) | not collected |
| Latest Forge 1.20.1 release | forge-1.20.1-1.0.0, 2025-02-02 | 2.0, 2026-08-20 |
| Repository | txnimc/Redirected, 2 stars, last commit 2025-02-09 | JustHari01/Harium |
| Required libraries | TxniLib (not installed) | none |
| Side (Modrinth) | client and server required | not collected |

## Source, read

- Redirected (jar forge-1.20.1-1.0.0, `required = false`, no `defaultRequire`): a mixin plugin whose only special case is a mod named `sculkhorde`. It redirects `Direction.values()` to a shared array in `PistonStructureResolver.addBranchingBlocks`, `PistonBaseBlock.getNeighborSignal` and `RedStoneWireBlock.checkCornerChangeAt`, among many other classes.
- Harium (jar 2.0, `defaultRequire = 1`): four mixins under `alloc.enum_values`: `LivingEntityMixin`, `PistonBlockMixin` (`shouldExtend`), `PistonHandlerMixin` (`tryMoveAdjacentBlock`), `RedstoneWireBlockMixin` (`update`, `updateNeighbors`). They use Yarn method names that the refmap maps.
- Both mods use a handler that returns the replacement array at the `INVOKE` of `Direction.values()`. That is the shape of a `@Redirect`; the annotation line itself was filtered out of my read, so the type is inferred.
- The piston pair matches the Mojang names above (`shouldExtend` is `getNeighborSignal`, `tryMoveAdjacentBlock` is `addBranchingBlocks`). That name match comes from my knowledge of the mappings, not from the jar.

## Observations for this pack

- No config-only fix was verified. A possible path is switching off Harium's `enum_values` group in its config; whether Harium exposes it was not checked.
- `refs/issues.md` already records that Harium's redstone mixin stays at default beside Alternate Current.

## Excluded

None.

## Coverage

- One candidate against one installed mod. Redirector (the original) was not read.
- Evidence levels: downloads and dates Measured, mixin targets Measured by reading, name mapping inferred.

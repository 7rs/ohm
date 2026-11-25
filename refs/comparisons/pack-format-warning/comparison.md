# Mods that hide the incompatible resource pack warning (Forge 1.20.1)

Status: provisional. Research date: 2026-11-23. Nothing was run in the game; every behavior below comes from reading the jars, the 1.20.1 client jar and the platform pages.

Decision: pending (user). Nothing was added.

## Scope

Forge 1.20.1 client mods that remove the "made for an older/newer version of Minecraft" label, the red border and the confirm dialog of the resource pack screen. Modrinth searches (Forge, 1.20.1): `pack format`, `incompatible pack`, `resource pack warning`, `pack compatibility`, `pack version`. CurseForge was not enumerated.

Why it matters here: Minecraft 1.20.1 reads only `pack_format` (the `PackMetadataSection` in the client jar has no `supported_formats`) and compares it with 15. Iron Girl (32) counts as too new, and Melody's Villagers, Witches, Illagers and Traders (10) count as too old. Fresh Animations (15), Piglin-Chan (15) and Fluid & Foolish (15) are compatible.

Criteria: download count, release date, repository activity (Measured); mixin targets read from the jars (Measured by reading). No weights; no score.

Baseline without a mod: list the packs in `incompatibleResourcePacks` of `options.txt`. This is what the pack ships now (see `refs/settings.md`). The game keeps them enabled, but the red label and the confirm dialog stay in the pack screen. `Options.loadSelectedResourcePacks` removes an incompatible pack from the list at load unless it is listed there (strings in the client jar: "Removed resource pack {} from options because it is no longer compatible").

## Headline

Two mods exist and both work through a single idea (treat the pack as compatible). Neither is needed for the packs to be enabled at first launch. They only remove the warnings. NoPackCompatCheck is the more global, simpler hook and more recent; No Resource Pack Warnings (Forge port) is more downloaded but its 1.20.1 build is from 2023-12 and redirects four call sites.

## Fact table

| | NoPackCompatCheck | No Resource Pack Warnings (Forge port) |
| --- | --- | --- |
| Downloads, Modrinth (all versions) | 632,911 | 1,486,823 |
| Latest Forge 1.20.1 release | v0.1.0-forge-mc1.20.1, 2025-08-13 | 1.0.0, 2023-12-27 |
| Project last updated | 2026-07-22 | 2026-04-13 |
| Repository | Wudji/NoPackCompatCheck, last push 2026-07-23, 0 stars, 0 open issues | 1foxy2/no_resource_pack_warnings_forge, last push 2026-04-13, 0 stars, 0 open issues |
| Side | client | client |
| Dependencies | none (MixinExtras bundled by Jar-in-Jar) | none |
| Mixins | `MixinPackCompatibility`: a return-value hook on `PackCompatibility.isCompatible()`, so it is always true | `OptionsMixin` (redirects `isCompatible()` in `updateResourcePacks` and `loadSelectedResourcePacks`), `PackEntryMixin` (redirects it in `render` and `handlePackSelection`) |
| Reach | Every caller, including data pack screens in single-player | The options load and the pack list screen |
| Evidence of the effect | author's description | author's description |

## Observations for this pack

- 0Pack2Reload (installed) mixes into `Options.updateResourcePacks` at the head and calls `isCompatible()` itself. A return-value hook covers that call too; a redirect inside the vanilla method does not. Not run.
- No installed mod mixes into `PackCompatibility`, `TransferableSelectionList`, `PackSelectionScreen` or `PackSelectionModel` except 0Pack2Reload.
- If either mod is added, `incompatibleResourcePacks` should be removed from `options.txt`. In the vanilla code a pack that is both in that list and now compatible is dropped from the selection once ("Removed resource pack ... from incompatibility list because it's now compatible"). Read from the client jar strings; the branch order was not verified.

## Excluded

| Mod | Reason |
| --- | --- |
| Version (API pack) | A library for the running version and pack format; no warning handling |
| Modpacks and data packs matched by the searches | Not related |

## Coverage

- Market from Modrinth only. Two candidates were found.
- Evidence levels: downloads and dates Measured, mixin targets Measured by reading, effect Claimed.

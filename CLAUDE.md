# ohm

## About

In this project, we maintain a Packwiz modpack named ohm.

- Use MC Java Edition 1.20.1.
- Use Forge 47.4.28.
- Assume using Packwiz to build the modpack.
- Assume using PrismLauncher on the client.
- Assume using Packwiz to install the modpack on the server.
- Assume distributing the modpack as `.mrpack`.
- Use Default Options to apply first-launch client defaults.

## Structure

- `pack.toml`: Pack definition. Forge and Minecraft versions live here.
- `index.toml`: Generated. Do not edit by hand.
- `mods/*.pw.toml`: One metafile per mod. The file name is the project slug.
- `resourcepacks/*.pw.toml`: One metafile per resource pack. Enabled at first launch through the `resourcePacks` key of `config/defaultoptions/options.txt`. The key holds the file name, so update it when `packwiz update` changes a resource pack's file name. Minecraft 1.20.1 reads only `pack_format`: a pack whose value is not 15 must also be listed in `incompatibleResourcePacks`, or the game removes it from the list at load.
- `shaderpacks/*.pw.toml`: One metafile per shader pack. packwiz marks them `both` because Modrinth lists their environment as unknown, so set `side = "client"` by hand. No shader pack is selected at first launch: `config/defaultoptions/extra/config/oculus.properties` has no `shaderPack` key. A pinned pack (`pin = true`) stays on its version through `packwiz update`.
- `README.md`: Human-facing overview and the Mod List with links and badges. Not distributed.
- `.packwizignore`: Files excluded from the index. Required so CLAUDE.md, README.md and `refs/` are not distributed.
- `refs/`: Reference files for Claude (`list.md`, `issues.md`, `notes.md`, `settings.md`, `comparisons/`). See References.
- `config/`: Mod configs shipped as-is. They overwrite the player's files on every pack update.
- `config/defaultoptions/`: Default Options data (`options.txt`, `keybindings.txt`, `servers.dat`). Applied only when the target file does not exist.
- `config/defaultoptions/extra/`: Any file here is copied to the game directory at first launch, keeping its relative path. `extra/config/X.toml` becomes `config/X.toml`. Existing files are never overwritten.
- `defaultconfigs/`: Defaults for per-world server configs (the world's `serverconfig/<modid>-server.toml`, Forge config type SERVER). When a world has no such file, Forge copies it from here (`defaultConfigPath` in `config/fml.toml` is `defaultconfigs`). It applies to new worlds only: an existing world keeps its own file.

## Rules

- Put settings that players may change (client-only mods, video) under `config/defaultoptions/extra/config/`. Put settings that must be enforced (server-side or gameplay) directly under `config/`. Put per-world server settings (the mod writes them to `serverconfig/`, not `config/`) under `defaultconfigs/`.
- Never put `options.txt` or `servers.dat` in the pack root. Use `config/defaultoptions/`.
- Add only shader packs that support Distant Horizons (the zip has `dh_*` programs). Distant Horizons is installed and draws its LODs only with such packs. This is the user's rule (2026-11-23).
- Write only the keys that differ from the mod's defaults. Do not ship hardware-dependent values such as thread counts.
- When any definition in this project changes, record it in this CLAUDE.md in the same change. This covers the Minecraft or Forge version, the structure, the commands and the rules. Keep `refs/list.md` and the Mod List in `README.md` in sync with `mods/`, `resourcepacks/` and `shaderpacks/`, and `refs/settings.md` in sync with `config/`.
- When a problem with an installed mod is found or resolved, update `refs/issues.md`.
- When a mod is removed, remove its entries from `refs/issues.md`, `refs/list.md`, `README.md` and `refs/settings.md`.

## References

Long reference files live under `refs/`. They are excluded from the index and are not distributed. Read them only when the task needs them.

- `refs/list.md`: Mod tables by category (Name, Slug, Source, Repository). Slug is the metafile name, Source is `modrinth` or `curseforge`. It has no icons, links or dates: those live in `README.md`. Read it when adding, removing or looking up a mod.
- `refs/issues.md`: Known problems of installed mods with a status (`open`, `unverified`, `by design`, `resolved`). Read it before changing a mod or its settings.
- `refs/notes.md`: Per-mod decisions and constraints by topic (key binding, Punchy, viewer/info/camera, recipe/worldgen/Create/weather, optimization): why a mod is installed, what must not be added beside it, and what was checked and rejected. Read it before adding, removing or replacing a mod.
- `refs/settings.md`: Shipped settings. Vanilla (`options.txt`) and each mod have their own section, with a table of Key, Value and Reason per file. Launcher-only items sit at the end. Read it before changing a setting.
- `refs/comparisons/<topic>/`: Evidence files of a comparison between similar mods (`comparison.md` is the result; scope, ledgers, sources and coverage sit beside it). Read the folder before adding a mod for that topic.

## Mod Addition

Follow both steps in order. The second needs the first to be done.

### Before Adding a Mod: Comparison and Review

A mod is never added blindly, without a plan, without evidence, or on a shallow reason. Compare and review it first.

- Compare the candidate with similar mods. Include "no mod" (a config-only fix, if one exists) as a candidate.
- Compare at least:
  - Function: the author's description and the actual source code or jar. The description alone is not enough.
  - Future: maintenance status, release activity and direction.
  - Download counts.
  - Forge 1.20.1 build, required dependencies, and conflicts with installed mods.
- Use the `comparison` skill. Keep the documents in `refs/comparisons/<topic>/`.
- Read `refs/notes.md` and `refs/issues.md` first: they hold known conflicts and mods that must not be added.
- Discuss the result with the user. Never add a mod without the user's approval: present the comparison and wait for the answer. This also applies when a mod is the only way to fulfil a request.
- There is no exception. Do this even when the prompt does not ask for it, in the background of the task. The only case that skips it is when it was already done: a comparison in `refs/comparisons/` that covers the candidate.

### Adding a Mod

Needs the comparison and review above to be done.

- Source: Modrinth first, CurseForge second. Use CurseForge when:
  - CurseForge has a newer release than Modrinth (it releases more often).
  - The mod is not released on Modrinth.
  - Modrinth has a project of the same name, but it is a different thing, or its release does not meet the requirements.
- Version: the latest in principle. Check the requirements of the installed mods, including conflicts, and pick the right version. Stable operation first, the latest version second.
- Loader: every mod file must be a Forge build for 1.20.1. A Fabric or Quilt jar has no `mods.toml` and does not load on its own.
- Dependencies: packwiz should resolve them, but it may not do so properly. Confirm that every dependency was installed correctly. This covers resource packs too. Enable a resource pack at first launch.
  - Install a dependency library only when a mod requires it. Remove it together with the last mod that needs it.
- Settings: confirm that the shipped settings achieve the purpose of the mod. Some mods disable their main feature by default. Enable it in the shipped settings then. Where settings live: see Rules.
- Side: set `side = "client"` in the metafile for client-only mods. Use `both` otherwise. Get both the client and the server right. Check the jar, because the platform's environment data can be `unknown` or wrong.
- After adding or removing a mod, run `packwiz refresh` to update `index.toml`.
- When the setup is done, record it:
  - Problems and open questions found so far: `refs/issues.md`.
  - The mod: `refs/list.md` and the Mod List in `README.md` (Modrinth, CurseForge and repository links, last commit badge).
  - Shipped settings: `refs/settings.md`.
  - Decisions and constraints (what to avoid beside it): `refs/notes.md`.

## Commands

- Add a mod (Modrinth first, CurseForge otherwise)
  - `packwiz modrinth add <URL>`
  - `packwiz curseforge add <URL>`
- Remove a mod: `packwiz remove <slug>`
- After editing a metafile by hand: `packwiz refresh`
- Update: `packwiz update <slug>` / `packwiz update --all`
- Export: `packwiz modrinth export`

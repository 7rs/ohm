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
- `README.md`: Human-facing introduction and install and update guide. Under the title it says why to play it (what the pack changes, and its fast, convenient and beautiful points, each label with an emoji, with no mod names and no requirements, then a pointer to the Mod List), and closes that part with a collapsed table of contents. Then come Installation (Build modpack, Install on your PC with Prism Launcher, Install on your server), Benchmark and Contributing (one short section each that explains and links `docs/benchmark.md`, `docs/benchmark-mods.md` and `CONTRIBUTING.md`), and Update (modpack, PC, server). The table of contents holds section links only, no link to another file. Not distributed.
- `CONTRIBUTING.md`: Branch, pull request and merge rules for maintainers. Not distributed.
- `docs/modlist.md`: The Mod List with links and badges. Linked from `README.md`. Not distributed. Columns: Name, Links (Modrinth, CurseForge and repository), Last Updated, Links (official site and wikis). The right-hand Links column holds no repository page, because the left one has it. It has at most one `Site` and as many wiki or documentation links as exist, each labeled by what it is: `Official Wiki` and `Official Docs` (run or linked by the author; a GitHub Wiki counts, a README or a file in the repository does not), `Fandom Wiki`, `wiki.gg Wiki`, `Miraheze Wiki`, `FTB Wiki`, `Minecraft Japan Wiki`, or the wiki's own name. A wiki need not be official, but a modpack's own wiki does not count. `-` means none was found.
- `docs/benchmark.md`, `docs/benchmark-mods.md`: Human procedures to profile and benchmark the pack: the common method, then one mod from a clean Forge instance, overlap tests and the scene each optimization mod needs. They hold no results. Linked from `README.md`. Not distributed. Results of a run go to `refs/` (see the Run record in `docs/benchmark.md`).
- `.github/`: `workflows/build-mrpack.yml` checks the index and builds the pack with `packwiz modrinth export` and `packwiz curseforge export`. It runs on every pull request with no `paths:` filter, because `main` requires its checks and a skipped workflow leaves them pending forever. `rulesets/*.json` are the GitHub rulesets of `main` and `dev`, importable under Settings > Rules > Rulesets. Not distributed.
- `.editorconfig`: Editor settings for files edited by hand (UTF-8, LF, final newline, 2 spaces). `config/` and `defaultconfigs/` are unset, because mods write those files and an editor must not reformat them (the bytes feed the `index.toml` hash). Not distributed.
- `.gitattributes`: `* text=auto eol=lf` keeps the working tree in LF on every OS. Without it Git on Windows (`core.autocrlf=true`) checks files out as CRLF, packwiz hashes those bytes, and `packwiz refresh` disagrees with CI. packwiz excludes it from the index by default. Not distributed.
- `.githooks/pre-commit`: Warning-only checks before a commit. It never blocks a commit and always exits 0. One POSIX `sh` file, because Git runs hooks through `sh` on every OS (Git for Windows ships it). Enable it once per clone: `git config core.hooksPath .githooks`. It warns when:
  - A metafile is added or removed, but `refs/list.md` or `docs/modlist.md` is not staged, `refs/list.md` and the metafiles disagree on slugs, or `docs/modlist.md` has no link (or still has one) for the slug.
  - A shader pack is not `side = "client"`.
  - `mods/`, `resourcepacks/`, `shaderpacks/`, `config/`, `defaultconfigs/` or `.packwizignore` changed, but `packwiz refresh` gives an `index.toml` or `pack.toml` different from the staged one.
  - `config/` or `defaultconfigs/` changed, but `refs/settings.md` is not staged.
  - A staged `.json` under `config/` or `defaultconfigs/` is not valid JSON (checked with `jq`, or PowerShell on Windows; skipped when neither exists).
  - `.github/`, `.githooks/`, `.claude/`, `.editorconfig`, `.gitattributes` or `.packwizignore` changed, but `CLAUDE.md` is not staged.
  Not distributed.
- `.claude/agents/*.md`: Claude Code subagents, one file per agent, both on `model: sonnet`. `mod-researcher` does the comparison and review before a mod is added and returns a recommendation: it loads the `anthropic-skills:comparison` skill, holds the project's adaptations of it, writes only under `refs/comparisons/<topic>/` and never adds anything. `update-reviewer` reviews the working tree after `packwiz update` and reports risks and follow-up edits: it is read-only. Not distributed.
- `.packwizignore`: Files excluded from the index. Required so CLAUDE.md, README.md, CONTRIBUTING.md, `.editorconfig`, `.claude/`, `.githooks/`, `.github/`, `docs/` and `refs/` are not distributed.
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
- Follow `CONTRIBUTING.md` for branches. Never push to `main` and never branch from it. Cut one `add/`, `update/`, `config/`, `ci/` or `feat/` branch per topic from `dev` and merge it into `dev` by pull request. GitHub proposes `main` as the base of a pull request: change it to `dev`. Name every branch `<prefix>/<short-kebab-case-name>`. Never commit to or push a branch named `ccr-*`: if a cloud session starts on one for a topic, rename it with `git branch -m` before the first commit and push (the session cannot delete a pushed branch, so a pushed `ccr-*` stays on the remote). A cloud session branch is a topic branch too: base it on `dev`, and if it was cut from `main`, reset it to `dev` before the first commit. Do not reuse a branch for a second topic: cut a new one from `dev`. When the branch rules change, update `CONTRIBUTING.md` and `.github/rulesets/` together.
- Push to `dev` directly, without a topic branch, for a documentation-only change and for syncing `dev` with `main` after a release. A change is documentation-only when it touches only `README.md`, `CONTRIBUTING.md`, `CLAUDE.md`, `docs/` or `refs/`: a change to this CLAUDE.md alone needs no branch. Documentation that belongs to a topic (for example `refs/list.md` and `docs/modlist.md` for an added mod) goes in that topic's branch. If a cloud session starts on a `ccr-*` branch, do not rename it for a documentation-only change: switch to `dev`, bring it up to date with `origin/dev`, then commit and push `dev`.
- When any definition in this project changes, record it in this CLAUDE.md in the same change. This covers the Minecraft or Forge version, the structure, the commands and the rules. Keep `refs/list.md` and the Mod List in `docs/modlist.md` in sync with `mods/`, `resourcepacks/` and `shaderpacks/`, and `refs/settings.md` in sync with `config/`.
- When a rule that `.githooks/pre-commit` checks changes (the files that go together, the sync of `refs/list.md` and `docs/modlist.md`, the shader pack side), change the hook and the list under `.githooks/pre-commit` in Structure, and the table in `CONTRIBUTING.md`, in the same change.
- When a problem with an installed mod is found or resolved, update `refs/issues.md`.
- When a mod is removed, remove its entries from `refs/issues.md`, `refs/list.md`, `docs/modlist.md` and `refs/settings.md`.
- When a comparison is added, or the user decides on one (add, hold, reject), update `refs/comparisons/index.md` and the matching section of `refs/notes.md` in the same change.

## References

Long reference files live under `refs/`. They are excluded from the index and are not distributed. Read them only when the task needs them.

- `refs/list.md`: Mod tables by category (Name, Slug, Source, Repository). Slug is the metafile name, Source is `modrinth` or `curseforge`. It has no icons, links or dates: those live in `docs/modlist.md`. Read it when adding, removing or looking up a mod.
- `refs/issues.md`: Known problems of installed mods with a status (`open`, `unverified`, `by design`, `resolved`). Read it before changing a mod or its settings.
- `refs/notes.md`: Per-mod decisions and constraints by topic (key binding, Punchy, viewer/info/camera, recipe/worldgen/Create/weather, optimization): why a mod is installed, what must not be added beside it, and what was checked and rejected. Read it before adding, removing or replacing a mod.
- `refs/settings.md`: Shipped settings. Vanilla (`options.txt`) and each mod have their own section, with a table of Key, Value and Reason per file. Launcher-only items sit at the end. Read it before changing a setting.
- `refs/comparisons/index.md`: One-page summary of every comparison: question, result, the user's decision, install status, constraints and statements that went stale. Read it when adding, removing or replacing a mod. Do not read it for other tasks, and do not read it just because the session's context was lost: read it when the task needs it.
- `refs/comparisons/<topic>/`: Evidence files of a comparison between similar mods (`comparison.md` is the result; scope, ledgers, sources, coverage, scripts and raw data sit beside it). Tracked in git. Do not read it by default: the result, the decision and the constraints are in the index. Read `comparison.md` only when the index does not answer the question at hand (the evidence behind a result, a result that looks stale), and open the other files in the folder only for the one fact needed.

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
- Use the `anthropic-skills:comparison` skill (a plugin skill, not part of this repository). The project's adaptations of it (market, baseline, scoring, coverage, files) are written in `.claude/agents/mod-researcher.md`: follow them too when you compare without the subagent. Keep the documents in `refs/comparisons/<topic>/`.
- Run the research with the `mod-researcher` subagent, one per topic (in parallel for unrelated topics). It returns a recommendation only: the discussion, the user's approval and the records stay with the main session.
- Read `refs/notes.md` and `refs/issues.md` first: they hold known conflicts and mods that must not be added.
- Discuss the result with the user. Never add a mod without the user's approval: present the comparison and wait for the answer. This also applies when a mod is the only way to fulfil a request.
- There is no exception. Do this even when the prompt does not ask for it, in the background of the task. The only case that skips it is when it was already done: a comparison in `refs/comparisons/` that covers the candidate (look it up in `refs/comparisons/index.md`).

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
  - The mod: `refs/list.md` and the Mod List in `docs/modlist.md` (Modrinth, CurseForge and repository links, last commit badge, official site and wiki links in the right-hand Links column).
  - Shipped settings: `refs/settings.md`.
  - Decisions and constraints (what to avoid beside it): `refs/notes.md`.

## Commands

- Add a mod (Modrinth first, CurseForge otherwise)
  - `packwiz modrinth add <URL>`
  - `packwiz curseforge add <URL>`
- Remove a mod: `packwiz remove <slug>`
- Enable the commit checks (once per clone): `git config core.hooksPath .githooks`
- After editing a metafile by hand: `packwiz refresh`
- Update: `packwiz update <slug>` / `packwiz update --all`
  - Then review the changes with the `update-reviewer` subagent and apply its follow-up edits.
- Export: `packwiz modrinth export` (`.mrpack`). `packwiz curseforge export` for the CurseForge `.zip`. `--output <file>` sets the file name. `Found N manual downloads` means a CurseForge mod has no download URL through the API: put the listed files in packwiz's `import` folder (see `README.md`), or do not add that mod. Run the export after adding a CurseForge mod.

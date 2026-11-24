# Contributing

How to change this repository: branches, pull requests and merging. For building and installing the pack, see [README.md](README.md).

## Branches

| Branch | Role | Direct push | Deletion |
| --- | --- | --- | --- |
| `main` | Released state. Servers install from `main/pack.toml`. | Not allowed (enforced) | Not allowed (enforced) |
| `dev` | Integration of finished topics. | Allowed technically; by convention only for [documentation](#documentation) | Not allowed (enforced) |
| `<prefix>/<name>` | One topic. Short-lived. | Allowed | Deleted after merge |

Force pushes to `main` and `dev` are blocked.

### Topic branches

| Prefix | Use | Example |
| --- | --- | --- |
| `add/` | Add mods, resource packs or shader packs | `add/vehicle-mods` |
| `update/` | Update mods, resource packs or shader packs | `update/all-mods` |
| `config/` | Change settings | `config/shader-defaults` |
| `ci/` | Change CI only | `ci/export-curseforge` |
| `feat/` | Anything else that is not documentation and fits none of the above | `feat/server-scripts` |

- Name: `<prefix>/<short-kebab-case-name>`.
- Cut one branch per topic. A topic is what was raised as one item: five mods requested together are one `add/` branch, and the settings they need stay in it.
- Branch from `dev`.
- `ci/` carries CI changes and nothing else.

## Pull requests

1. Open a pull request from the topic branch into `dev`.
2. Wait for the [Build modpack](.github/workflows/build-mrpack.yml) workflow to pass (`build (modrinth)` and `build (curseforge)`).
3. Squash merge. One topic is one commit on `dev`.
4. The topic branch is deleted after the merge (GitHub deletes it automatically).

Checks on a pull request into `dev` are a convention: GitHub does not block the merge.

## Releasing

1. Open a pull request from `dev` into `main`.
2. The checks below are enforced: the pull request, a passing `build (modrinth)` and `build (curseforge)`.
3. Merge with a merge commit. Do not squash or rebase: `dev` would diverge from `main`.
4. `dev` is kept: it is protected from deletion, which also stops the automatic deletion of head branches.

## Documentation

A change that touches only `README.md`, `CONTRIBUTING.md`, `CLAUDE.md`, `docs/` or `refs/` may be pushed to `dev` directly.

Documentation that belongs to a topic (for example `refs/list.md` and `docs/modlist.md` for an added mod) goes in that topic's branch.

## Repository settings

GitHub enforces these. Do not change them without a reason. Rulesets are kept in [`.github/rulesets/`](.github/rulesets/) as JSON that can be imported under **Settings → Rules → Rulesets → New ruleset → Import a ruleset**. The bypass list is not part of the JSON.

| Setting | Value |
| --- | --- |
| Ruleset `main` | Require a pull request (0 approvals, merge commit only), require `build (modrinth)` and `build (curseforge)`, restrict deletions, block force pushes |
| Ruleset `dev` | Restrict deletions, block force pushes |
| **Settings → General → Pull Requests → Automatically delete head branches** | On |

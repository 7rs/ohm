# ohm

Packwiz modpack for Minecraft Java Edition 1.20.1 and Forge 47.4.28.

- [Mod List](docs/modlist.md)
- [Contributing](CONTRIBUTING.md)
- [Benchmark](docs/benchmark.md)
- [Overview](#overview)
- [Installation](#installation)
  - [Build modpack](#build-modpack)
  - [Install on your PC](#install-on-your-pc)
  - [Install on your server](#install-on-your-server)
- [Update](#update)
  - [Update modpack](#update-modpack)
  - [Update on your PC](#update-on-your-pc)
  - [Update on your server](#update-on-your-server)

## Overview

- Minecraft Java Edition 1.20.1, Forge 47.4.28, Java 17.
- Main features: The Aether, The Twilight Forest, ParCool!, TaCZ and Create. The [Mod List](docs/modlist.md) has every mod, resource pack and shader pack by category.
- Distant Horizons draws far terrain. With a shader pack on, it draws only if the pack supports it. Every shader pack shipped here does.
- Clients install an `.mrpack` with Prism Launcher. Servers install with packwiz-installer, which skips client-only mods.

## Installation

### Build modpack

The pack is distributed as an `.mrpack`. Get it from GitHub Actions or build it from a clone of this repository.

#### From GitHub Actions

Open the [Build modpack workflow](https://github.com/7rs/ohm/actions/workflows/build-mrpack.yml), pick a run, and download the `ohm-<commit>-modrinth.mrpack` artifact (job `build (modrinth)`). The `ohm-<commit>-curseforge.zip` artifact is the CurseForge format and is not used in this guide.

- A run on `main` is a release. A run on a pull request is an unreleased change.
- Artifacts are kept for 14 days and need a GitHub login. Without a recent run, start one with **Run workflow**.

#### From a clone

Requires [Git](https://git-scm.com/) and [packwiz](https://packwiz.infra.link/installation/).

Install packwiz with Go 1.23 or newer:

```sh
go install github.com/packwiz/packwiz@latest
```

Or download a prebuilt binary from the [packwiz GitHub Actions](https://github.com/packwiz/packwiz/actions) and add it to your `PATH`. The workflow builds with the version pinned in `PACKWIZ_VERSION` of [build-mrpack.yml](.github/workflows/build-mrpack.yml).

Clone the repository and export:

```sh
git clone https://github.com/7rs/ohm.git
cd ohm
packwiz modrinth export --output ohm.mrpack
```

`*.mrpack` is ignored by Git, so the file can stay in the repository directory.

Some CurseForge mods cannot be downloaded through the CurseForge API. [Immersive Vehicles] Craftspeed is one. In that case packwiz exits with `Found N manual downloads`, lists each file with its CurseForge page, and leaves an empty `.mrpack`. Download each listed file in a browser, put it in the `import` folder that packwiz prints, and run the export again.

| OS | `import` folder |
| --- | --- |
| Windows | `%LocalAppData%\packwiz\cache\import` |
| Linux | `~/.cache/packwiz/cache/import` |
| macOS | `~/Library/Caches/packwiz/cache/import` |

The export also refreshes `index.toml` and `pack.toml`. On Windows, Git's `core.autocrlf=true` checks files out with CRLF, which changes their hashes and rewrites both files. Clone with `git clone -c core.autocrlf=false` if you plan to commit.

### Install on your PC

1. Install [Prism Launcher](https://prismlauncher.org/download/).

   <details>
   <summary>Install with a package manager</summary>

   | OS | Command |
   | --- | --- |
   | Windows (WinGet) | `winget install --exact PrismLauncher.PrismLauncher` |
   | Windows (Scoop, community) | `scoop bucket add games`, then `scoop install prismlauncher` |
   | Windows (Chocolatey, community) | `choco install prismlauncher` |
   | macOS (Homebrew) | `brew install --cask prismlauncher` |
   | macOS (MacPorts) | `sudo port install PrismLauncher` |
   | Linux (Flathub) | `flatpak install flathub org.prismlauncher.PrismLauncher` (needs [Flathub](https://flathub.org/setup) enabled) |

   Other Linux options (AppImage, Arch, Fedora, Debian and Ubuntu, openSUSE, Gentoo, Nix, Void, Alpine) are on the [Linux download page](https://prismlauncher.org/download/linux/).

   </details>

2. Get the `.mrpack` ([Build modpack](#build-modpack)).
3. In Prism Launcher, click **Add Instance**, choose **Import**, select the `.mrpack` file under **Local file** and click **OK**.
4. Prism Launcher creates an instance with Minecraft 1.20.1 and Forge 47.4.28 and downloads the mods. Launch the instance.

Notes:

- Minecraft 1.20.1 requires Java 17.
- Memory and JVM arguments are not part of the pack. Set them in the instance settings, under **Java**.
- Default Options applies the first-launch client defaults (video options, enabled resource packs, client mod settings). It writes a file only when it does not exist yet.
- No shader pack is selected at first launch. Select one under **Options** > **Video Settings** > **Shader Packs**.

### Install on your server

The server needs Java 17. Use an empty server directory.

1. Install Forge:

   ```sh
   curl -LO https://maven.minecraftforge.net/net/minecraftforge/forge/1.20.1-47.4.28/forge-1.20.1-47.4.28-installer.jar
   java -jar forge-1.20.1-47.4.28-installer.jar --installServer
   ```

2. Download `packwiz-installer-bootstrap.jar` from the [latest release](https://github.com/packwiz/packwiz-installer-bootstrap/releases/latest) into the same directory.
3. Install the server-side mods and configs:

   ```sh
   java -jar packwiz-installer-bootstrap.jar -g -s server https://raw.githubusercontent.com/7rs/ohm/main/pack.toml
   ```

   `-g` turns off the GUI. `-s server` skips client-only mods.

4. Start the server with `run.sh` (`run.bat` on Windows), which the Forge installer created. The first start stops after it writes `eula.txt`: set `eula=true` and start again. Set memory in `user_jvm_args.txt`.

Notes:

- Files under `defaultconfigs/` apply to new worlds only. A world that already has its own `serverconfig/<modid>-server.toml` keeps it.

## Update

### Update modpack

For maintainers. Work in a clone with [packwiz](https://packwiz.infra.link/installation/) installed.

1. Read `refs/issues.md` and `refs/notes.md`. Some mods depend on exact versions of other mods.
2. Update the mods:

   ```sh
   packwiz update --all
   ```

   To update one file, use `packwiz update <slug>`. The slug is the file name under `mods/`, `resourcepacks/` or `shaderpacks/`, without `.pw.toml`. A file with `pin = true` is skipped.

3. Some mods must stay on a version but are not marked `pin = true`. `refs/issues.md` and `refs/notes.md` name them: check each after the update.
4. If a resource pack's file name changed, update the `resourcePacks` key in `config/defaultoptions/options.txt`.
5. Refresh the index:

   ```sh
   packwiz refresh
   ```

   Commit on an `update/` branch and open a pull request into `dev` ([Contributing](CONTRIBUTING.md)). The [Build modpack workflow](https://github.com/7rs/ohm/actions/workflows/build-mrpack.yml) checks that `index.toml` is up to date and builds the pack.

### Update on your PC

1. Back up your worlds.
2. Get the new `.mrpack` ([Build modpack](#build-modpack)).
3. Import it into Prism Launcher as a new instance, the same way as in [Install on your PC](#install-on-your-pc).
4. Open the old instance's folder (right-click the instance, then **Folder**) and copy `saves` from its Minecraft folder to the new instance.
5. Delete the old instance when the new one works.

Settings you changed in the old instance (key bindings, video options, the shader pack) start from the pack defaults again, because Default Options applies them to the new instance.

### Update on your server

1. Stop the server and back up the world.
2. Run the command of step 3 of [Install on your server](#install-on-your-server) again in the server directory.
3. Start the server.

Files shipped under `config/` are overwritten on every update. Change them in this repository, not on the server.

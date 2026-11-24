# ohm

Packwiz modpack for Minecraft Java Edition 1.20.1 and Forge 47.4.28.

- [Mod List](docs/modlist.md)
- [Client: Prism Launcher](#client-prism-launcher)
- [Build the .mrpack from this repository](#build-the-mrpack-from-this-repository)
- [Server](#server)

## Client: Prism Launcher

1. Install [Prism Launcher](https://prismlauncher.org/download/).
2. Get `ohm.mrpack`: download the `.mrpack` artifact of a run of the [Build modpack workflow](https://github.com/7rs/ohm/actions/workflows/build-mrpack.yml) (kept for 14 days, GitHub login required), or [build it from this repository](#build-the-mrpack-from-this-repository).
3. In Prism Launcher, click **Add Instance**, choose **Import**, select the `.mrpack` file under **Local file** and click **OK**.
4. Prism Launcher creates an instance with Minecraft 1.20.1 and Forge 47.4.28 and downloads the mods. Launch the instance.

Notes:

- Minecraft 1.20.1 requires Java 17.
- Memory and JVM arguments are not part of the pack. Set them in the instance settings, under **Java**.
- Default Options applies the first-launch client defaults (video options, enabled resource packs, client mod settings). It writes a file only when it does not exist yet.

## Build the .mrpack from this repository

Requires [Git](https://git-scm.com/) and [packwiz](https://packwiz.infra.link/installation/).

Install packwiz with Go 1.19 or newer:

```sh
go install github.com/packwiz/packwiz@latest
```

Or download a prebuilt binary from the [packwiz GitHub Actions](https://github.com/packwiz/packwiz/actions) and add it to your `PATH`.

Clone the repository and export:

```sh
git clone https://github.com/7rs/ohm.git
cd ohm
packwiz modrinth export --output ohm.mrpack
```

`*.mrpack` is ignored by Git, so the file can stay in the repository directory.

Some CurseForge mods cannot be downloaded through the CurseForge API. In that case packwiz exits with `Found N manual downloads`, lists each file with its CurseForge page, and leaves an empty `.mrpack`. Download each listed file in a browser, put it in the `import` folder that packwiz prints (`~/.cache/packwiz/cache/import` on Linux), and run the export again.

## Server

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

To update, stop the server and run the command of step 3 again.

Notes:

- Files shipped under `config/` are overwritten on every update. Change them in this repository, not on the server.
- Files under `defaultconfigs/` apply to new worlds only. A world that already has its own `serverconfig/<modid>-server.toml` keeps it.

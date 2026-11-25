# Benchmark

How to profile and benchmark the pack. This file holds procedures only. No result is recorded here: nothing was measured on the pack yet ([refs/issues.md](../refs/issues.md), General).

Commands and options were checked against the tools' documentation or source on 2026-11-25. Anything marked `(unverified)` was not. Nothing below was run on the ohm pack.

## Rules

- Profile to find where the time goes. Benchmark to find how much. Never read FPS while a profiler runs: the profiler costs frame time.
- Change one thing between two runs (a mod, a setting, a shader pack, a distance). Same machine, same world copy, same spot, same settings.
- Report frame time (median, 99th and 99.9th percentile), not only average FPS. The average hides stutter.
- Run each variant 3 times and take the median of each metric. Throw away the first run after a launch (JIT, shader compile, file cache). Interleave variants (A B A B A B) so heat and background load hit both.
- A difference smaller than the spread of one variant's own runs (max minus min) is noise. Say so instead of reporting it.
- Keep raw captures (`.csv`, `.sparkprofile`, `.jfr`) outside the repository. Commit only the summary table.

## Tools

| Tool | Measures | Notes |
| --- | --- | --- |
| PresentMon console | Frame time of any process, from outside the game | No overlay, no injection. Needs an elevated shell or the "Performance Log Users" group. Windows only. |
| spark (`/sparkc` on the client, `/spark` on a server) | CPU samples per thread and per mod, allocations, GC, TPS and MSPT | Not in the pack. See Test instance. On Windows it uses the Java sampler: the async-profiler engine supports Linux and macOS only. The Java sampler has the safepoint sampling bias. |
| Vanilla debug profiler (`F3` + `L`) | Vanilla tick sections of the client and the integrated server for 10 seconds | No mod needed. Writes `debug/profiling/<date>-<world>-<version>.zip` with `client` and `server` folders, each with `profiling.txt`. Shows entity and block entity time per type, nothing about mods' own code. |
| `/forge tps`, `/forge track` | Server tick time; time per entity or block entity type | No mod needed. `/forge tps [dim]` is for everyone, `/forge track start te\|entity <seconds>` needs permission 2, then `/forge track results te\|entity`. Read from the 1.20.1 source. |
| `/perf start`, `/perf stop` | Vanilla server profile, zip in `debug/profiling` | Dedicated server only, operator level 4. (`unverified` for 1.20.1) |
| Java Flight Recorder | Allocation, locks, GC, JIT | Built into the JDK, works on Windows. Use when the spark Java sampler is not enough. Open the file in JDK Mission Control, which is a separate download. |
| `logs/latest.log` | Startup and join times printed by mods | See Startup and world join. |
| F3 screen | FPS, heap use and allocation rate at a glance | Not a measurement: it is a sanity check. |

## Test instance

Never measure in the main instance.

1. In Prism Launcher copy the instance (right click, Copy Instance). Name it `ohm-bench`. Measure variants as further copies of it.
2. Put the spark jar in `minecraft/mods/` of the copy (Prism: Edit, Mods, Add file). Modrinth's newest spark file for Forge 1.20.1 is `1.10.53-forge` (2023-09-05). The download page of spark serves `1.10.196` for the newest Minecraft only. CurseForge was not checked. spark stays out of the pack: adding it to the pack goes through Mod Addition in [CLAUDE.md](../CLAUDE.md) (comparison, user approval).
3. Java 17. In the instance settings under Java set minimum and maximum memory to the same value and keep it for every run. Write the JVM arguments down.
4. Close the game, then edit `minecraft/options.txt` of the copy: `enableVsync:false` and `maxFps:260` (the slider's "Unlimited"). The pack ships neither, so the vanilla defaults (vsync on, limit 120) cap every number. The copy already has an `options.txt`, so Default Options does not overwrite it.
5. Fix the window: the pack starts in borderless fullscreen (Cubes Without Borders, Chloride). Keep one mode and one resolution for all runs.
6. Windows: High performance power plan, no browser, launcher, recorder or Xbox Game Bar capture running, no frame cap in the GPU driver. Warm the machine for 5 minutes before the first run.
7. Dynamic FPS is installed and lowers the frame rate when the window is hovered, unfocused or invisible. The game window must keep focus for the whole capture. Where its config lives was not found: check its screen in the game. (`unverified`)

## Scenes

Use a copy of one world for all scenes. Pick the spots once and write the world copy and coordinates in the Run record.

Before each scene (a render scene keeps mobs and the sky still):

```
/time set noon
/weather clear
/gamerule doDaylightCycle false
/gamerule doWeatherCycle false
/gamerule doMobSpawning false
/tp @s <x> <y> <z> <yaw> <pitch>
```

Wait 60 seconds at the spot before the first capture: chunks, Distant Horizons LODs, shader compile and JIT settle. Distant Horizons keeps its LOD data (`DistantHorizons.sqlite`) with the world, so copy the world after the LODs are done and give every variant the same state. To fill LODs on purpose, `/dh pregen start <dimension> <x> <z> <chunk radius>` is described by users only, not by the official wiki: run `/dh pregen` to see the arguments. (`unverified`)

| ID | Scene | Measure | Question it settles |
| --- | --- | --- | --- |
| S1 | Launch to the title screen | Stopwatch, 3 runs | ModernFix, Quick Pack, JEI/EMI cost at startup |
| S2 | Title screen to a playable world | `latest.log` lines | JEI and EMI at world join ([refs/issues.md](../refs/issues.md), EMI, JEI) |
| S3 | Static view of terrain, no shader, Distant Horizons on | Frame time | Baseline; Embeddium, Chloride, Entity Culling settings |
| S4 | S3 with each Distant Horizons capable shader pack at its default profile | Frame time | Shader weight ([refs/comparisons/shader-packs/lightness.md](../refs/comparisons/shader-packs/lightness.md) has third-party numbers only) |
| S5 | S3 with Distant Horizons off, render distance 8 against 16 | Frame time | What the LOD range costs |
| S6 | N identical mobs without AI inside 128 blocks, for example `/summon minecraft:cow ~ ~ ~ {NoAI:1b}` | Frame time, spark | `entityDistanceScaling:2.0` with Chloride `entityDistanceX=16384` ([refs/issues.md](../refs/issues.md), Distant Horizons) |
| S7 | A Create contraption in view, shader on | Frame time | CreateBetterFPS, Colorwheel, Flywheel backend `instancing` against `indirect` (Steam 'n' Rails issue 768) |
| S8 | Firing a TaCZ or Superb Warfare weapon, overlay trace on | spark, Render thread | Superb Warfare issue 180 |
| S9 | Dedicated server, one idle client, a fixed load (farms, a village with guards, mob spawning on), 20 minutes | `/spark tps`, MSPT, spark | Immersive Optimization, FastSuite, mob difficulty mods ([refs/issues.md](../refs/issues.md): no TPS was measured) |
| S10 | 30 minutes in the same area, then a full GC | Heap after GC, GC pauses | AllTheLeaks and the other memory fixes |

## Procedures

### Frame time

1. Be in the scene with the game window focused. Start PresentMon in an elevated PowerShell, then click into the game before the delay ends:

   ```powershell
   .\PresentMon-<version>-x64.exe --process_name javaw.exe --output_file C:\bench\S3-a-1.csv --delay 10 --timed 60 --terminate_after_timed --no_console_stats
   ```

   The file name of the binary carries its version. Prism starts Java as `javaw.exe` (`unverified`); check the Details tab of Task Manager and use `--process_id` if it differs. Do not move during the capture. Name the file `<scene>-<variant>-<run>.csv`.

2. Compute the numbers from the CSV (column `MsBetweenPresents`). Save as `Measure-Frames.ps1`:

   ```powershell
   param([Parameter(Mandatory)][string[]]$Path)
   foreach ($p in $Path) {
       $ms = @(Import-Csv $p | ForEach-Object { [double]$_.MsBetweenPresents } | Sort-Object)
       $n = $ms.Count
       $at = { param($q) $ms[[math]::Min($n - 1, [int][math]::Ceiling($n * $q) - 1)] }
       $mean = ($ms | Measure-Object -Average).Average
       $p99 = & $at 0.99
       $p999 = & $at 0.999
       [pscustomobject]@{
           File     = Split-Path $p -Leaf
           Frames   = $n
           AvgFps   = [math]::Round(1000 / $mean, 1)
           P50Ms    = [math]::Round((& $at 0.5), 2)
           P99Ms    = [math]::Round($p99, 2)
           P999Ms   = [math]::Round($p999, 2)
           Low1Fps  = [math]::Round(1000 / $p99, 1)
           Low01Fps = [math]::Round(1000 / $p999, 1)
       }
   }
   ```

   `Low1Fps` is 1000 divided by the 99th percentile frame time, `Low01Fps` the same for the 99.9th. Other tools define "1% low" as the mean of the slowest 1% of frames, so never compare these numbers with another tool's.

3. Take the median of each column over the 3 runs of a variant, and the spread (max minus min). Apply the noise rule.

### CPU profile (client)

```
/sparkc profiler start --thread *
/sparkc profiler stop --save-to-file --comment S4-bsl-2
```

Wait 60 seconds at the scene between the two commands. Without `--thread *` spark follows only the game's main thread; `*` adds chunk meshing, Distant Horizons and other workers. In singleplayer the integrated server runs in the same JVM, so its thread shows too. `--timeout <seconds>` stops it by itself but then uploads the profile.

Read it in the viewer:

- Open the `Render thread`. Time in the buffer swap (`Window.updateDisplay`) means the CPU waits for the GPU. That is a heuristic: a CPU profile cannot show GPU cost. (`unverified`)
- Sources view splits the time per mod. Flat view with Bottom Up and Self Time lists the hot methods.
- Compare two profiles by percentages of the same thread, taken with the same options and length.

The upload goes to the public viewer. Its metadata holds the player's Minecraft name and UUID (spark's "Raw spark data" page), and anyone with the link can open it. Use `--save-to-file` (the chat message prints the path), and do not write viewer links into the repository.

### Server tick

```
/spark tps
/spark profiler start --timeout 120
/spark profiler start --only-ticks-over 50 --timeout 300
/spark tickmonitor --threshold-tick 100
/forge track start te 60
/forge track results te
```

- 20 TPS and at most 50 ms per tick is healthy. Read the median and 95th percentile MSPT from `/spark tps`, not only TPS.
- `--only-ticks-over 50` records only the laggy ticks.
- Profile with the same players and loaded chunks in every variant.
- On a dedicated server spark is a plain jar in the server's `mods/`. Do not put it in the pack: install it by hand on the test server only.

### Memory and GC

```
/sparkc gcmonitor
/sparkc gc
/sparkc profiler start --alloc --timeout 60
/sparkc heapsummary
```

- `gcmonitor` prints a line for each collection. `gc` shows the history. `--alloc` finds what allocates most.
- For a log without spark add `-Xlog:gc*:file=C:\bench\gc.log:time,uptime` to the JVM arguments.
- For Java Flight Recorder add `-XX:StartFlightRecording=filename=C:\bench\run.jfr,settings=profile,duration=90s`. Standard JDK 17 flags, not tried with this pack. (`unverified`)

### Startup and world join

- S1: start a stopwatch at the click on Launch, stop at the title screen with all buttons shown. Run 4 times and drop the first (cold file cache).
- S2: read the lines the mods print:

  ```powershell
  Select-String -Path <instance>\minecraft\logs\latest.log -Pattern 'Starting JEI took|Reloaded EMI in'
  ```

  Prism's Folder button opens the instance directory. The lines are the ones named in [refs/issues.md](../refs/issues.md).

### Mod A/B

This is the subtractive form only (the full pack against the full pack minus one mod). Testing one mod from a clean Forge instance, testing similar mods together, and the scene each mod needs are in [benchmark-mods.md](benchmark-mods.md).

1. Copy `ohm-bench`, and in the copy turn the mod off (Prism: Edit, Mods, untick; the jar gets `.disabled`). Check [refs/notes.md](../refs/notes.md) first: some mods need each other, and a missing dependency stops the launch.
2. Run the same scene and the same procedure in both instances, interleaved.
3. Settings are tested the same way: change the key in the copy only.

## Run record

Write this in front of every result table.

```
Date:
Pack commit (git rev-parse --short HEAD):
Machine: CPU / GPU / RAM / GPU driver / Windows build
Java: vendor and version, JVM arguments, min and max memory
Display: window mode, resolution, refresh rate, vsync off, maxFps 260, driver cap none
World copy and spots (x y z yaw pitch):
Distant Horizons: LOD state, radius
Shader pack and profile:
Variants and run count:
Mods added by hand (spark):
```

Where it goes:

- A result that feeds a comparison: `refs/comparisons/<topic>/benchmark.md`.
- A result that settles a known problem: change its line in [refs/issues.md](../refs/issues.md) (`unverified` to `resolved`, `open` or `by design`) and keep the table in the file above.
- A result that changes a shipped setting: [refs/settings.md](../refs/settings.md) (Reason column) and [refs/notes.md](../refs/notes.md).

## Pitfalls

- Vsync and the frame limit of the vanilla defaults, the GPU driver and Dynamic FPS all cap or lower FPS without any message.
- Distant Horizons generates and loads LODs for minutes after a teleport. Wait, or start from a world copy with LODs done.
- Shaders compile on the first load and again when the pack or its options change. Discard the first 60 seconds.
- Compare shader packs at the same shadow mode. Mellow ships with `DYNAMIC_SHADOWS` off, so its default is not like-for-like with packs that draw a shadow map ([refs/notes.md](../refs/notes.md), Shader Packs).
- Enhanced Celestials events, Zombie Awareness and other mob mods change the scene. Fix time and weather and switch spawning off for render scenes, keep it on for server scenes.
- A sampling profiler's percentages are estimates. Two profiles that differ by a few percent do not differ.
- Another profiler running at the same time (spark and Flight Recorder together) distorts both.

## Sources

- spark: [Command Usage](https://spark.lucko.me/docs/Command-Usage), [Installation](https://spark.lucko.me/docs/Installation), [Using the viewer](https://spark.lucko.me/docs/Using-the-viewer), [async-profiler engine](https://spark.lucko.me/docs/misc/Using-async-profiler), [TPS and MSPT](https://spark.lucko.me/docs/guides/TPS-and-MSPT), [Raw spark data](https://spark.lucko.me/docs/misc/Raw-spark-data)
- Forge: [Debug Profiler](https://docs.minecraftforge.net/en/1.20.x/misc/debugprofiler/), [TrackCommand](https://github.com/MinecraftForge/MinecraftForge/blob/1.20.1/src/main/java/net/minecraftforge/server/command/TrackCommand.java), [TPSCommand](https://github.com/MinecraftForge/MinecraftForge/blob/1.20.1/src/main/java/net/minecraftforge/server/command/TPSCommand.java)
- PresentMon: [README](https://github.com/GameTechDev/PresentMon), [console application](https://github.com/GameTechDev/PresentMon/blob/main/README-ConsoleApplication.md)
- spark versions for Forge 1.20.1: [Modrinth](https://modrinth.com/mod/spark/versions)

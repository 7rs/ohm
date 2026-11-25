# ThreatenGL and the other OpenGL version mods (Forge 1.20.1)

Status: provisional. Research date: 2026-11-23. Nothing was run in the game; every behavior below comes from reading the jar and the platform pages.

Decision: pending (user).

## Headline

Not recommended for the shared pack. ThreatenGL is small and does what it says, but its benefit depends on each player's GPU driver profile and nobody has published a measurement; the author calls the gain "potential". A player who wants to try it can install it alone.

## Fact table

| | ThreatenGL | ForceGL20 | ForceGL2.0 remapped |
| --- | --- | --- | --- |
| Direction | Requests OpenGL 4.6 (4.1 on macOS) | Forces OpenGL 2.0 | Forces a chosen version (default 2.0) |
| Downloads, Modrinth (all versions) | 946,730 | 64,370 | 43,512 |
| Downloads, Modrinth (Forge 1.20.1 files) | 602,129 (9 files) | 41,543 (1 file) | not collected |
| Latest Forge 1.20.1 release | 2.0.4-release.10, 2025-11-02 | v1.1.0-forge, 2023-05-23 | 2025-10-17 (project updated) |
| Repository | Richy-Z/ThreatenGL, 39 stars, last commit 2025-11-02, 0 open issues | KabanFriends/ForceGL20 | not collected |
| Side (Modrinth) | client required, server unsupported | client required | not collected |
| Dependencies | none (since 1.3.2-beta.1) | none | not read |
| Evidence of the effect | claim only ("users have reported smoother gameplay") | n/a (compatibility tool) | n/a |

## Source, read (ThreatenGL jar 2.0.4-release.10)

- Four classes. One client mixin `ThreatenGLMixin` (`defaultRequire = 1`).
- It redirects `GLFW.glfwWindowHint` inside `Window.<init>` and replaces `GLFW_CONTEXT_VERSION_MAJOR` and `GLFW_CONTEXT_VERSION_MINOR` with 4 and 6 (4 and 1 when `os.name` contains `mac`). No config.
- The description says it does nothing if the hardware lacks OpenGL 4.6.

## Observations for this pack

- Cubes Without Borders (see `refs/comparisons/borderless-fullscreen/`; in the pack since 2026-11-24) wraps the same `glfwWindowHint` call. Chloride's `BorderlessMixin$WindowMixin` hooks `Window.setMode` (`glfwSetWindowMonitor`, `glfwGetWindowMonitor`), not `glfwWindowHint`; see the overlap table in that comparison.
- Ixeris hooks `Window` around `glfwFreeCallbacks`, which is a different point.
- Whether Distant Horizons, Oculus shader packs and Colorwheel behave the same on a 4.6 context was not checked.

## Excluded

| Mod | Reason |
| --- | --- |
| Radiance (Windows, Linux) | Replaces the OpenGL backend with a Vulkan one; a different and far larger change |
| GLA | macOS OpenGL additions |
| WATERMeDIA | Multimedia library |

## Coverage

- Market from Modrinth only.
- Evidence levels: downloads and dates Measured, hook Measured by reading, FPS effect Claimed.

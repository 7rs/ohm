# MixinBooster (Forge 1.20.1)

Status: provisional. Research date: 2026-11-23. Nothing was run in the game; every behavior below comes from reading the platform page and the dependency data.

Decision: pending (user).

## Scope

MixinBooster is a library that replaces the Sponge Mixin that Forge ships with Fabric's Mixin fork at runtime. The question is whether the pack needs it. No similar library was enumerated: its role is defined by the mods that require it. CurseForge was not enumerated.

Criteria: download count and release date (Measured), whether any installed mod requires it (Measured, Modrinth dependency data), the author's description (Claimed).

## Headline

Do not add. It changes the Mixin implementation for the whole game, and nothing installed asks for it.

## Facts

| | MixinBooster |
| --- | --- |
| Downloads, Modrinth | 384,195 (all Forge 1.20.1 files, 3 files) |
| Latest Forge 1.20.1 release | 0.1.3+1.20.1, 2026-03-04 |
| Repository | sinytra/mixintransmogrifier |
| Modrinth categories | cursed, library, optimization |
| Side (Modrinth) | client and server optional |
| Author's notes | Replaces Sponge's Mixin with Fabric's fork "that has more features". Deprecated from Minecraft 1.21 because NeoForge ships that fork. Modders add it as a dependency so users install it. |

## Dependency check

- The pinned Modrinth versions of all 72 installed Modrinth mods were fetched on 2026-11-23. None lists MixinBooster as a dependency of any type.
- The six CurseForge mods (The Twilight Forest, Catalogue, Solix, AllTheLeaks, JEI/EMI Optimizations, Weather Refined) were not checked.
- The pack already depends heavily on Mixin (Embeddium, ModernFix, Oculus, Harium, Punchy!, Immediately Fast and others), which is the risk of swapping the implementation.

## Coverage

- One candidate. The jar was not read.
- Evidence levels: downloads, dates and dependencies Measured, claims about the swap Claimed.

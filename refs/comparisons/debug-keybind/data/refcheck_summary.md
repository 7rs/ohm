# Member-reference check against Minecraft 1.20.1 and Forge 47.4.28

Method (Measured by reading, nothing run): every `Methodref`, `InterfaceMethodref` and `Fieldref` that a jar's classes make into `net/minecraft/`, `com/mojang/blaze3d/` and `net/minecraftforge/` was extracted with `javap -v -p` and looked up (with supertypes) in the Forge-patched client (`forge-1.20.1-47.4.28-client.jar`) and the SRG-named Minecraft client (`client-1.20.1-20230612.114412-srg.jar`) from the Prism libraries folder. Scripts: `scripts/refcheck.sh` (reference extraction), `scripts/refcheck2.sh` and `scripts/supers.awk` (lookup).

| Jar | References into Minecraft/Forge | Not found in 1.20.1 | Result |
| --- | --- | --- | --- |
| DebugKeybind-forge-9.1.1.jar (Modrinth file tagged 1.20.1 and 1.20.2, named "[Forge 1.20.2]") | 41 | 2 | `Minecraft.m_293199_()` and `DebugScreenOverlay.m_293034_()`: both used only by the lambda of the bare `/f3` command (`F3Command.lambda$create$0`). Neither exists in 1.20.1 |
| Boxlib-forge-11.3.2.jar | 127 | 1 reported, 0 real | `CommandSourceStack.m_81374_()` exists in 1.20.1 (`getEntityOrException() throws CommandSyntaxException`); the checker's parser mistook the `throws` clause for part of the name |
| DebugKeybind-5.0.0.jar (Modrinth file named "[Forge 1.20.1]", `minecraft [1.20,1.20.1]`) | 76 | 0 | clean |
| Boxlib-forge-9.0.0.jar (Jar-in-Jar inside 5.0.0) | 114 | 0 | clean |

The raw lists are in `refcheck/<label>/` (`refs_minecraft_forge.txt`, `unresolved.txt`; labels dk911, boxlib1132, dk500, boxlib900).

Mixin targets of 9.1.1 (all 13 injectors, plus the invoker) were checked separately against the 1.20.1 SRG jar: see `vanilla_1.20.1_evidence.txt`. All exist.

Not covered by this check: calls into libraries that are not in Minecraft or Forge (Brigadier, Gson, Guava), and behavior at run time.

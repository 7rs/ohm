# Scripts

These produced the data under `../data/`. Their paths point at the session scratchpad of the run (`C:/Users/taiko/AppData/Local/Temp/claude/.../scratchpad`) and at the Prism launcher's bundled `javap`; change them before reusing. They only read jars (with `javap`, `7z`, `grep`); nothing from a jar is run.

| Script | Does |
| --- | --- |
| `urls.nu` | Reads `mods/*.pw.toml` and writes slug, side, file name, URL, hash (CurseForge entries get a CDN URL built from the file id) |
| `dl.sh`, `extract.sh` | Download the jars in parallel and extract class files, JSON and one level of Jar-in-Jar into one folder per jar |
| `scan.sh`, `ann.awk`, `report.nu` | List classes that carry the Mixin annotation and name a target class, then print every Mixin annotation (kind, method, call) per class |
| `refcheck.sh`, `genrefs.sh`, `refcheck2.sh`, `supers.awk` | Extract the member references a jar makes into Minecraft and Forge and look each up (with supertypes) in the 1.20.1 / Forge 47.4.28 client jars |
| `versions_tsv.nu` | Turns a Modrinth version list into a tab-separated file for one loader and game version |

Known limit of the reference check: a method with a `throws` clause is mis-parsed, which gave one false report for BoxLib (`CommandSourceStack.m_81374_`, checked by hand). `report.nu` stops after writing the target list; the injector list was cut with `awk` from `scan_raw.tsv`.

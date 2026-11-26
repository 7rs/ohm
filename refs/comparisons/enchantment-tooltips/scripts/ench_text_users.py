#!/usr/bin/env python3
"""Which installed jars (a) depend on or ship Bookshelf / Enchantment Descriptions, (b) show enchantment text?

usage: ench_text_users.py JARS_DIR OUT.md

(a) reads META-INF/mods.toml (and nested jars) for modId/dependency lines naming bookshelf or enchdesc, and lists any
    entry under net/darkhax/ in the jar.
(b) finds classes whose constant pool holds both the Enchantment class and a string ending with ".desc" or ".description"
    or "enchantment.", or a reference to ItemTooltipEvent plus the Enchantment class, i.e. code that draws enchantment text
    into tooltips. Heuristic: a hit means "read this class", not "does it".
"""
import sys, os, io, zipfile, struct, re

def cp(b):
    if b[:4] != b"\xca\xfe\xba\xbe": return None
    n = struct.unpack_from(">H", b, 8)[0]; o = 10; out = []
    i = 1
    while i < n:
        t = b[o]; o += 1
        if t == 1:
            l = struct.unpack_from(">H", b, o)[0]; o += 2
            out.append(b[o:o + l].decode("utf-8", "replace")); o += l
        elif t in (3, 4): o += 4
        elif t in (5, 6): o += 8; i += 1
        elif t in (7, 8, 16, 19, 20): o += 2
        elif t in (9, 10, 11, 12, 17, 18): o += 4
        elif t == 15: o += 3
        else: return None
        i += 1
    return out

hits_dep, hits_cls, darkhax = [], [], []

def scan(zf, label):
    for n in zf.namelist():
        if n == "META-INF/mods.toml":
            t = zf.read(n).decode("utf-8", "replace")
            for ln in t.splitlines():
                if re.search(r'bookshelf|enchdesc|enchantment-descriptions', ln, re.I) and re.search(r'modId|dependencies', ln):
                    hits_dep.append((label, ln.strip()))
        if n.startswith("net/darkhax/") and n.endswith(".class"):
            darkhax.append((label, n))
        if n.endswith(".class") and not n.startswith("META-INF/versions"):
            try:
                u = cp(zf.read(n))
            except Exception:
                continue
            if not u: continue
            s = set(u)
            if "net/minecraft/world/item/enchantment/Enchantment" in s and (
                    any(x.endswith(".desc") or x.endswith(".description") or x == ".desc" for x in s if len(x) < 40)
                    or "net/minecraftforge/event/entity/player/ItemTooltipEvent" in s):
                hits_cls.append((label, n))
        elif n.startswith("META-INF/jarjar/") and n.endswith(".jar"):
            try:
                scan(zipfile.ZipFile(io.BytesIO(zf.read(n))), label + "!" + os.path.basename(n))
            except Exception:
                pass

jars, out = sys.argv[1:3]
for root, _, files in os.walk(jars):
    for f in sorted(files):
        if f.lower().endswith(".jar"):
            try:
                scan(zipfile.ZipFile(os.path.join(root, f)), os.path.basename(root))
            except Exception:
                pass
with open(out, "w") as fh:
    fh.write("# Installed jars that name Bookshelf or Enchantment Descriptions, or touch enchantment text\n\n")
    fh.write("## mods.toml lines naming bookshelf or enchdesc\n\n")
    for l, ln in hits_dep: fh.write(f"- {l}: `{ln}`\n")
    if not hits_dep: fh.write("- none\n")
    fh.write("\n## Classes under net/darkhax/\n\n")
    for l, n in darkhax[:20]: fh.write(f"- {l}: {n}\n")
    if not darkhax: fh.write("- none\n")
    fh.write("\n## Classes with the Enchantment class and a `.desc`/`.description` string or ItemTooltipEvent\n\n")
    for l, n in hits_cls: fh.write(f"- {l}: {n}\n")
    if not hits_cls: fh.write("- none\n")
print(len(hits_dep), "dependency lines;", len(darkhax), "darkhax classes;", len(hits_cls), "enchantment text classes")

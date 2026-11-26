#!/usr/bin/env python3
"""Find jars that define or register enchantments, by reading class files (nothing is run).

usage: enchant_classes.py JARS_DIR OUT.tsv

For every jar (nested Jar-in-Jar included) it counts
  sub  : classes whose direct superclass is net/minecraft/world/item/enchantment/* (a custom enchantment class)
  reg  : classes whose constant pool references ForgeRegistries.ENCHANTMENTS or Registries.ENCHANTMENT
and lists the first few subclass names. A mod that only reads enchantments (tooltips, loot) has reg > 0 and sub = 0.
Enchantments built from vanilla classes with a direct `new` of a vanilla subclass are counted by `sub` only when the
superclass is a vanilla one; an anonymous subclass has a $ in the name and is counted.
"""
import sys, os, io, zipfile, struct

def cp_strings(b):
    if b[:4] != b"\xca\xfe\xba\xbe":
        return None
    n = struct.unpack_from(">H", b, 8)[0]
    o = 10
    cp = [None] * n
    i = 1
    while i < n:
        t = b[o]; o += 1
        if t == 1:
            l = struct.unpack_from(">H", b, o)[0]; o += 2
            cp[i] = ("u", b[o:o + l].decode("utf-8", "replace")); o += l
        elif t in (3, 4): o += 4
        elif t in (5, 6): o += 8; i += 1
        elif t == 7: cp[i] = ("c", struct.unpack_from(">H", b, o)[0]); o += 2
        elif t == 8: o += 2
        elif t in (9, 10, 11, 12, 17, 18): o += 4
        elif t == 15: o += 3
        elif t == 16: o += 2
        elif t in (19, 20): o += 2
        else: return None
        i += 1
    o += 2
    this_i = struct.unpack_from(">H", b, o)[0]; o += 2
    sup_i = struct.unpack_from(">H", b, o)[0]; o += 2
    def cn(idx):
        e = cp[idx]
        return cp[e[1]][1] if e and e[0] == "c" else None
    utf = [e[1] for e in cp if e and e[0] == "u"]
    return cn(this_i), cn(sup_i), utf

def scan(zf, label, acc):
    for n in zf.namelist():
        if n.endswith(".class") and not n.startswith("META-INF/versions"):
            try:
                r = cp_strings(zf.read(n))
            except Exception:
                continue
            if not r: continue
            this, sup, utf = r
            if sup and sup.startswith("net/minecraft/world/item/enchantment/"):
                acc["sub"].append(this)
            if "ENCHANTMENTS" in utf or "ENCHANTMENT" in utf and any("Registries" in u for u in utf):
                if any("ForgeRegistries" in u or "core/registries/Registries" in u or u == "net/minecraft/core/registries/Registries" for u in utf):
                    acc["reg"].append(this)
        elif n.startswith("META-INF/jarjar/") and n.endswith(".jar"):
            try:
                scan(zipfile.ZipFile(io.BytesIO(zf.read(n))), label, acc)
            except Exception:
                pass

jars, out = sys.argv[1:3]
rows = []
for root, _, files in os.walk(jars):
    for f in sorted(files):
        if f.lower().endswith(".jar"):
            p = os.path.join(root, f)
            acc = {"sub": [], "reg": []}
            try:
                scan(zipfile.ZipFile(p), os.path.basename(root), acc)
            except Exception as e:
                print("skip", p, e, file=sys.stderr); continue
            if acc["sub"] or acc["reg"]:
                rows.append((os.path.basename(root), len(acc["sub"]), len(acc["reg"]), ",".join(x.rsplit("/", 1)[-1] for x in acc["sub"][:6])))
with open(out, "w") as fh:
    fh.write("slug\tsubclasses\tregistry_refs\tfirst_subclasses\n")
    for r in sorted(rows):
        fh.write("\t".join(map(str, r)) + "\n")
print(len(rows), "jars with enchantment classes or registry references")

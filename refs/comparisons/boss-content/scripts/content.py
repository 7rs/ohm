"""Content counts, structure sets and spawn data of mod jars. Python 3 standard library only.
Usage: python3 -I content.py <out_dir> <jar> [<jar> ...]
Writes <out_dir>/content_counts.csv and, per jar, <out_dir>/content_<jarname>.txt with
structure sets (spacing, separation), biome modifier spawns (entity, weight, min, max) and boss classes.
Mob class = non-abstract class whose super chain reaches a vanilla entity class that is a mob.
Boss class = a class (or a parent) that uses ServerBossEvent or extends WitherBoss or EnderDragon.
"""
import sys, os, re, json, zipfile, io, csv, collections

# class header parser (small copy of refcheck.parse; access flags are needed here)
import struct


def header(buf):
    p = 8
    (n,) = struct.unpack_from(">H", buf, p); p += 2
    utf, cls = {}, {}
    i = 1
    while i < n:
        t = buf[p]; p += 1
        if t == 1:
            (l,) = struct.unpack_from(">H", buf, p); p += 2
            utf[i] = buf[p:p + l].decode("utf-8", "replace"); p += l
        elif t in (3, 4): p += 4
        elif t in (5, 6): p += 8; i += 1
        elif t == 7:
            (cls[i],) = struct.unpack_from(">H", buf, p); p += 2
        elif t in (8, 16, 19, 20): p += 2
        elif t in (9, 10, 11, 12, 17, 18): p += 4
        elif t == 15: p += 3
        else: raise ValueError(t)
        i += 1
    acc, this, sup = struct.unpack_from(">HHH", buf, p)
    names = {utf[v] for v in cls.values() if v in utf}
    return dict(name=utf[cls[this]], sup=utf[cls[sup]] if sup else "", abstract=bool(acc & 0x0400 or acc & 0x0200), names=names, strs=set(utf.values()))


NONMOB = re.compile(r"^net/minecraft/world/entity/(Entity$|projectile/|item/|vehicle/|decoration/|AreaEffectCloud|LightningBolt|ExperienceOrb|Marker|FlyingBlock)")


def analyse(path):
    z = zipfile.ZipFile(path)
    names = z.namelist()
    classes = {}
    nested = [n for n in names if n.startswith("META-INF/jarjar/") and n.endswith(".jar")]
    for n in names:
        if n.endswith(".class") and not n.startswith("META-INF/"):
            try:
                c = header(z.read(n)); classes[c["name"]] = c
            except Exception:
                pass
    memo, bmemo = {}, {}

    def is_mob(nm, d=0):
        if d > 12: return False
        if nm in memo: return memo[nm]
        c = classes.get(nm); r = False
        if c:
            s = c["sup"]
            r = (not NONMOB.match(s)) if s.startswith("net/minecraft/world/entity/") else is_mob(s, d + 1)
        memo[nm] = r; return r

    def is_boss(nm, d=0):
        if d > 12: return False
        if nm in bmemo: return bmemo[nm]
        c = classes.get(nm); r = False
        if c:
            r = ("net/minecraft/server/level/ServerBossEvent" in c["names"]) or c["sup"] in ("net/minecraft/world/entity/boss/wither/WitherBoss", "net/minecraft/world/entity/boss/enderdragon/EnderDragon") or is_boss(c["sup"], d + 1)
        bmemo[nm] = r; return r

    mobs, bosses = set(), set()
    for nm, c in classes.items():
        if c["abstract"] or "$" in nm or not is_mob(nm): continue
        simple = nm.split("/")[-1]
        mobs.add(simple)
        if is_boss(nm): bosses.add(simple)
    ls = lambda pat: [n for n in names if re.search(pat, n)]
    structs = ls(r"^data/[^/]+/worldgen/structure/.*\.json$")
    sets = ls(r"^data/[^/]+/worldgen/structure_set/.*\.json$")
    biomes = ls(r"^data/[^/]+/worldgen/biome/.*\.json$")
    dims = ls(r"^data/[^/]+/dimension/.*\.json$")
    nbt = ls(r"^data/[^/]+/structures?/.*\.nbt$")
    bmods = ls(r"^data/[^/]+/forge/biome_modifier/.*\.json$")
    ent_lang = 0
    for n in ls(r"/lang/en_us\.json$"):
        try:
            j = json.loads(z.read(n).decode("utf-8", "replace").lstrip("﻿"))
            ent_lang += sum(1 for k in j if re.match(r"^entity\.[a-z0-9_]+\.[a-z0-9_]+$", k))
        except Exception:
            pass
    detail = []
    for n in sets:
        try:
            j = json.loads(z.read(n)); pl = j.get("placement", {})
            detail.append("structure_set %s: type=%s spacing=%s separation=%s freq=%s structures=%s" % (n.split("worldgen/structure_set/")[-1], pl.get("type"), pl.get("spacing"), pl.get("separation"), pl.get("frequency"), [s.get("structure") for s in j.get("structures", [])][:6]))
        except Exception as e:
            detail.append("structure_set %s: unreadable" % n)
    for n in bmods:
        try:
            j = json.loads(z.read(n))
            t = j.get("type", "")
            if "spawn" in t or "spawners" in j:
                sp = j.get("spawners", [])
                sp = sp if isinstance(sp, list) else [sp]
                detail.append("biome_modifier %s: type=%s biomes=%s spawners=%s" % (n.split("biome_modifier/")[-1], t, j.get("biomes"), [(s.get("type"), s.get("weight"), s.get("minCount"), s.get("maxCount")) for s in sp][:8]))
        except Exception:
            pass
    return dict(file=os.path.basename(path), mb=round(os.path.getsize(path) / 1048576, 1), mobs=len(mobs), bosses=sorted(bosses), ent_lang=ent_lang,
                structs=len(structs), sets=len(sets), nbt=len(nbt), biomes=len(biomes), dims=len(dims), bmods=len(bmods), nested=len(nested), detail=detail)


out = sys.argv[1]
os.makedirs(out, exist_ok=True)
rows = []
for jar in sys.argv[2:]:
    r = analyse(jar)
    rows.append(r)
    with open(os.path.join(out, "content_%s.txt" % re.sub(r"[^A-Za-z0-9._-]", "_", r["file"])), "w") as f:
        f.write("bosses (class names): %s\n" % ", ".join(r["bosses"]))
        f.write("\n".join(r["detail"]) + "\n")
with open(os.path.join(out, "content_counts.csv"), "w", newline="") as f:
    w = csv.writer(f)
    w.writerow(["jar", "size_mb", "mob_classes", "boss_classes", "entity_lang_keys", "structure_json", "structure_sets", "structure_nbt", "biome_json", "dimension_json", "biome_modifiers"])
    for r in rows:
        w.writerow([r["file"], r["mb"], r["mobs"], len(r["bosses"]), r["ent_lang"], r["structs"], r["sets"], r["nbt"], r["biomes"], r["dims"], r["bmods"]])
        print(r["file"], r["mb"], "mobs", r["mobs"], "bosses", len(r["bosses"]), "lang", r["ent_lang"], "structs", r["structs"], "sets", r["sets"], "nbt", r["nbt"], "biomes", r["biomes"], "dims", r["dims"], "bmods", r["bmods"])

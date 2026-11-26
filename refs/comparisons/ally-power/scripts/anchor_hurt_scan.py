#!/usr/bin/env python3
"""Read class files of the installed jars (nothing is run) and report two things about the
Touhou Little Maid: Spell bootstrap transformers (read from its HurtHeadTransformationService and
AnchorWriteSites classes):

 1. ANCHOR: classes outside Minecraft/Forge/JDK that reference the entity-index fields the
    AnchorWriteSites transformer rewrites (Fieldref owner+name, Mojmap or SRG spelling).
 2. HURT: classes that declare hurt(DamageSource,float)Z (names hurt / m_6469_) and whose superclass
    chain (inside the jars, then a vanilla-package heuristic) ends in a living entity. This is the
    set HurtHeadTransformationService would patch at the method head. The vanilla part of the chain
    is a package heuristic, not the Minecraft class library, so the count is approximate.

usage: anchor_hurt_scan.py OUT.md JARS_DIR
JARS_DIR holds one sub-directory per slug with the jar inside (dl_installed.py layout).
"""
import sys, os, io, zipfile, struct, collections

FIELDS = {  # owner -> names (Mojmap and SRG), read from AnchorWriteSites.<clinit>
    "net/minecraft/world/entity/Entity": {"removalReason", "f_146795_", "levelCallback", "f_146801_"},
    "net/minecraft/world/level/entity/EntityTickList": {"active", "passive", "iterated", "f_156903_", "f_156904_", "f_156905_"},
    "net/minecraft/world/level/entity/EntityLookup": {"byId", "byUuid", "f_156807_", "f_156808_"},
    "net/minecraft/world/level/entity/EntitySection": {"storage", "f_156827_"},
    "net/minecraft/util/ClassInstanceMultiMap": {"allInstances", "byClass", "f_13529_", "f_13527_"},
    "net/minecraft/world/level/entity/EntitySectionStorage": {"sections", "sectionIds", "f_156852_", "f_156853_"},
    "net/minecraft/world/level/entity/PersistentEntitySectionManager": {"knownUuids", "visibleEntityStorage", "sectionStorage", "f_157491_", "f_157494_", "f_157495_"},
    "net/minecraft/world/level/entity/TransientEntitySectionManager": {"entityStorage", "f_157637_", "f_157638_"},
    "net/minecraft/server/level/ChunkMap": {"entityMap", "f_140150_"},
    "net/minecraft/server/level/ServerLevel": {"entityTickList", "entityManager", "navigatingMobs", "f_143243_", "f_143244_", "f_143246_"},
    "net/minecraft/client/multiplayer/ClientLevel": {"tickingEntities", "f_171630_", "f_171631_"},
}
SKIP_PREFIX = ("net/minecraft/", "net/minecraftforge/", "java/", "javax/", "jdk/", "it/unimi/", "org/spongepowered/",
               "org/objectweb/", "com/github/yimeng261/maidspell/")
HURT_NAMES = {"hurt", "m_6469_"}
HURT_DESC = "(Lnet/minecraft/world/damagesource/DamageSource;F)Z"
LIVING_PKGS = ("net/minecraft/world/entity/monster/", "net/minecraft/world/entity/animal/", "net/minecraft/world/entity/npc/",
               "net/minecraft/world/entity/boss/", "net/minecraft/world/entity/ambient/", "net/minecraft/world/entity/player/")
LIVING_NAMES = {"net/minecraft/world/entity/LivingEntity", "net/minecraft/world/entity/Mob", "net/minecraft/world/entity/PathfinderMob",
                "net/minecraft/world/entity/AgeableMob", "net/minecraft/world/entity/FlyingMob", "net/minecraft/world/entity/TamableAnimal",
                "net/minecraft/world/entity/decoration/ArmorStand", "net/minecraft/world/entity/animal/AbstractGolem"}


def parse(data):
    b = data
    if b[:4] != b"\xca\xfe\xba\xbe":
        return None
    o = 8
    n = struct.unpack_from(">H", b, o)[0]; o += 2
    cp = [None] * n
    i = 1
    while i < n:
        t = b[o]; o += 1
        if t == 1:
            l = struct.unpack_from(">H", b, o)[0]; o += 2
            cp[i] = ("u", b[o:o + l].decode("utf-8", "replace")); o += l
        elif t in (3, 4):
            o += 4
        elif t in (5, 6):
            o += 8; i += 1
        elif t in (7, 8, 16, 19, 20):
            cp[i] = ("c" if t == 7 else "x", struct.unpack_from(">H", b, o)[0]); o += 2
        elif t in (9, 10, 11):
            cp[i] = ("ref", struct.unpack_from(">HH", b, o)); o += 4
        elif t == 12:
            cp[i] = ("nt", struct.unpack_from(">HH", b, o)); o += 4
        elif t == 15:
            o += 3
        elif t in (17, 18):
            o += 4
        else:
            return None
        i += 1
    u = lambda k: cp[k][1] if cp[k] and cp[k][0] == "u" else None
    cn = lambda k: u(cp[k][1]) if cp[k] and cp[k][0] == "c" else None
    o += 2
    this = cn(struct.unpack_from(">H", b, o)[0]); o += 2
    sup_i = struct.unpack_from(">H", b, o)[0]; o += 2
    sup = cn(sup_i) if sup_i else None
    ic = struct.unpack_from(">H", b, o)[0]; o += 2 + 2 * ic
    fieldrefs = set()
    for e in cp:
        if e and e[0] == "ref":
            ci, nti = e[1]
            owner = cn(ci)
            if owner in FIELDS:
                nt = cp[nti]
                name = u(nt[1][0]) if nt and nt[0] == "nt" else None
                if name in FIELDS[owner]:
                    fieldrefs.add((owner.rsplit("/", 1)[-1], name))
    # methods
    def skip_attrs(o):
        ac = struct.unpack_from(">H", b, o)[0]; o += 2
        for _ in range(ac):
            o += 2
            l = struct.unpack_from(">I", b, o)[0]; o += 4 + l
        return o
    fc = struct.unpack_from(">H", b, o)[0]; o += 2
    for _ in range(fc):
        o += 6; o = skip_attrs(o)
    mc = struct.unpack_from(">H", b, o)[0]; o += 2
    has_hurt = False
    for _ in range(mc):
        o += 2
        ni, di = struct.unpack_from(">HH", b, o); o += 4
        if u(ni) in HURT_NAMES and u(di) == HURT_DESC:
            has_hurt = True
        o = skip_attrs(o)
    return this, sup, fieldrefs, has_hurt


def main():
    out, root = sys.argv[1], sys.argv[2]
    classes = {}  # name -> (super, jarslug)
    anchor = collections.defaultdict(lambda: collections.defaultdict(set))  # slug -> class -> refs
    hurt = []  # (slug, class)
    def scan_zip(zf, slug):
        for name in zf.namelist():
            if name.endswith(".class") and not name.startswith("META-INF/versions"):
                try:
                    r = parse(zf.read(name))
                except Exception:
                    continue
                if not r:
                    continue
                this, sup, refs, has_hurt = r
                classes[this] = (sup, slug)
                if refs and not this.startswith(SKIP_PREFIX):
                    anchor[slug][this] |= refs
                if has_hurt and not this.startswith(SKIP_PREFIX):
                    hurt.append((slug, this))
            elif name.lower().endswith(".jar") and name.startswith("META-INF/jarjar/"):
                try:
                    scan_zip(zipfile.ZipFile(io.BytesIO(zf.read(name))), slug)
                except Exception:
                    pass
    for slug in sorted(os.listdir(root)):
        d = os.path.join(root, slug)
        for f in os.listdir(d):
            if f.endswith(".jar"):
                try:
                    scan_zip(zipfile.ZipFile(os.path.join(d, f)), slug)
                except Exception as e:
                    print("skip", slug, e, file=sys.stderr)
    def living(c, depth=0):
        while c and depth < 40:
            if c in LIVING_NAMES or c.startswith(LIVING_PKGS):
                return True
            if c.startswith("net/minecraft/"):
                return False
            nxt = classes.get(c)
            if not nxt:
                return None  # unknown (class outside the jars and not vanilla)
            c = nxt[0]; depth += 1
        return None
    per = collections.defaultdict(list)
    unknown = collections.Counter()
    for slug, c in hurt:
        L = living(c)
        if L:
            per[slug].append(c)
        elif L is None:
            unknown[slug] += 1
    with open(out, "w") as f:
        f.write("# Classes the Touhou Little Maid: Spell transformers would touch in the installed jars\n\n")
        f.write("Read from class files (constant pool and method table); nothing was run. Generated by `scripts/anchor_hurt_scan.py`.\n\n")
        f.write("## 1. Entity-index field references (AnchorWriteSites targets)\n\n")
        f.write("Classes outside Minecraft, Forge, the JDK, fastutil, Sponge and the add-on itself with a Fieldref to one of the rewritten fields. Mixin classes show up only when they use the field directly.\n\n")
        f.write("| Mod (slug) | Classes | Fields referenced |\n|---|---|---|\n")
        for slug in sorted(anchor):
            refs = set()
            for r in anchor[slug].values():
                refs |= r
            f.write(f"| {slug} | {len(anchor[slug])} | {', '.join(sorted(a + '.' + b for a, b in refs))} |\n")
        if not anchor:
            f.write("| (none) | 0 | |\n")
        f.write("\n## 2. Classes with hurt(DamageSource, float) on a living-entity chain (HurtHeadTransformationService targets)\n\n")
        f.write("Vanilla ancestry is a package heuristic (monster, animal, npc, boss, ambient, player and the named bases), not the Minecraft class library; `unknown` means the chain left the jars at a non-Minecraft class.\n\n")
        f.write("| Mod (slug) | Living classes with hurt | Unresolved |\n|---|---|---|\n")
        tot = 0
        for slug in sorted(set(per) | set(unknown)):
            tot += len(per[slug])
            f.write(f"| {slug} | {len(per[slug])} | {unknown[slug]} |\n")
        f.write(f"\nTotal in mod jars: {tot} living classes with hurt (plus the vanilla ones the add-on reads from the Minecraft library).\n\n")
        f.write("### Class names\n\n")
        for slug in sorted(per):
            f.write(f"- {slug}: " + ", ".join(sorted(c.rsplit('/', 1)[-1] for c in per[slug])[:60]) + "\n")
    print("anchor mods:", len(anchor), "| hurt living classes:", sum(len(v) for v in per.values()), "| unresolved:", sum(unknown.values()))


main()

#!/usr/bin/env python3
"""Parse Sponge Mixin annotations straight from class files (no decompiler, nothing is run).

usage: mixin_scan.py OUT.tsv JAR_OR_DIR [JAR_OR_DIR ...]

Each argument is a jar or a directory that is searched recursively for *.jar. Nested jars
(Jar-in-Jar) are read too. One TSV row per injector method:
  jar, nested, mixin_class, target_class, kind, method_patterns, at_values, at_targets, other

kind: Inject Redirect ModifyConstant ModifyArg ModifyArgs ModifyVariable ModifyExpressionValue
      ModifyReturnValue WrapOperation WrapWithCondition WrapMethod Overwrite Accessor Invoker Shadow(ignored)
A row with kind CLASS has no method: it records that the class is a Mixin for a target.
Names are compared as written in the annotations (Mojmap, SRG and intermediary spellings of
one method are not matched).
"""
import sys, os, io, zipfile, struct, csv

ANN_PREFIX = "Lorg/spongepowered/asm/mixin/"
EXTRAS = ("Lcom/llamalad7/mixinextras/",)


def u1(b, o): return b[o], o + 1
def u2(b, o): return struct.unpack_from(">H", b, o)[0], o + 2
def u4(b, o): return struct.unpack_from(">I", b, o)[0], o + 4


def parse_class(data):
    b = data
    if b[:4] != b"\xca\xfe\xba\xbe":
        return None
    o = 8
    n, o = u2(b, o)
    cp = [None] * n
    i = 1
    while i < n:
        t, o = u1(b, o)
        if t == 1:
            l, o = u2(b, o)
            cp[i] = ("utf8", b[o:o + l].decode("utf-8", "replace")); o += l
        elif t in (3, 4):
            o += 4; cp[i] = ("num",)
        elif t in (5, 6):
            o += 8; cp[i] = ("num",); i += 1
        elif t == 7:
            idx, o = u2(b, o); cp[i] = ("class", idx)
        elif t == 8:
            idx, o = u2(b, o); cp[i] = ("string", idx)
        elif t in (9, 10, 11, 12, 17, 18):
            o += 4; cp[i] = ("ref",)
        elif t == 15:
            o += 3; cp[i] = ("ref",)
        elif t == 16:
            o += 2; cp[i] = ("ref",)
        elif t in (19, 20):
            o += 2; cp[i] = ("ref",)
        else:
            return None
        i += 1

    def utf(idx):
        e = cp[idx]
        return e[1] if e and e[0] == "utf8" else None

    def cname(idx):
        e = cp[idx]
        return utf(e[1]) if e and e[0] == "class" else None

    o += 2  # access
    this_idx, o = u2(b, o)
    super_idx, o = u2(b, o)
    ic, o = u2(b, o); o += 2 * ic

    def elem(o):
        tag, o = u1(b, o)
        t = chr(tag)
        if t in "BCDFIJSZs":
            idx, o = u2(b, o)
            e = cp[idx]
            return (utf(idx) if t == "s" else None), o
        if t == "e":
            _, o = u2(b, o); v, o = u2(b, o); return utf(v), o
        if t == "c":
            v, o = u2(b, o); return utf(v), o
        if t == "@":
            a, o = ann(o); return a, o
        if t == "[":
            c, o = u2(b, o); out = []
            for _ in range(c):
                v, o = elem(o); out.append(v)
            return out, o
        raise ValueError("bad tag " + t)

    def ann(o):
        ti, o = u2(b, o)
        np_, o = u2(b, o)
        d = {}
        for _ in range(np_):
            ni, o = u2(b, o)
            v, o = elem(o)
            d[utf(ni)] = v
        return {"type": utf(ti), "v": d}, o

    def attrs(o):
        ac, o = u2(b, o)
        anns = []
        for _ in range(ac):
            ni, o = u2(b, o)
            l, o = u4(b, o)
            nm = utf(ni)
            end = o + l
            if nm in ("RuntimeInvisibleAnnotations", "RuntimeVisibleAnnotations"):
                c, p = u2(b, o)
                for _ in range(c):
                    a, p = ann(p)
                    anns.append(a)
            o = end
        return anns, o

    fc, o = u2(b, o)
    for _ in range(fc):
        o += 6
        _, o = attrs(o)
    mc, o = u2(b, o)
    methods = []
    for _ in range(mc):
        o += 2
        ni, o = u2(b, o); di, o = u2(b, o)
        anns, o = attrs(o)
        methods.append((utf(ni), utf(di), anns))
    canns, o = attrs(o)
    return {"name": cname(this_idx), "class_anns": canns, "methods": methods}


def flat(v):
    if v is None: return []
    if isinstance(v, list):
        out = []
        for x in v: out += flat(x)
        return out
    if isinstance(v, dict): return [v]
    return [v]


def at_info(v):
    vals, tg = [], []
    for a in flat(v):
        if isinstance(a, dict):
            d = a["v"]
            vals += [str(x) for x in flat(d.get("value"))]
            tg += [str(x) for x in flat(d.get("target"))]
    return vals, tg


KINDS = ["Inject", "Redirect", "ModifyConstant", "ModifyArgs", "ModifyArg", "ModifyVariable", "ModifyExpressionValue",
         "ModifyReturnValue", "WrapOperation", "WrapWithCondition", "WrapMethod", "Overwrite", "Accessor", "Invoker"]


def kind_of(t):
    if not t: return None
    n = t.rsplit("/", 1)[-1].rstrip(";")
    for k in KINDS:
        if n == k: return k
    return None


def scan_zip(zf, jarname, nested, rows):
    for name in zf.namelist():
        if name.endswith(".class") and not name.startswith("META-INF/versions"):
            try:
                info = parse_class(zf.read(name))
            except Exception as e:
                continue
            if not info: continue
            targets = []
            for a in info["class_anns"]:
                if a["type"] == ANN_PREFIX + "Mixin;":
                    d = a["v"]
                    for x in flat(d.get("value")):
                        x = str(x)
                        targets.append((x[1:-1] if x.startswith("L") and x.endswith(";") else x).replace("/", "."))
                    targets += [str(x).replace("/", ".") for x in flat(d.get("targets"))]
            if not targets: continue
            mixin_cls = info["name"].replace("/", ".")
            for t in targets:
                rows.append((jarname, nested, mixin_cls, t, "CLASS", "", "", "", ""))
            for mname, mdesc, anns in info["methods"]:
                for a in anns:
                    k = kind_of(a["type"])
                    if not k: continue
                    d = a["v"]
                    patt = [str(x) for x in flat(d.get("method"))] or [str(x) for x in flat(d.get("value"))] if k not in ("Overwrite", "Accessor", "Invoker") else [mname]
                    if k in ("Accessor", "Invoker"):
                        patt = [str(x) for x in flat(d.get("value"))] or [mname]
                    at_v, at_t = at_info(d.get("at"))
                    if k == "ModifyConstant":
                        at_v = ["CONSTANT"]; at_t = [str(c) for c in flat(d.get("constant"))]
                    if k == "Redirect" or k == "WrapOperation" or k == "WrapWithCondition":
                        pass
                    for t in targets:
                        rows.append((jarname, nested, mixin_cls, t, k, "|".join(patt), "|".join(at_v), "|".join(at_t), mname))
    for name in zf.namelist():
        if name.lower().endswith(".jar") and name.startswith("META-INF/jarjar/"):
            try:
                inner = zipfile.ZipFile(io.BytesIO(zf.read(name)))
                scan_zip(inner, jarname, nested + "!" + os.path.basename(name), rows)
            except Exception:
                pass


def main():
    out = sys.argv[1]
    rows = []
    for arg in sys.argv[2:]:
        paths = []
        if os.path.isdir(arg):
            for root, _, files in os.walk(arg):
                for f in files:
                    if f.lower().endswith(".jar"): paths.append(os.path.join(root, f))
        else:
            paths.append(arg)
        for p in sorted(paths):
            try:
                zf = zipfile.ZipFile(p)
            except Exception as e:
                print("skip", p, e, file=sys.stderr); continue
            scan_zip(zf, os.path.basename(os.path.dirname(p)) + "/" + os.path.basename(p) if os.path.isdir(arg) else os.path.basename(p), "", rows)
    with open(out, "w", newline="") as f:
        w = csv.writer(f, delimiter="\t")
        w.writerow(["jar", "nested", "mixin_class", "target_class", "kind", "method_patterns", "at_values", "at_targets", "java_method"])
        w.writerows(rows)
    print(len(rows), "rows from", len(set(r[0] for r in rows)), "jars")


main()

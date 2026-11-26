"""Parse Mixin annotations from the class files of jars (nested Jar-in-Jar included).
Python 3 standard library only. Reads jars as data, never runs anything from them.

Usage: python3 -I mixin_scan.py <out.json> <jar|dir> [<jar|dir> ...]
A directory is searched recursively for *.jar.
Output: a JSON list, one entry per top-level jar: mods, deps, jarjar, mixin classes
(target class, injector kind, method, hooked call) and nested jars.
"""
import sys, os, json, struct, zipfile, io, re

INJ = "Lorg/spongepowered/asm/mixin/injection/"
MXE = "Lcom/llamalad7/mixinextras/"


def utf(b):
    return b.decode("utf-8", "replace")


def parse_class(buf):
    """Return (methods, class_annotations); each annotation is (type, {name: value})."""
    p = 8
    (n,) = struct.unpack_from(">H", buf, p); p += 2
    U = {}
    i = 1
    while i < n:
        tag = buf[p]; p += 1
        if tag == 1:
            (l,) = struct.unpack_from(">H", buf, p); p += 2
            U[i] = utf(buf[p:p + l]); p += l
        elif tag in (3, 4): p += 4
        elif tag in (5, 6): p += 8; i += 1
        elif tag in (7, 8, 16, 19, 20): p += 2
        elif tag in (9, 10, 11, 12, 17, 18): p += 4
        elif tag == 15: p += 3
        else: raise ValueError("bad tag %d" % tag)
        i += 1
    p += 6  # access, this, super
    (ic,) = struct.unpack_from(">H", buf, p); p += 2 + ic * 2

    def u2():
        nonlocal p
        (v,) = struct.unpack_from(">H", buf, p); p += 2
        return v

    def elem():
        nonlocal p
        tag = chr(buf[p]); p += 1
        if tag in "sc":
            return U.get(u2())
        if tag == "e":
            u2(); return U.get(u2())
        if tag == "@":
            return ann()
        if tag == "[":
            c = u2()
            return [elem() for _ in range(c)]
        u2(); return None

    def ann():
        t = U.get(u2())
        c = u2()
        vals = {}
        for _ in range(c):
            name = U.get(u2())
            vals[name] = elem()
        return (t, vals)

    def attrs():
        nonlocal p
        out = []
        ac = u2()
        for _ in range(ac):
            name = U.get(u2())
            (ln,) = struct.unpack_from(">I", buf, p); p += 4
            end = p + ln
            if name in ("RuntimeInvisibleAnnotations", "RuntimeVisibleAnnotations"):
                c = u2()
                for _ in range(c):
                    out.append(ann())
            p = end
        return out

    fc = u2()
    for _ in range(fc):
        p += 6; attrs()
    mc = u2()
    methods = []
    for _ in range(mc):
        (nm,) = struct.unpack_from(">H", buf, p + 2)
        p += 6
        methods.append((U.get(nm), attrs()))
    class_anns = attrs()
    return methods, class_anns


def desc_to_name(d):
    s = d
    if s.startswith("L") and s.endswith(";"):
        s = s[1:-1]
    return s.replace("/", ".")


def parse_mods_toml(t):
    mods, deps = [], {}
    loader = ""
    m = re.search(r'^\s*modLoader\s*=\s*"([^"]+)"', t, re.M)
    if m: loader = m.group(1)
    for b in re.split(r"^\s*\[\[", t, flags=re.M)[1:]:
        head = b[:b.index("]]")]
        body = b[b.index("]]") + 2:]

        def kv(k):
            mm = re.search(r"^\s*" + k + r"""\s*=\s*(?:"([^"]*)"|'([^']*)'|([^\s#]+))""", body, re.M)
            return (mm.group(1) or mm.group(2) or mm.group(3) or "") if mm else ""

        if head == "mods":
            mods.append({"id": kv("modId"), "version": kv("version")})
        elif head.startswith("dependencies."):
            owner = head[len("dependencies."):].replace('"', "")
            deps.setdefault(owner, []).append({
                "modId": kv("modId"), "mandatory": kv("mandatory") or kv("type"),
                "versionRange": kv("versionRange"), "side": kv("side"), "ordering": kv("ordering")})
    return loader, mods, deps


def strip_json(s):
    s = s.lstrip("﻿")
    s = re.sub(r"/\*[\s\S]*?\*/", "", s)
    s = re.sub(r"^\s*//.*$", "", s, flags=re.M)
    return s


def scan_jar(name, data, depth):
    z = zipfile.ZipFile(io.BytesIO(data))
    names = set(z.namelist())
    info = {"file": name, "loader": "", "mods": [], "deps": {}, "jarjar": [], "mixins": [], "nested": [],
            "configs": [], "forge": "META-INF/mods.toml" in names, "fabric": "fabric.mod.json" in names,
            "neoforge": "META-INF/neoforge.mods.toml" in names}
    tt = ""
    if "META-INF/mods.toml" in names:
        tt = utf(z.read("META-INF/mods.toml"))
        info["loader"], info["mods"], info["deps"] = parse_mods_toml(tt)
    cfgs = set(re.findall(r'\[\[mixins\]\][^\[]*?config\s*=\s*"([^"]+)"', tt))
    if "META-INF/MANIFEST.MF" in names:
        mf = utf(z.read("META-INF/MANIFEST.MF")).replace("\r\n ", "").replace("\n ", "")
        mm = re.search(r"^MixinConfigs:\s*(.+)$", mf, re.M)
        if mm:
            cfgs.update(x.strip() for x in mm.group(1).split(","))
    for c in sorted(cfgs):
        if c not in names:
            continue
        try:
            j = json.loads(strip_json(utf(z.read(c))))
        except Exception:
            continue
        info["configs"].append({"file": c, "plugin": j.get("plugin"), "package": j.get("package"),
                                "refmap": j.get("refmap"), "required": j.get("required"),
                                "defaultRequire": (j.get("injectors") or {}).get("defaultRequire"),
                                "priority": j.get("priority")})
        refmap = {}
        if j.get("refmap") and j["refmap"] in names:
            try:
                rm = json.loads(strip_json(utf(z.read(j["refmap"]))))
                refmap = rm.get("mappings") or {}
                if not refmap:
                    refmap = (rm.get("data") or {}).get("searge") or {}
            except Exception:
                refmap = {}
        pkg = (j.get("package") or "").replace(".", "/")
        lst = list(j.get("mixins") or []) + list(j.get("client") or []) + list(j.get("server") or [])
        for m in lst:
            path = pkg + "/" + m.replace(".", "/") + ".class"
            if path not in names:
                continue
            try:
                methods, canns = parse_class(z.read(path))
            except Exception:
                continue
            mx = [a for a in canns if a[0] == "Lorg/spongepowered/asm/mixin/Mixin;"]
            if not mx:
                continue
            vals = mx[0][1]
            targets = [desc_to_name(v) for v in (vals.get("value") or [])]
            targets += [str(v).replace("/", ".") for v in (vals.get("targets") or [])]
            hs = []
            rmap = refmap.get(path[:-6], {})
            for mname, anns in methods:
                for t, v in anns:
                    if not (t.startswith(INJ) or t.startswith(MXE) or t == "Lorg/spongepowered/asm/mixin/Overwrite;"):
                        continue
                    short = re.sub(r"^L.*/", "", t).rstrip(";")
                    ms = []
                    rms = []
                    if v.get("method"):
                        ms = [re.sub(r"^L.*?;", "", re.sub(r"\(.*$", "", str(x))) for x in v["method"]]
                        for x in v["method"]:
                            r = rmap.get(str(x))
                            mm = re.search(r"(m_\d+_)", r) if r else None
                            rms.append(mm.group(1) if mm else "")
                    elif t.endswith("Overwrite;"):
                        ms = [mname]
                        rms = [""]
                    atv = v.get("at")
                    atl = atv if isinstance(atv, list) else ([atv] if atv else [])
                    ats = []
                    for a in atl:
                        if isinstance(a, tuple):
                            av = a[1]
                            raw = str(av.get("target") or av.get("value") or "")
                            ats.append(rmap.get(raw, raw))
                    ats = [x for x in ats if x]
                    hs.append({"ann": short, "methods": ms, "rmethods": rms, "ats": ats})
            info["mixins"].append({"cls": (j.get("package") or "") + "." + m, "targets": targets, "handlers": hs})
    for n in sorted(names):
        if n.startswith("META-INF/jarjar/") and n.endswith(".jar"):
            info["jarjar"].append(n[len("META-INF/jarjar/"):])
            if depth < 2:
                try:
                    info["nested"].append(scan_jar(n, z.read(n), depth + 1))
                except Exception:
                    pass
    return info


def main():
    out = sys.argv[1]
    paths = []
    for a in sys.argv[2:]:
        if os.path.isdir(a):
            for r, _, fs in os.walk(a):
                for f in fs:
                    if f.endswith(".jar"):
                        paths.append(os.path.join(r, f))
        else:
            paths.append(a)
    res = []
    for p in sorted(paths):
        try:
            res.append(scan_jar(os.path.basename(p), open(p, "rb").read(), 0))
        except Exception as e:
            res.append({"file": os.path.basename(p), "error": str(e), "mods": [], "deps": {}, "jarjar": [], "mixins": [], "nested": [], "configs": []})
    json.dump(res, open(out, "w"))
    print("scanned", len(res), "jars,", sum(len(j["mixins"]) for j in res), "mixin classes (top level)")


main()

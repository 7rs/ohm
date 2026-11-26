"""Class and member reference checks between jars. Python 3 standard library only; jars are read as data.

Usage:
  python3 -I refcheck.py members <consumer.jar> [--prefix=<internal/name/prefix/>] <provider.jar> [...]
      (--prefix also lists classes with that prefix that the consumer references but no provider has)
      Every field or method reference of the consumer whose owner class sits in a provider jar is
      looked up (owner, then its super classes and interfaces while they sit in a provider).
      Prints: references into the providers, resolved, missing, unknown (chain leaves the providers).
  python3 -I refcheck.py prefixes <jar> <prefix1> [<prefix2> ...]
      Counts the class references (constant pool) of every class in the jar (nested jars included)
      that start with one of the internal-name prefixes, e.g. com/github/alexthe666/citadel/
"""
import sys, struct, zipfile, io, collections


def parse(buf):
    p = 8
    (n,) = struct.unpack_from(">H", buf, p); p += 2
    utf, cls, nat, refs = {}, {}, {}, []
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
        elif t in (9, 10, 11):
            a, b = struct.unpack_from(">HH", buf, p); p += 4
            refs.append((t, a, b))
        elif t == 12:
            a, b = struct.unpack_from(">HH", buf, p); p += 4
            nat[i] = (a, b)
        elif t in (17, 18): p += 4
        elif t == 15: p += 3
        else: raise ValueError(t)
        i += 1
    acc, this, sup = struct.unpack_from(">HHH", buf, p); p += 6
    (ic,) = struct.unpack_from(">H", buf, p); p += 2
    ifs = list(struct.unpack_from(">%dH" % ic, buf, p)); p += 2 * ic

    def skip_attrs():
        nonlocal p
        (ac,) = struct.unpack_from(">H", buf, p); p += 2
        for _ in range(ac):
            (ln,) = struct.unpack_from(">I", buf, p + 2); p += 6 + ln

    fields, methods = set(), set()
    (fc,) = struct.unpack_from(">H", buf, p); p += 2
    for _ in range(fc):
        _, nm, ds = struct.unpack_from(">HHH", buf, p); p += 6
        fields.add((utf[nm], utf[ds])); skip_attrs()
    (mc,) = struct.unpack_from(">H", buf, p); p += 2
    for _ in range(mc):
        _, nm, ds = struct.unpack_from(">HHH", buf, p); p += 6
        methods.add((utf[nm], utf[ds])); skip_attrs()
    name = utf[cls[this]]
    superc = utf[cls[sup]] if sup else None
    ifn = [utf[cls[x]] for x in ifs]
    members = []
    for t, a, b in refs:
        owner = utf.get(cls.get(a, 0))
        if b in nat:
            nm, ds = utf.get(nat[b][0]), utf.get(nat[b][1])
            members.append((t, owner, nm, ds))
    classnames = {utf[v] for v in cls.values() if v in utf}
    return dict(name=name, super=superc, ifs=ifn, fields=fields, methods=methods, members=members, classnames=classnames)


def load_jar(data, out, depth=0):
    z = zipfile.ZipFile(io.BytesIO(data))
    for n in z.namelist():
        if n.endswith(".class") and not n.startswith("META-INF/versions/"):
            try:
                c = parse(z.read(n))
            except Exception:
                continue
            out[c["name"]] = c
        elif n.startswith("META-INF/jarjar/") and n.endswith(".jar") and depth < 2:
            load_jar(z.read(n), out, depth + 1)


def classes_of(path):
    out = {}
    load_jar(open(path, "rb").read(), out)
    return out


def members_mode(consumer, providers, prefix=None):
    cons = classes_of(consumer)
    prov = {}
    for p in providers:
        prov.update(classes_of(p))
    own = set(cons)
    seen = set()
    resolved = missing = unknown = 0
    miss_list, unk_list = [], collections.Counter()
    for c in cons.values():
        for t, owner, nm, ds in c["members"]:
            if not owner or owner.startswith("[") or owner in own or owner not in prov:
                continue
            key = (t, owner, nm, ds)
            if key in seen:
                continue
            seen.add(key)
            kind = "field" if t == 9 else "method"
            found, left, stack, vis = False, False, [owner], set()
            while stack:
                o = stack.pop()
                if o in vis:
                    continue
                vis.add(o)
                k = prov.get(o)
                if k is None:
                    left = True
                    continue
                if (nm, ds) in (k["fields"] if kind == "field" else k["methods"]):
                    found = True; break
                if k["super"]: stack.append(k["super"])
                stack.extend(k["ifs"])
            if found:
                resolved += 1
            elif left:
                unknown += 1; unk_list[owner] += 1
            else:
                missing += 1; miss_list.append("%s.%s%s" % (owner, nm, ds))
    classes_ref = set()
    for c in cons.values():
        for n in c["classnames"]:
            if n in prov and n not in own:
                classes_ref.add(n)
    print("%s -> %s: classes referenced in providers=%d | member refs into providers=%d resolved=%d missing=%d unknown(chain leaves providers)=%d"
          % (consumer.split("/")[-1], ",".join(p.split("/")[-1] for p in providers), len(classes_ref), len(seen), resolved, missing, unknown))
    for m in miss_list[:25]:
        print("   MISSING", m)
    if prefix:
        allrefs = set()
        for c in cons.values():
            allrefs |= {n.lstrip("[").removeprefix("L").removesuffix(";") if n.startswith("[") else n for n in c["classnames"]}
        gone = sorted(n for n in allrefs if n.startswith(prefix) and n not in prov and n not in own)
        print("   classes with prefix %s referenced but absent from the providers: %d %s" % (prefix, len(gone), gone[:10]))


def prefixes_mode(jar, prefs):
    allc = classes_of(jar)
    cnt = collections.Counter()
    ex = {}
    for c in allc.values():
        hit = set()
        for n in c["classnames"]:
            for p in prefs:
                if n.startswith(p):
                    hit.add(p); ex.setdefault(p, (c["name"], n))
        for p in hit:
            cnt[p] += 1
    print(jar.split("/")[-1], "classes", len(allc))
    for p in prefs:
        print("   %-45s referencing classes: %d  e.g. %s" % (p, cnt[p], ex.get(p, "")))


if __name__ == "__main__":
    mode = sys.argv[1]
    if mode == "members":
        args = sys.argv[3:]
        prefix = None
        if args and args[0].startswith("--prefix="):
            prefix = args[0][len("--prefix="):]; args = args[1:]
        members_mode(sys.argv[2], args, prefix)
    elif mode == "prefixes":
        prefixes_mode(sys.argv[2], sys.argv[3:])

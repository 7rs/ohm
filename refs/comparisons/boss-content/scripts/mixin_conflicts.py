"""Compare the Mixin entries of candidate jars against installed jars.
Usage: python3 -I mixin_conflicts.py <candidates.json> <installed.json> [<out.txt>]
(out.txt also gets a sibling <out>_detail.txt with every shared method.)

Hard conflict: same target class and method, same exclusive kind (Redirect or ModifyConstant)
on the same hooked call. Overwrite pair: @Overwrite on a method another jar also hooks.
Shared: any other injector on the same target method (plain injects are shared, not a conflict).
A method matches when its SRG name (resolved through the jar's refmap) is equal, or its name as
written is equal. A mixin that a plugin switches off at load is not known.
"""
import sys, json, re, collections

cand = json.load(open(sys.argv[1]))
inst = json.load(open(sys.argv[2]))
outp = sys.argv[3] if len(sys.argv) > 3 else None
EXCL = {"Redirect", "ModifyConstant"}


def entries(top, j, out):
    """Entry: dict(jar, target, keys, srg, kind, ats, cls, name)."""
    for m in j["mixins"]:
        for t in m["targets"]:
            for h in m["handlers"]:
                ms = h["methods"] or [""]
                rs = h.get("rmethods") or [""] * len(ms)
                for me, rme in zip(ms, rs):
                    if not me:
                        continue
                    keys = {me} | ({rme} if rme else set())
                    out.append(dict(jar=top, target=t, keys=keys, srg=rme, kind=h["ann"], ats=h["ats"], cls=m["cls"], name=me))
    for n in j.get("nested", []):
        entries(top, n, out)


def norm(s):
    s = re.sub(r"\s+", "", s)
    return s[1:] if s.startswith("L") else s


def short(f):
    return re.sub(r"\.jar$", "", f)[:40]


inst_e = []
for j in inst:
    entries(j["file"], j, inst_e)
idx = collections.defaultdict(list)
for i, e in enumerate(inst_e):
    for k in e["keys"]:
        idx[(e["target"], k)].append(i)

lines, detail = [], []
for c in cand:
    ce = []
    entries(c["file"], c, ce)
    hard, ow, shared = set(), set(), collections.Counter()
    nsrg = sum(1 for e in ce if e["srg"])
    for e in ce:
        seen = set()
        for k in e["keys"]:
            for i in idx.get((e["target"], k), []):
                if i in seen:
                    continue
                seen.add(i)
                o = inst_e[i]
                if o["jar"] == c["file"]:
                    continue
                label = "%s#%s" % (e["target"].split(".")[-1], e["srg"] or e["name"])
                if e["kind"] in EXCL and e["kind"] == o["kind"] and e["ats"] and o["ats"]:
                    same = [a for a in e["ats"] if any(norm(a) == norm(b) for b in o["ats"])]
                    if same:
                        hard.add("%s %s on %s <-> %s" % (label, e["kind"], same[0], short(o["jar"])))
                if e["kind"] == "Overwrite" or o["kind"] == "Overwrite":
                    ow.add("%s [%s vs %s] <-> %s" % (label, e["kind"], o["kind"], short(o["jar"])))
                shared[short(o["jar"])] += 1
                detail.append("%s | %s | candidate %s | %s %s" % (c["file"][:40], label, e["kind"], short(o["jar"]), o["kind"]))
    nm = len(c["mixins"]) + sum(len(n["mixins"]) for n in c.get("nested", []))
    lines.append("=== %s  mixin classes: %d  hard conflicts: %d  overwrite pairs: %d  shared-method entries: %d (handler methods resolved to SRG through the refmap: %d of %d)"
                 % (c["file"], nm, len(hard), len(ow), sum(shared.values()), nsrg, len(ce)))
    lines += ["   HARD " + x for x in sorted(hard)]
    lines += ["   OVERWRITE " + x for x in sorted(ow)]
    lines += ["   SHARED with %s: %d" % (k, v) for k, v in shared.most_common(12)]
txt = "\n".join(lines)
print(txt)
if outp:
    open(outp, "w").write(txt + "\n")
    open(re.sub(r"\.txt$", "", outp) + "_detail.txt", "w").write("\n".join(sorted(set(detail))) + "\n")

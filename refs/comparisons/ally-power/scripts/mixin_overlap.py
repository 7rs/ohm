#!/usr/bin/env python3
"""Compare candidate mixin rows with installed mixin rows (output of mixin_scan.py).
usage: mixin_overlap.py CANDIDATES.tsv INSTALLED.tsv OUT.md CAND_JAR_SUBSTRING [...]
A hard conflict (project rule): same Redirect or ModifyConstant call, or an Overwrite on a method
another mod hooks. Everything else on the same method is reported as shared. Names are compared as
written; a mixin that a plugin disables at load is not known."""
import sys, csv, re, collections
cand_f, inst_f, out = sys.argv[1:4]
sel = sys.argv[4:]
def load(fn):
    r = list(csv.DictReader(open(fn), delimiter="\t"))
    return r
cand = [r for r in load(cand_f) if any(s in r["jar"] for s in sel)]
inst = load(inst_f)
def meths(r):
    out = []
    for m in r["method_patterns"].split("|"):
        m = m.strip()
        if not m: continue
        m = m.split("(")[0]
        m = m.split(";")[-1] if ";" in m else m
        out.append(m)
    return set(out)
idx = collections.defaultdict(list)
for r in inst:
    if r["kind"] in ("CLASS",): continue
    idx[r["target_class"]].append(r)
HARD = ("Redirect", "ModifyConstant")
res = collections.OrderedDict()
for c in cand:
    if c["kind"] in ("CLASS", "Accessor", "Invoker"): continue
    key = c["jar"]
    for i in idx.get(c["target_class"], []):
        if i["kind"] in ("Accessor", "Invoker"): continue
        common = meths(c) & meths(i)
        if not common: continue
        hard = False; why = ""
        if c["kind"] == "Overwrite" or i["kind"] == "Overwrite":
            hard = True; why = "Overwrite"
        elif c["kind"] in HARD and i["kind"] == c["kind"] and c["at_targets"] and c["at_targets"] == i["at_targets"]:
            hard = True; why = "same " + c["kind"] + " call"
        res.setdefault(key, []).append((hard, why, c, i, sorted(common)))
with open(out, "w") as f:
    f.write("# Mixin overlap of candidates with the installed jars\n\n")
    for jar, lst in res.items():
        hards = [x for x in lst if x[0]]
        f.write(f"## {jar}\n\n- same class and method as an installed mixin: {len(lst)} pairs; hard-conflict candidates: {len(hards)}\n\n")
        by = collections.OrderedDict()
        for hard, why, c, i, common in lst:
            k = (c["target_class"], ",".join(common), c["kind"], c["at_targets"][:60])
            by.setdefault(k, []).append((hard, why, i))
        f.write("| Target class | Method | Candidate hook | Installed mods on the same method (kind) | Hard? |\n|---|---|---|---|---|\n")
        for (tc, m, kind, at), items in by.items():
            names = sorted(set(f"{x[2]['jar'].split('/')[0]}({x[2]['kind']})" for x in items))
            hard = "YES: " + "; ".join(sorted(set(x[1] for x in items if x[0]))) if any(x[0] for x in items) else "no"
            f.write(f"| {tc.split('.')[-1]} | {m} | {kind} {('@' + at) if at else ''} | {', '.join(names)} | {hard} |\n")
        f.write("\n")
print({k: (len(v), sum(1 for x in v if x[0])) for k, v in res.items()})

#!/usr/bin/env python3
"""Find KeyMapping constructions with default key codes for F-keys in the jars (bytecode, via javap).
usage: keyscan.py OUT.tsv JARDIR codes..."""
import sys, os, zipfile, subprocess, re, io, tempfile
out, root = sys.argv[1], sys.argv[2]
codes = {int(c) for c in sys.argv[3:]}
rows = []
for dp, _, fs in os.walk(root):
    for f in fs:
        if not f.endswith(".jar"): continue
        jp = os.path.join(dp, f)
        try: zf = zipfile.ZipFile(jp)
        except Exception: continue
        names = []
        for n in zf.namelist():
            if n.endswith(".class") and not n.startswith("META-INF/versions"):
                d = zf.read(n)
                if b"net/minecraft/client/KeyMapping" in d and b"<init>" in d:
                    names.append(n[:-6].replace("/", "."))
        for i in range(0, len(names), 60):
            chunk = names[i:i+60]
            p = subprocess.run(["javap", "-p", "-c", "-cp", jp] + chunk, capture_output=True, text=True)
            cur = None; win = []
            for line in p.stdout.splitlines():
                m = re.match(r'^(?:public |final |abstract )*(?:class|interface) (\S+)', line)
                if m: cur = m.group(1)
                win.append(line)
                if len(win) > 16: win.pop(0)
                if 'net/minecraft/client/KeyMapping."<init>"' in line:
                    txt = " ".join(win)
                    for mm in re.finditer(r'(?:sipush|bipush|ldc)\s+(\d+)', txt):
                        v = int(mm.group(1))
                        if v in codes:
                            strs = re.findall(r'String ([\w\.\-]+)', txt)
                            rows.append((os.path.basename(dp) + "/" + f, cur, v, strs[-1] if strs else ""))
with open(out, "w") as fh:
    for r in sorted(set(rows)): fh.write("\t".join(map(str, r)) + "\n")
print(len(set(rows)), "hits")

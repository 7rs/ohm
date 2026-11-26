#!/bin/bash
# usage: refcheck.sh <extracted-dir> <label>
SP="/c/Users/taiko/AppData/Local/Temp/claude/803ae1ca5c3f9b75/44765748-fbad-4107-9046-555d9a58f1d9/scratchpad"
JP="/c/Users/taiko/AppData/Roaming/PrismLauncher/java/java-runtime-gamma/bin/javap.exe"
L="C:/Users/taiko/AppData/Roaming/PrismLauncher/libraries"
CP="$L/net/minecraftforge/forge/1.20.1-47.4.28/forge-1.20.1-47.4.28-client.jar;$L/net/minecraft/client/1.20.1-20230612.114412/client-1.20.1-20230612.114412-srg.jar;$L/net/minecraftforge/forge/1.20.1-47.4.28/forge-1.20.1-47.4.28-universal.jar;$L/net/minecraftforge/fmlcore/1.20.1-47.4.28/fmlcore-1.20.1-47.4.28.jar;$L/net/minecraftforge/javafmllanguage/1.20.1-47.4.28/javafmllanguage-1.20.1-47.4.28.jar;$L/net/minecraftforge/eventbus/6.0.5/eventbus-6.0.5.jar"
DIR="$1"; LABEL="$2"; OUT="$SP/refcheck/$LABEL"; mkdir -p "$OUT/members"
cd "$DIR"
# 1. refs
find . -name '*.class' | sed 's#^\./##; s#\.class$##; s#/#.#g' | while read -r c; do "$JP" -v -p -cp . "$c" 2>/dev/null | grep -E '^ +#[0-9]+ = (Methodref|InterfaceMethodref|Fieldref) ' | sed -E 's#.*// ##'; done | sort -u > "$OUT/refs_all.txt"
grep -E '^(net/minecraft/|com/mojang/blaze3d/|net/minecraftforge/)' "$OUT/refs_all.txt" > "$OUT/refs_mc.txt"
echo "refs total: $(wc -l < "$OUT/refs_all.txt"), to MC/Forge: $(wc -l < "$OUT/refs_mc.txt")"
# 2. owners
cut -d. -f1 "$OUT/refs_mc.txt" | sort -u > "$OUT/owners.txt"
members() { # owner internal name -> file
  o="$1"; f="$OUT/members/$(echo "$o" | tr '/$' '__').txt"
  [ -f "$f" ] && { echo "$f"; return; }
  cn=$(echo "$o" | tr '/' '.')
  "$JP" -p -s -cp "$CP" "$cn" 2>/dev/null | awk '
    /^(public |protected |private |abstract |final |static |interface |class )*(class|interface|enum) / { sub(/\{ *$/,""); print "HEAD\t" $0; next }
    /^  [^ ].*\);$/ && !/^  static \{\};/ { line=$0; sub(/\);$/,"",line); sub(/\(.*$/,"",line); n=split(line,a," "); nm=a[n]; sig=1; next }
    /^  static \{\};/ { nm="<clinit>"; sig=1; next }
    /^  [^ ].*;$/ { line=$0; sub(/;$/,"",line); n=split(line,a," "); nm=a[n]; sig=1; next }
    /^    descriptor: / && sig==1 { d=$0; sub(/^    descriptor: /,"",d); print "M\t" nm "\t" d; sig=0 }
  ' > "$f"
  echo "$f"
}

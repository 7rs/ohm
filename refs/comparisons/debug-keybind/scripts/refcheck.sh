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
unres=0; total=0
: > "$OUT/unresolved.txt"
resolve() { # owner name desc depth
  o="$1"; n="$2"; d="$3"; dep="$4"; [ "$dep" -gt 12 ] && return 1
  f=$(members "$o"); [ -s "$f" ] || return 2
  # constructor mapping: javap prints constructor as class name
  if grep -qP "^M\t\Q$n\E\t\Q$d\E\$" "$f"; then return 0; fi
  if [ "$n" = '"<init>"' ] || [ "$n" = '<init>' ]; then
    short=$(echo "$o" | sed 's#.*/##; s#.*\$##')
    grep -qP "^M\t(\Q$o\E|\Q$(echo "$o" | tr '/' '.')\E|\Q$short\E)\t\Q$d\E\$" "$f" && return 0
    # javap prints ctor name as fully qualified class name
    grep -qP "^M\t[^\t]*\t\Q$d\E\$" "$f" && grep -P "^M\t" "$f" | awk -F'\t' -v d="$d" '$3==d && $2 ~ /\./ {f=1} END{exit f?0:1}' && return 0
  fi
  # supers
  head=$(grep '^HEAD' "$f" | head -1)
  for s in $(echo "$head" | sed -E 's/^HEAD\t//; s/<[^<>]*>//g; s/<[^<>]*>//g' | sed -E 's/.*(extends|implements) //; s/,/ /g; s/ implements / /; s/ extends / /' ); do
    case "$s" in extends|implements|"") continue;; esac
    si=$(echo "$s" | tr '.' '/')
    case "$si" in java/*|javax/*) continue;; esac
    resolve "$si" "$n" "$d" $((dep+1)) && return 0
  done
  return 1
}
while IFS= read -r r; do
  owner="${r%%.*}"; rest="${r#*.}"; name="${rest%%:*}"; desc="${rest#*:}"
  total=$((total+1))
  resolve "$owner" "$name" "$desc" 0; rc=$?
  if [ $rc -ne 0 ]; then unres=$((unres+1)); echo "$rc $r" >> "$OUT/unresolved.txt"; fi
done < "$OUT/refs_mc.txt"
echo "$LABEL: checked $total refs; unresolved $unres (rc 1 = member not found, 2 = owner class not on classpath)"

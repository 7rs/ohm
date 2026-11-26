#!/bin/bash
SP="/c/Users/taiko/AppData/Local/Temp/claude/803ae1ca5c3f9b75/44765748-fbad-4107-9046-555d9a58f1d9/scratchpad"
JP="/c/Users/taiko/AppData/Roaming/PrismLauncher/java/java-runtime-gamma/bin/javap.exe"
L="C:/Users/taiko/AppData/Roaming/PrismLauncher/libraries"
CP="$L/net/minecraftforge/forge/1.20.1-47.4.28/forge-1.20.1-47.4.28-client.jar;$L/net/minecraft/client/1.20.1-20230612.114412/client-1.20.1-20230612.114412-srg.jar;$L/net/minecraftforge/forge/1.20.1-47.4.28/forge-1.20.1-47.4.28-universal.jar;$L/net/minecraftforge/fmlcore/1.20.1-47.4.28/fmlcore-1.20.1-47.4.28.jar;$L/net/minecraftforge/javafmllanguage/1.20.1-47.4.28/javafmllanguage-1.20.1-47.4.28.jar;$L/net/minecraftforge/eventbus/6.0.5/eventbus-6.0.5.jar"
DIR="$1"; LABEL="$2"; OUT="$SP/refcheck/$LABEL"; rm -rf "$OUT/members" "$OUT/unresolved.txt"; mkdir -p "$OUT/members"
[ -s "$OUT/refs_mc.txt" ] || { echo "run refcheck.sh first"; exit 1; }
members() {
  o="$1"; f="$OUT/members/$(echo "$o" | tr '/$' '__').txt"
  [ -f "$f" ] && { echo "$f"; return; }
  cn=$(echo "$o" | tr '/' '.')
  "$JP" -p -s -cp "$CP" "$cn" 2>/dev/null | awk '
    /^(public |protected |private |abstract |final |static |sealed |non-sealed )*(class|interface|enum|record) / { l=$0; sub(/ *\{ *$/,"",l); print "HEAD\t" l; next }
    /^  static \{\};/ { nm="<clinit>"; sig=1; next }
    /^  [^ ].*\);$/ { line=$0; sub(/\);$/,"",line); sub(/\(.*$/,"",line); n=split(line,a," "); nm=a[n]; sig=1; next }
    /^  [^ ].*;$/ { line=$0; sub(/;$/,"",line); n=split(line,a," "); nm=a[n]; sig=1; next }
    /^    descriptor: / && sig==1 { d=$0; sub(/^    descriptor: /,"",d); print "M\t" nm "\t" d; sig=0 }
  ' > "$f"
  echo "$f"
}
resolve() {
  o="$1"; n="$2"; d="$3"; dep="$4"; [ "$dep" -gt 14 ] && return 1
  f=$(members "$o"); [ -s "$f" ] || return 2
  n2="${n//\"/}"
  if [ "$n2" = "<init>" ]; then
    awk -F'\t' -v d="$d" '$1=="M" && $3==d && ($2 ~ /^[A-Za-z0-9_.$]+$/) {found=1} END{exit found?0:1}' "$f" && return 0
    return 1
  fi
  awk -F'\t' -v n="$n2" -v d="$d" '$1=="M" && $2==n && $3==d {found=1} END{exit found?0:1}' "$f" && return 0
  for s in $(grep '^HEAD' "$f" | head -1 | awk -f "$SP/scripts/supers.awk"); do
    si=$(echo "$s" | tr '.' '/')
    case "$si" in java/*|javax/*) continue;; esac
    resolve "$si" "$n" "$d" $((dep+1)) && return 0
  done
  return 1
}
unres=0; total=0; : > "$OUT/unresolved.txt"
while IFS= read -r r; do
  owner="${r%%.*}"; rest="${r#*.}"; name="${rest%%:*}"; desc="${rest#*:}"
  total=$((total+1))
  resolve "$owner" "$name" "$desc" 0; rc=$?
  if [ $rc -ne 0 ]; then unres=$((unres+1)); echo "$rc $r" >> "$OUT/unresolved.txt"; fi
done < "$OUT/refs_mc.txt"
echo "$LABEL: checked $total refs; unresolved $unres (rc 1 = member not found, 2 = owner class not on classpath)"

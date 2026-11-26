#!/bin/bash
SP="/c/Users/taiko/AppData/Local/Temp/claude/803ae1ca5c3f9b75/44765748-fbad-4107-9046-555d9a58f1d9/scratchpad"
ex() {
  jar="$1"; slug=$(basename "$jar" .jar); d="$SP/x/$slug"
  [ -d "$d" ] && return 0
  mkdir -p "$d/main"
  7z x -y -r -bso0 -bsp0 -o"$d/main" "$jar" '*.class' '*.json' 'META-INF/jars/*.jar' >/dev/null 2>&1
  if [ -d "$d/main/META-INF/jars" ]; then
    for n in "$d"/main/META-INF/jars/*.jar; do
      [ -f "$n" ] || continue
      nn=$(basename "$n" .jar); mkdir -p "$d/nested/$nn"
      7z x -y -r -bso0 -bsp0 -o"$d/nested/$nn" "$n" '*.class' '*.json' >/dev/null 2>&1
    done
  fi
}
export -f ex; export SP
ls "$SP"/jars/installed/*.jar | xargs -P 8 -I{} bash -c 'ex "$@"' _ {}
echo done > "$SP/x/_done.txt"

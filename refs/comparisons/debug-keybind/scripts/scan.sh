#!/bin/bash
SP="/c/Users/taiko/AppData/Local/Temp/claude/803ae1ca5c3f9b75/44765748-fbad-4107-9046-555d9a58f1d9/scratchpad"
JP="/c/Users/taiko/AppData/Roaming/PrismLauncher/java/java-runtime-gamma/bin/javap.exe"
one() {
  f="$1"   # relative path under x/
  rel="${f#./}"; slug="${rel%%/*}"
  rest="${rel#*/}"      # main/... or nested/<n>/...
  if [[ "$rest" == nested/* ]]; then r2="${rest#nested/}"; nn="${r2%%/*}"; root="$SP/x/$slug/nested/$nn"; cpath="${r2#*/}"; tag="$slug[nested:$nn]"; else root="$SP/x/$slug/main"; cpath="${rest#main/}"; tag="$slug"; fi
  cn="${cpath%.class}"; cn="${cn//\//.}"
  "$JP" -v -p -cp "$root" "$cn" 2>/dev/null | awk -v cls="$tag	$cn" -f "$SP/scripts/ann.awk"
}
export -f one; export SP JP
cd "$SP/x"
cat "$SP/scripts/cand2.txt" | xargs -P 6 -d '\n' -I{} bash -c 'one "$@"' _ {} > "$SP/scripts/scan_raw.tsv"
wc -l "$SP/scripts/scan_raw.tsv"

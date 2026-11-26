#!/bin/bash
SP="/c/Users/taiko/AppData/Local/Temp/claude/803ae1ca5c3f9b75/44765748-fbad-4107-9046-555d9a58f1d9/scratchpad"
dl() {
  IFS=$'\t' read -r slug side fn url hf h <<< "$1"
  out="$SP/jars/installed/$slug.jar"
  [ -s "$out" ] && return 0
  curl -sL --fail --retry 2 -A "ohm-pack-research/1.0" -o "$out" "$url" || echo "FAIL $slug $url" >> "$SP/jars/dl_fail.txt"
}
export -f dl; export SP
grep -vE "^(gt-craft-ivmts|immersive-vehicles-official-content-pack)	" "$SP/scripts/urls.tsv" | tr -d '\r' | xargs -P 8 -d '\n' -I{} bash -c 'dl "$@"' _ {}
echo done > "$SP/jars/dl_done.txt"

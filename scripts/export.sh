#!/bin/sh
set -eu

MANUAL_MODS="immersive-vehicles-craftspeed"

usage() {
  echo "usage: sh scripts/export.sh [modrinth|curseforge] [output]" >&2
  exit 2
}

cd "$(dirname "$0")/.."

platform=${1:-modrinth}
output=${2:-}
case "$platform" in
  modrinth | curseforge) ;;
  *) usage ;;
esac

if ! command -v packwiz >/dev/null 2>&1; then
  echo "packwiz not found in PATH. Install it: https://packwiz.infra.link/installation/" >&2
  exit 1
fi

case "$(uname -s)" in
  Darwin) cache_home="$HOME/Library/Caches" ;;
  MINGW* | MSYS* | CYGWIN*) cache_home=$(cygpath -u "${LOCALAPPDATA:?LOCALAPPDATA is not set}") ;;
  *) cache_home="${XDG_CACHE_HOME:-$HOME/.cache}" ;;
esac
import_dir="$cache_home/packwiz/cache/import"
cache_index="$cache_home/packwiz/cache/index.json"

urlencode() {
  LC_ALL=C awk '
    BEGIN { for (i = 0; i < 256; i++) hex[sprintf("%c", i)] = sprintf("%%%02X", i) }
    {
      for (i = 1; i <= length($0); i++) {
        c = substr($0, i, 1)
        printf "%s", (c ~ /[A-Za-z0-9._~-]/) ? c : hex[c]
      }
    }'
}

digest() {
  if command -v "${1}sum" >/dev/null 2>&1; then
    "${1}sum" "$2" | cut -d ' ' -f 1
  else
    shasum -a "${1#sha}" "$2" | cut -d ' ' -f 1
  fi
}

fetch_manual() {
  meta="mods/$1.pw.toml"
  [ -f "$meta" ] || { echo "$meta not found" >&2; return 1; }
  name=$(sed -n 's/^filename = "\(.*\)"$/\1/p' "$meta")
  file_id=$(sed -n 's/^file-id = \([0-9]*\)$/\1/p' "$meta")
  hash_format=$(sed -n 's/^hash-format = "\(.*\)"$/\1/p' "$meta")
  hash=$(sed -n 's/^hash = "\(.*\)"$/\1/p' "$meta")
  dest="$import_dir/$name"

  if [ -f "$cache_index" ] && grep -qF "\"$hash\"" "$cache_index"; then
    echo "in packwiz cache: $name"
    return 0
  fi
  if [ -f "$dest" ] && [ "$(digest "$hash_format" "$dest")" = "$hash" ]; then
    echo "in import folder: $name"
    return 0
  fi

  echo "downloading: $name"
  url="https://edge.forgecdn.net/files/$((file_id / 1000))/$((file_id % 1000))/$(printf '%s' "$name" | urlencode)"
  curl -fsSL --retry 3 -o "$dest.part" "$url" || { rm -f "$dest.part"; return 1; }
  if [ "$(digest "$hash_format" "$dest.part")" != "$hash" ]; then
    rm -f "$dest.part"
    echo "hash mismatch: $name" >&2
    return 1
  fi
  mv -f "$dest.part" "$dest"
}

if [ "$platform" = modrinth ]; then
  mkdir -p "$import_dir"
  for slug in $MANUAL_MODS; do
    fetch_manual "$slug"
  done
fi

if [ -n "$output" ]; then
  exec packwiz "$platform" export --output "$output"
fi
exec packwiz "$platform" export

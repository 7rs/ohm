let dir = "C:/Users/taiko/w/ohm/mods"
ls $dir | where name =~ '\.pw\.toml$' | each {|f|
  let t = (open $f.name)
  let slug = ($f.name | path basename | str replace '.pw.toml' '')
  let url = if ("url" in ($t.download | columns)) {
    $t.download.url
  } else {
    let id = ($t.update.curseforge."file-id" | into string)
    let a = ($id | str substring 0..3)
    let b = ($id | str substring 4..)
    let fn = ($t.filename | url encode)
    $"https://edge.forgecdn.net/files/($a)/($b | into int)/($fn)"
  }
  {slug: $slug, side: $t.side, filename: $t.filename, url: $url, hashfmt: $t.download."hash-format", hash: $t.download.hash}
} | to tsv --noheaders | save -f "C:/Users/taiko/AppData/Local/Temp/claude/803ae1ca5c3f9b75/44765748-fbad-4107-9046-555d9a58f1d9/scratchpad/scripts/urls.tsv"

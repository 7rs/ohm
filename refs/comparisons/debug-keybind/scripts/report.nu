let sp = "C:/Users/taiko/AppData/Local/Temp/claude/803ae1ca5c3f9b75/44765748-fbad-4107-9046-555d9a58f1d9/scratchpad"
let rows = (open --raw $"($sp)/scripts/scan_raw.tsv" | lines | where {|l| ($l | str length) > 0} | each {|l|
  let p = ($l | split row "\t")
  {slug: ($p | get 0), cls: ($p | get 1), kind: ($p | get 2), meth: ($p | get 3? | default ""), buf: ($p | get 4? | default "")}
})
let interest = '(KeyboardHandler|KeyMapping|[^A-Za-z]Options;|screens/controls|screens\.controls|GameModeSwitcherScreen|InputConstants)'
let mix = ($rows | where kind == "Mixin" | where {|r| $r.buf =~ $interest})
let keys = ($mix | each {|r| $"($r.slug)|($r.cls)"} | uniq)
$mix | select slug cls buf | each {|r| $"MIXIN ($r.slug) ($r.cls) ($r.buf)"} | save -f $"($sp)/scripts/mixin_targets.txt"
let inj = ($rows | where kind != "Mixin" | where {|r| $keys | any {|k| $k == $"($r.slug)|($r.cls)"} })
$inj | each {|r| $"($r.slug)\t($r.cls | split row '.' | last)\t($r.kind)\t($r.buf)"} | save -f $"($sp)/scripts/injectors.tsv"
print $"mixins: ($mix | length), injector rows: ($inj | length)"

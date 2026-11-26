function trim(s){ gsub(/^[ \t]+|[ \t]+$/, "", s); return s }
/^  [^ #].*\);$/ { curm=trim($0) }
/^  [^ #].*;$/ && !/\(/ { curm=trim($0) }
{
  line=$0
  if (rec==0 && match(line, /^ +(org\.spongepowered\.asm\.mixin\.[A-Za-z.]+|com\.llamalad7\.mixinextras\.[A-Za-z.]+)\($/)) {
    name=trim(line); sub(/\($/, "", name); n=split(name, a, "."); kind=a[n]
    match(line, /^ +/); ind=RLENGTH; rec=1; buf=""; next
  }
  if (rec==1) {
    t=line; match(t, /^ */); li=RLENGTH
    if (li==ind && trim(t)==")") {
      if (kind!="Shadow" && kind!="Final" && kind!="Unique" && kind!="Local" && kind!="Share" && kind!="Coerce" && kind!="Slice" && kind!="At" && kind!="Constant" && kind!="Mutable" && kind!="Implements") {
        gsub(/[ \t]+/, " ", buf); print cls "\t" kind "\t" curm "\t" buf
      }
      rec=0; next
    }
    buf=buf " " trim(t)
  }
}

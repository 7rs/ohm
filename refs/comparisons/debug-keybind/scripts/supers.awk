{
  line=$0; sub(/^HEAD\t/, "", line)
  while (match(line, /<[^<>]*>/)) line = substr(line, 1, RSTART-1) substr(line, RSTART+RLENGTH)
  gsub(/,/, " ", line)
  n=split(line, t, " "); st=0
  for (i=1;i<=n;i++) { if (t[i]=="extends" || t[i]=="implements") { st=1; continue } if (st==1) print t[i] }
}

#! /bin/bash
awk  -F\, '$1>=20160112 && $1<=20160122 {count++; sum+=($5-$6); ssq+=($5-$6)**2} END {sr=(sum/count)/sqrt((ssq/count)-((sum/count)**2)); print sr}' <(gzip -dc text.csv.gz)


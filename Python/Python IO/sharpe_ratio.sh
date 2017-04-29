#! /bin/bash
awk  -F\, '$1>=20160107 && $1<=20160118 {count++; sum+=($5-$6); ssq+=($5-$6)**2} END {sr=(sum/count)/sqrt((ssq/count)-((sum/count)**2)); print sr}' trade.csv


#!/usr/bin/env bash
set -euo pipefail
echo "== Extract IP addresses =="
awk '{print $1}' sample.log | sort | uniq -c

echo -e "\n== Method and URL =="
awk '{print $6, $7}' sample.log

echo -e "\n== Count by status code =="
awk '{count[$9]++} END {for (c in count) print c, count[c]}' sample.log

echo -e "\n== Average response size =="
awk '{sum+=$10; n++} END {if (n>0) print "Avg:", sum/n}' sample.log

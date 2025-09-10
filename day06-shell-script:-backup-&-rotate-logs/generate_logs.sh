#!/usr/bin/env bash
set -euo pipefail
OUT="${1:-./lab-logs}"
mkdir -p "$OUT"
echo "Generating sample logs in $OUT"
for svc in web api worker; do
  log="$OUT/${svc}.log"
  : > "$log"
  for i in $(seq 1 1000); do
    ts="$(date '+%Y-%m-%d %H:%M:%S')"
    lvl=$(( (RANDOM % 3) ))
    case $lvl in
      0) level="INFO" ;;
      1) level="WARN" ;;
      2) level="ERROR";;
    esac
    echo "$ts [$level] $svc - message $i - id=$RANDOM path=/v1/$svc op=$(shuf -e GET POST PUT DELETE | head -n1)" >> "$log"
  done
done
ls -lh "$OUT"/*.log

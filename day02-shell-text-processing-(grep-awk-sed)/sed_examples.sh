#!/usr/bin/env bash
set -euo pipefail
echo "== Replace http with https =="
sed 's|http|https|g' sample.log

echo -e "\n== Remove favicon.ico requests =="
sed '/favicon.ico/d' sample.log

echo -e "\n== Mask IP addresses =="
sed -E 's/[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+/XXX.XXX.XXX.XXX/g' sample.log

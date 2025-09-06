#!/usr/bin/env bash
set -euo pipefail
echo "== All 404 errors =="
grep " 404 " sample.log

echo -e "\n== Requests from 192.168.0.10 =="
grep "192.168.0.10" sample.log | wc -l

echo -e "\n== Highlight 'GET' requests =="
grep --color=always "GET" sample.log

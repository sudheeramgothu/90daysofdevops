#!/usr/bin/env bash
set -euo pipefail
# Lines with errors (4xx/5xx)
echo "== Errors (4xx/5xx) =="
grep -E 'HTTP/1\.[01]" (4|5)[0-9]{2} ' sample.log

# Requests to /api/*
echo -e "\n== /api/* requests =="
grep -E '"[A-Z]+ /api/[^ ]* HTTP' sample.log

# Suspicious traversal attempts
echo -e "\n== Suspicious traversal (../) =="
grep -E '\.\./' sample.log || true

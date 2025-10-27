#!/usr/bin/env bash
set -euo pipefail
OUT_DIR="${1:?}"; BREAK_ON_HIGH="${2:-true}"
echo "[summary] Reports in $OUT_DIR"
grep -E '<failure|testcase' "$OUT_DIR"/*.xml || true
if [ "$BREAK_ON_HIGH" = "true" ] && grep -q "<failure" "$OUT_DIR"/*.xml 2>/dev/null; then
  echo "[summary] ❌ Gate FAILED"
  exit 1
else
  echo "[summary] ✅ Gate PASSED or BREAK_ON_HIGH=false"
fi

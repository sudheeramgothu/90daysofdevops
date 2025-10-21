#!/usr/bin/env bash
set -euo pipefail
OUT="${1:-reports/junit}"
mkdir -p "$OUT"
cat > "$OUT/unit.xml" <<'XML'
<testsuite name="unit">
  <testcase classname="unit" name="unit_example"/>
</testsuite>
XML
echo "[unit] wrote $OUT/unit.xml"

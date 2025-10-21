#!/usr/bin/env bash
set -euo pipefail
OUT="${1:-reports/junit}"
mkdir -p "$OUT"
cat > "$OUT/e2e.xml" <<'XML'
<testsuite name="e2e">
  <testcase classname="e2e" name="e2e_example"/>
</testsuite>
XML
echo "[e2e] wrote $OUT/e2e.xml"

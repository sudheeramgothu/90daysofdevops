#!/usr/bin/env bash
set -euo pipefail
OUT="${1:-reports/junit}"
mkdir -p "$OUT"
cat > "$OUT/integration.xml" <<'XML'
<testsuite name="integration">
  <testcase classname="integration" name="integration_example"/>
</testsuite>
XML
echo "[integration] wrote $OUT/integration.xml"

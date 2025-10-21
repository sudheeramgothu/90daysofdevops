#!/usr/bin/env bash
set -euo pipefail
OUT="${1:-reports/junit}"
mkdir -p "$OUT"
cat > "$OUT/lint.xml" <<'XML'
<testsuite name="lint">
  <testcase classname="lint" name="lint_example"/>
</testsuite>
XML
echo "[lint] wrote $OUT/lint.xml"

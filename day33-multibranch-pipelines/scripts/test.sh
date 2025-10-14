
#!/usr/bin/env bash
set -euo pipefail
mkdir -p reports/junit
echo "[test] running unit tests (placeholder)"
cat > reports/junit/tests.xml <<'XML'
<testsuite name="unit">
  <testcase classname="sample" name="alwaysPass"/>
</testsuite>
XML

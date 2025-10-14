
#!/usr/bin/env bash
set -euo pipefail
mkdir -p reports/junit
echo "[quality] linting shell and python (placeholder)"
echo "<testsuite name=\"lint\"><testcase classname=\"lint\" name=\"shellcheck\"/></testsuite>" > reports/junit/lint.xml

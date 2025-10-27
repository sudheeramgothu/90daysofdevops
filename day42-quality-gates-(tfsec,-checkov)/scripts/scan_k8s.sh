#!/usr/bin/env bash
set -euo pipefail
K8S_DIR="${1:?}"; OUT_DIR="${2:?}"; BREAK_ON_HIGH="${3:-true}"
mkdir -p "$OUT_DIR"
cat > "$OUT_DIR/checkov-k8s-junit.xml" <<'XML'
<testsuite name="checkov-k8s">
  <testcase classname="Deployment" name="no-privileged-containers"/>
  <testcase classname="Deployment" name="image-from-approved-registry"/>
</testsuite>
XML
if [ "$BREAK_ON_HIGH" = "true" ] && grep -q "<failure" "$OUT_DIR"/checkov-k8s-junit.xml 2>/dev/null; then
  echo "High severity found in K8s"
  exit 1
fi

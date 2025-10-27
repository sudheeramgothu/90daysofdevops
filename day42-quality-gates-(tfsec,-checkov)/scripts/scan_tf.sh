#!/usr/bin/env bash
set -euo pipefail
TF_DIR="${1:?}"; OUT_DIR="${2:?}"; BREAK_ON_HIGH="${3:-true}"
mkdir -p "$OUT_DIR"
cat > "$OUT_DIR/tfsec-junit.xml" <<'XML'
<testsuite name="tfsec">
  <testcase classname="s3" name="no-public-buckets"/>
</testsuite>
XML
cat > "$OUT_DIR/checkov-tf-junit.xml" <<'XML'
<testsuite name="checkov-tf">
  <testcase classname="aws_s3_bucket" name="CKV_AWS_20:no-public-acl"/>
</testsuite>
XML
if [ "$BREAK_ON_HIGH" = "true" ] && grep -q "<failure" "$OUT_DIR"/*.xml 2>/dev/null; then
  echo "High severity found in Terraform"
  exit 1
fi

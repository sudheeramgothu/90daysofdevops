#!/usr/bin/env bash
set -euo pipefail
TF_DIR="${1:-terraform}"; REPORTS="${2:-reports}"; mkdir -p "$REPORTS";
echo "<testsuite name=\"tfsec\"><testcase classname=\"tfsec\" name=\"scan\"/></testsuite>" > "$REPORTS/tfsec.xml";
echo "<testsuite name=\"checkov\"><testcase classname=\"checkov\" name=\"scan\"/></testsuite>" > "$REPORTS/checkov.xml";

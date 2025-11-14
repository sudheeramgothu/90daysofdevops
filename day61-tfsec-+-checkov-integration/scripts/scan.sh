#!/usr/bin/env bash
set -euo pipefail
ROOT=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
cd "$ROOT"
mkdir -p reports
echo "[tfsec]"; tfsec ./terraform --format json --out ./reports/tfsec.json || true
tfsec ./terraform --format sarif --out ./reports/tfsec.sarif || true
echo "[checkov]"; checkov -d ./terraform -o json --config-file policy/checkov.yaml --output-file-path ./reports/checkov.json || true
checkov -d ./terraform -o sarif --config-file policy/checkov.yaml --output-file-path ./reports/checkov.sarif || true
python3 scripts/summary.py || GATE=$?
if [[ "${GATE:-0}" -ne 0 ]]; then echo "[gate] FAIL"; exit 1; fi
echo "[gate] PASS"

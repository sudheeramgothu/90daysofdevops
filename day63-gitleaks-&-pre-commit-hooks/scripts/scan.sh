#!/usr/bin/env bash
set -euo pipefail
ROOT=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
cd "$ROOT"
mkdir -p day63-gitleaks/reports
gitleaks detect --config day63-gitleaks/gitleaks.toml --source . --report-format json --report-path day63-gitleaks/reports/gitleaks.json || GL=$?
if [[ "${GL:-0}" -ne 0 ]]; then echo 'secrets found'; exit 1; fi
echo 'no secrets found'

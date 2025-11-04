#!/usr/bin/env bash
set -euo pipefail
API="http://localhost:${API_PORT:-8080}"
bash scripts/wait_for.sh "$API/health" 40 3
curl -fsS "$API/health" || true
curl -fsS "$API/cache?key=foo&value=bar" || true
curl -fsS "$API/cache?key=foo" || true
echo "[test] done"

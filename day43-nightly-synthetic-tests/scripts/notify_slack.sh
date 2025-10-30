#!/usr/bin/env bash
set -euo pipefail
WEBHOOK="${1:?webhook required}"
ENV="${2:?env required}"
URL="${3:?url required}"

MSG="🚨 Synthetic check FAILED for ${ENV} (${URL}) at $(date -u +%Y-%m-%dT%H:%M:%SZ)"
JSON_PAYLOAD="{\"text\":\"$MSG\"}"

echo "[alert] would send alert:"
echo "$JSON_PAYLOAD"

# Real usage:
# curl -s -X POST -H 'Content-type: application/json' --data "$JSON_PAYLOAD" "$WEBHOOK" || true

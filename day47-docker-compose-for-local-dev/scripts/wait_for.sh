#!/usr/bin/env bash
set -euo pipefail
URL="${1:?}"; TRIES="${2:-40}"; SLEEP="${3:-3}"
for i in $(seq 1 "$TRIES"); do
  if curl -fsS "$URL" >/dev/null; then echo "[wait] Ready: $URL"; exit 0; fi
  echo "[wait] Not ready ($i/$TRIES): $URL"; sleep "$SLEEP"; done
echo "[wait] Timeout: $URL"; exit 1

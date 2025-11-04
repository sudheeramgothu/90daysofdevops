#!/usr/bin/env bash
set -euo pipefail
IMAGE="${1:?image}"; PORT="${2:-8080}"
docker run --rm -d --name demo-api -p "${PORT}:8080" --read-only --tmpfs /tmp:rw,noexec,nosuid,size=64m --cap-drop ALL "$IMAGE"
echo "running on :${PORT}"

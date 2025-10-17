#!/usr/bin/env bash
set -euo pipefail
IMAGE="${1:?usage: push.sh <repo-uri> <git-sha|build-number>}"
STRATEGY="${2:-git-sha}"
if [ "$STRATEGY" = 'git-sha' ]; then TAG="${GIT_COMMIT:-local}"; TAG="${TAG:0:7}"; else TAG="${BUILD_NUMBER:-local}"; fi
echo "[push] Tagging demo/app:local -> ${IMAGE}:${TAG}"
docker tag demo/app:local "${IMAGE}:${TAG}"
docker push "${IMAGE}:${TAG}"

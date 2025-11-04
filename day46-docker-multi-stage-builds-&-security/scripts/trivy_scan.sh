#!/usr/bin/env bash
set -euo pipefail
IMAGE="${1:?image required}"
OUT="day46-docker-multistage-security/reports"
mkdir -p "$OUT"
if command -v trivy >/dev/null 2>&1; then
  trivy image --severity HIGH,CRITICAL --format table "$IMAGE" | tee "${OUT}/trivy_${IMAGE//[:\//]/_}.txt" || true
else
  echo "Trivy not installed" | tee "${OUT}/trivy_${IMAGE//[:\//]/_}.txt"
fi

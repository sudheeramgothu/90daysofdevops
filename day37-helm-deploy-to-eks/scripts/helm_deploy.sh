#!/usr/bin/env bash
set -euo pipefail
helm upgrade --install "${1}" "${2}" -n "${3}" --create-namespace --set image.repository="${4}" --set image.tag="${5}"
kubectl -n "${3}" rollout status deploy/"${1}" --timeout=120s

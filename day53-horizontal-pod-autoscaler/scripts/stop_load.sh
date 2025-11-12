#!/usr/bin/env bash
set -euo pipefail
kubectl delete job hpa-load --ignore-not-found
echo "[load] Job hpa-load deleted"

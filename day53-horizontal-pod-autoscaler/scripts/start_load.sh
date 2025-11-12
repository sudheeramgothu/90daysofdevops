#!/usr/bin/env bash
set -euo pipefail
kubectl apply -f k8s/loadjob.yaml
echo "[load] Job hpa-load created"

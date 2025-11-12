#!/usr/bin/env bash
set -euo pipefail
kubectl apply -k k8s
echo "[deploy] Applied app/service/HPA"

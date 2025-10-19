#!/usr/bin/env bash
set -euo pipefail
aws eks update-kubeconfig --region "${1}" --name "${2}"
kubectl get nodes -o wide || true

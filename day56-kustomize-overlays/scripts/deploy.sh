#!/usr/bin/env bash
set -euo pipefail
ENV="${1:?usage: deploy.sh <dev|staging|prod>}"
kubectl apply -k k8s/overlays/${ENV}

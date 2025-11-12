#!/usr/bin/env bash
set -euo pipefail
ENV="${1:?usage: deploy.sh <staging|prod>}"
case "$ENV" in
  staging) OVERLAY="k8s/overlays/staging" ;;
  prod|production) OVERLAY="k8s/overlays/prod" ;;
  *) echo "env must be staging|prod"; exit 1 ;;
 esac
kubectl apply -k "$OVERLAY"

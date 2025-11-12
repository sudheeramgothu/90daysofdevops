#!/usr/bin/env bash
set -euo pipefail
ENV="${1:?usage: render.sh <dev|staging|prod>}"
kubectl kustomize k8s/overlays/${ENV}

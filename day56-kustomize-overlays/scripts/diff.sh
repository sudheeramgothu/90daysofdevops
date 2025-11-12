#!/usr/bin/env bash
set -euo pipefail
ENV="${1:?usage: diff.sh <dev|staging|prod>}"
kubectl diff -k k8s/overlays/${ENV} || true

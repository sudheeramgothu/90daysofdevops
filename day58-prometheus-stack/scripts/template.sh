#!/usr/bin/env bash
set -euo pipefail
ENV="${1:?usage: template.sh <staging|prod>}"
helm template kp-stack prometheus-community/kube-prometheus-stack -n monitoring -f helm/values-common.yaml -f helm/values-${ENV}.yaml

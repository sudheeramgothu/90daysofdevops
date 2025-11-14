#!/usr/bin/env bash
set -euo pipefail
ENV="${1:?usage: deploy.sh <staging|prod>}"
kubectl get ns monitoring >/dev/null 2>&1 || kubectl create ns monitoring
if ! kubectl -n monitoring get secret grafana-admin >/dev/null 2>&1; then
  kubectl -n monitoring create secret generic grafana-admin --from-literal=admin-user=admin --from-literal=admin-password=admin123
fi
kubectl -n monitoring apply -f k8s/servicemonitor-demo.yaml || true
kubectl -n monitoring apply -f k8s/podmonitor-demo.yaml || true
kubectl -n monitoring apply -f alerts/custom-rules.yaml || true
helm upgrade --install kp-stack prometheus-community/kube-prometheus-stack -n monitoring -f helm/values-common.yaml -f helm/values-${ENV}.yaml

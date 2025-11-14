#!/usr/bin/env bash
set -euo pipefail
NS=monitoring
for f in k8s/*-cm.yaml; do name=$(basename "$f"); cm="grafana-dashboard-${name%-cm.yaml}"; kubectl -n "$NS" delete configmap "$cm" --ignore-not-found; done
echo "[done] deleted"

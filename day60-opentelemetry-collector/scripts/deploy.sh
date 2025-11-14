#!/usr/bin/env bash
set -euo pipefail
NS=observability
kubectl get ns $NS >/dev/null 2>&1 || kubectl create ns $NS
kubectl apply -f k8s/namespace.yaml
kubectl apply -f k8s/serviceaccount.yaml
kubectl apply -f k8s/env-configmap.yaml
kubectl apply -f k8s/configmap.yaml
kubectl apply -f k8s/rbac.yaml
kubectl apply -f k8s/deployment.yaml
kubectl apply -f k8s/service.yaml
echo "[info] To scrape via Prom stack: kubectl -n monitoring apply -f k8s/servicemonitor.yaml"

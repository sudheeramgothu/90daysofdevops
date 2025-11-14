#!/usr/bin/env bash
set -euo pipefail
NS=observability
kubectl -n $NS get deploy,po,svc
kubectl -n $NS get cm otel-collector-config -o yaml | head -n 30

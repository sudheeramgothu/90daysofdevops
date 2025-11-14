#!/usr/bin/env bash
set -euo pipefail
NS=monitoring
for f in k8s/*-cm.yaml; do kubectl -n "$NS" apply -f "$f"; done
echo "[done] applied"

#!/usr/bin/env bash
set -euo pipefail
ENV="${1:?usage: rollout_status.sh <staging|prod>}"
NS=$( [ "$ENV" = "staging" ] && echo staging || echo production )
NAME=$(kubectl -n "$NS" get deploy -l app=demo-api -o jsonpath='{.items[0].metadata.name}')
echo "[rollout] Waiting for $NAME in ns=$NS"
kubectl -n "$NS" rollout status deploy "$NAME" --timeout=180s
kubectl -n "$NS" get pods -l app=demo-api -o wide

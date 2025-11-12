#!/usr/bin/env bash
set -euo pipefail
ENV="${1:?usage: deploy.sh <staging|prod> [image[:tag]] [replicas]}"
IMAGE="${2:-}"
REPLICAS="${3:-}"
case "$ENV" in
  staging) OVERLAY="k8s/overlays/staging" ;;
  prod|production) OVERLAY="k8s/overlays/prod" ;;
  *) echo "env must be staging|prod"; exit 1 ;;
esac
echo "[deploy] overlay=$OVERLAY image=${IMAGE:-'(keep)'} replicas=${REPLICAS:-'(keep)'}"
if [ -n "$IMAGE" ]; then
  kubectl kustomize "$OVERLAY" | sed "s#image: ealen/echo-server:latest#image: ${IMAGE}#g" | kubectl apply -f -
else
  kubectl apply -k "$OVERLAY"
fi
if [ -n "$REPLICAS" ]; then
  NS=$( [ "$ENV" = "staging" ] && echo staging || echo production )
  NAME=$(kubectl -n "$NS" get deploy -l app=demo-api -o jsonpath='{.items[0].metadata.name}')
  kubectl -n "$NS" scale deploy "$NAME" --replicas="$REPLICAS"
fi

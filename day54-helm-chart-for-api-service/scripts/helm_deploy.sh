#!/usr/bin/env bash
set -euo pipefail
ENV="${1:?usage: helm_deploy.sh <staging|prod>}"; RELEASE="${2:-demo}"; NS_OVERRIDE="${3:-}"; IMAGE="${4:-}"
VALUES="charts/demo-api/values-${ENV}.yaml"
SET_IMG=""; if [ -n "$IMAGE" ]; then REPO="${IMAGE%%:*}"; TAG="${IMAGE##*:}"; [ "$REPO" = "$TAG" ] && TAG="latest"; SET_IMG="--set image.repository=$REPO --set image.tag=$TAG"; fi
NS_ARG=""; [ -n "$NS_OVERRIDE" ] && NS_ARG="--namespace $NS_OVERRIDE"
helm upgrade --install "$RELEASE" charts/demo-api -f "$VALUES" $NS_ARG $SET_IMG --create-namespace

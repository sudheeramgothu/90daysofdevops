#!/usr/bin/env bash
set -euo pipefail
ENV="${1:?usage: test_alb.sh <staging|prod>}"
HOST="${2:-}"
NS="$( [ "$ENV" = "staging" ] && echo staging || echo production )"
if [ -z "$HOST" ]; then HOST="$(kubectl -n "$NS" get ingress -o jsonpath='{.items[0].status.loadBalancer.ingress[0].hostname}')"; fi
curl -I "http://$HOST/" || true

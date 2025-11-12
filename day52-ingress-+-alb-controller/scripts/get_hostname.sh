#!/usr/bin/env bash
set -euo pipefail
ENV="${1:?usage: get_hostname.sh <staging|prod>}"
NS="$( [ "$ENV" = "staging" ] && echo staging || echo production )"
kubectl -n "$NS" get ingress -o jsonpath='{.items[0].status.loadBalancer.ingress[0].hostname}'; echo

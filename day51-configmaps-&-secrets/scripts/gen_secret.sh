#!/usr/bin/env bash
set -euo pipefail
NS="${1:?usage: gen_secret.sh <namespace>}"; USER="${2:-appuser}"; PASS="${3:-S3cr3t!}"; TOKEN="${4:-tok123}"
kubectl -n "$NS" create secret generic app-secrets --from-literal=DB_USER="$USER" --from-literal=DB_PASS="$PASS" --from-literal=token.txt="$TOKEN" --dry-run=client -o yaml | kubectl -n "$NS" apply -f -
echo "[secret] app-secrets updated in ns=$NS"

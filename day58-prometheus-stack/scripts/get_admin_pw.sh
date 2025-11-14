#!/usr/bin/env bash
set -euo pipefail
kubectl -n monitoring get secret grafana-admin -o jsonpath='{.data.admin-password}' | base64 -d; echo

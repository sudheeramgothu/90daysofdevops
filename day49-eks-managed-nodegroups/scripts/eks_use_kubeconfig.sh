#!/usr/bin/env bash
set -euo pipefail
REGION="$(terraform -chdir="$(dirname "$0")/../infra" output -raw region 2>/dev/null || echo us-east-1)"; CLUSTER="$(terraform -chdir="$(dirname "$0")/../infra" output -raw cluster_name)"; aws eks update-kubeconfig --region "$REGION" --name "$CLUSTER"; kubectl get nodes -o wide || true

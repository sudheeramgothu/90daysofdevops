#!/usr/bin/env bash
set -euo pipefail
REGION="${1:-us-east-1}"
IMAGE="${2:?usage: login_ecr.sh <region> <repo-uri>}"
REGISTRY="$(echo "$IMAGE" | cut -d'/' -f1)"
echo "[login] $REGISTRY ($REGION)"
aws ecr get-login-password --region "$REGION" | docker login --username AWS --password-stdin "$REGISTRY"

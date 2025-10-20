#!/usr/bin/env bash
set -euo pipefail
K8S_DIR="${1:?}"; POL_DIR="${2:?}";
IMG=$(grep -m1 'image:' "$K8S_DIR/deployment.yaml" | awk '{print $2}')
if [[ "$IMG" != *".dkr.ecr."* ]]; then echo "DENY: image not from approved registry: $IMG"; exit 1; else echo "OK: $IMG"; fi

#!/usr/bin/env bash
set -euo pipefail
ROOT=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
cd "$ROOT"
echo "== K8s =="
conftest test --policy policies/kubernetes --input k8s examples/k8s
echo "== TF (hcl2) =="
conftest test --policy policies/terraform --parser hcl2 examples/terraform

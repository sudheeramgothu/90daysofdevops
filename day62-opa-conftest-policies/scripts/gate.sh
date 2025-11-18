#!/usr/bin/env bash
set -euo pipefail
ROOT=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
cd "$ROOT"
mkdir -p reports
set +e
conftest test --policy policies/kubernetes --input k8s examples/k8s --output junit > reports/k8s-junit.xml
K8S=$?
conftest test --policy policies/terraform --parser hcl2 examples/terraform --output junit > reports/tf-junit.xml
TF=$?
RC=$(( K8S | TF ))
exit $RC

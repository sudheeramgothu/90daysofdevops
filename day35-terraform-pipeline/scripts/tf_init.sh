#!/usr/bin/env bash
set -euo pipefail
terraform init
terraform workspace list | grep -q " ${ENV} " || terraform workspace new "${ENV}"
terraform workspace select "${ENV}"

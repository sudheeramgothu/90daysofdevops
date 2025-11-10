#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/../infra"
terraform fmt -recursive
terraform validate
terraform plan -out=tfplan

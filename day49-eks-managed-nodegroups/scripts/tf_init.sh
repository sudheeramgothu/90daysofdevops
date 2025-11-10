#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/../infra"
terraform init -upgrade
terraform fmt -recursive
terraform validate

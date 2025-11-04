#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/../infra"
terraform apply -auto-approve tfplan || terraform apply

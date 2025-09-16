#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/../bootstrap"
terraform apply -auto-approve -var="region=us-east-1" -var="name_prefix=devopsday11"

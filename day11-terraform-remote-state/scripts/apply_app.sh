#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/../app"
terraform apply -auto-approve

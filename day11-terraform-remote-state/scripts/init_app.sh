#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/../app"
terraform init -backend-config=env/backend.hcl

#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/../consumer"
terraform plan -var="backend_bucket=<SET_FROM_BOOTSTRAP_OUTPUT>" \
               -var="backend_region=<SET_FROM_BOOTSTRAP_OUTPUT>" \
               -var="backend_dynamodb_table=<SET_FROM_BOOTSTRAP_OUTPUT>"

#!/usr/bin/env bash
set -euo pipefail
terraform workspace select "${ENV}"
terraform plan -out=tfplan.out -var="aws_region=${AWS_REGION}" -var="env=${ENV}"

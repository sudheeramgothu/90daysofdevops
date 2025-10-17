#!/usr/bin/env bash
set -euo pipefail
terraform workspace select "${ENV}"
if [ -f tfplan.out ]; then terraform apply ${AUTO_APPROVE:+-auto-approve} tfplan.out; else terraform apply ${AUTO_APPROVE:+-auto-approve} -var="aws_region=${AWS_REGION}" -var="env=${ENV}"; fi

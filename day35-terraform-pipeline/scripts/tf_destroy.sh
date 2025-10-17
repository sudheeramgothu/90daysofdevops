#!/usr/bin/env bash
set -euo pipefail
terraform workspace select "${ENV}"
terraform destroy ${AUTO_APPROVE:+-auto-approve} -var="aws_region=${AWS_REGION}" -var="env=${ENV}"

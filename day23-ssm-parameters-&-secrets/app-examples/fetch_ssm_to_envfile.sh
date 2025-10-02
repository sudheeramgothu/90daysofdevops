#!/usr/bin/env bash
# fetch_ssm_to_envfile.sh
# Usage: ./fetch_ssm_to_envfile.sh /dev/sampleapp .env
set -euo pipefail

PREFIX="${1:-/dev/sampleapp}"
OUTFILE="${2:-.env}"

echo "# Generated from SSM prefix: ${PREFIX}" > "${OUTFILE}"

aws ssm get-parameters-by-path \
  --path "${PREFIX}" \
  --recursive \
  --with-decryption \
  --query 'Parameters[].{Name:Name,Value:Value}' \
  --output json | jq -r '.[] | "\(.Name|split("/")[-1])=\(.Value)"' >> "${OUTFILE}"

echo "Wrote $(wc -l < "${OUTFILE}") lines to ${OUTFILE} (including header)"
echo "Tip: export $(grep -v '^#' "${OUTFILE}" | xargs)"

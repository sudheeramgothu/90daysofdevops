#!/usr/bin/env bash
set -euo pipefail
OUTDIR="${1:?dir required}"
ENV="${2:?env required}"
BUCKET="${3:?bucket required}"

LATEST="$(ls -1t "${OUTDIR}"/synthetic-"${ENV}"-*.json | head -n1 || true)"
[ -z "$LATEST" ] && { echo "[s3] no report found"; exit 0; }

KEY="synthetic/${ENV}/$(basename "$LATEST")"
echo "[s3] upload ${LATEST} -> s3://${BUCKET}/${KEY}"
aws s3 cp "$LATEST" "s3://${BUCKET}/${KEY}" --acl private || echo "[s3] upload skipped"

#!/usr/bin/env bash
set -euo pipefail
OUT="${1:?}"; ARCHIVE="${2:?}"; TARGET="${3:?}"; S3_BUCKET="${4:-}"; S3_PREFIX="${5:-jenkins/backups}"
mkdir -p "$TARGET"
ARCH_PATH="${ARCHIVE}"
if [ ! -f "$ARCH_PATH" ]; then
  if [ -n "$S3_BUCKET" ] && command -v aws >/dev/null 2>&1; then
    aws s3 cp "s3://${S3_BUCKET}/${S3_PREFIX}/${ARCHIVE}" "${OUT}/${ARCHIVE}" --acl private
    ARCH_PATH="${OUT}/${ARCHIVE}"
  else
    echo "[restore] archive not found: ${ARCHIVE}"; exit 1
  fi
fi
tar -C "$TARGET" -xzf "$ARCH_PATH"
echo "[restore] done -> ${TARGET}"

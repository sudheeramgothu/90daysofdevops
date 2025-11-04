#!/usr/bin/env bash
set -euo pipefail
JH="${1:?}"; OUT="${2:?}"; S3_BUCKET="${3:-}"; S3_PREFIX="${4:-jenkins/backups}"
STAMP="$(date -u +%Y%m%dT%H%M%SZ)"; HOST="$(hostname -s || echo host)"
BASE="jenkins_${HOST}_${STAMP}"; TAR="${OUT}/${BASE}.tgz"; MANIFEST="${OUT}/${BASE}.manifest"; SHA="${OUT}/${BASE}.sha256"; LOG="${OUT}/${BASE}.log"
echo "[backup] $STAMP JENKINS_HOME=$JH" | tee "$LOG"
tar -C "$JH" -czf "$TAR" . --warning=no-file-changed 2>>"$LOG"
COUNT="$(tar -tzf "$TAR" | wc -l | tr -d ' ')"; SIZE_BYTES="$(stat -c%s "$TAR" 2>/dev/null || wc -c < "$TAR")"
printf "archive=%s
files=%s
size_bytes=%s
created_utc=%s
" "$TAR" "$COUNT" "$SIZE_BYTES" "$STAMP" > "$MANIFEST"
sha256sum "$TAR" | awk '{print $1}' > "$SHA"
if [ -n "$S3_BUCKET" ] && command -v aws >/dev/null 2>&1; then
  aws s3 cp "$TAR" "s3://${S3_BUCKET}/${S3_PREFIX}/${BASE}.tgz" --acl private || true
  aws s3 cp "$MANIFEST" "s3://${S3_BUCKET}/${S3_PREFIX}/${BASE}.manifest" --acl private || true
  aws s3 cp "$SHA" "s3://${S3_BUCKET}/${S3_PREFIX}/${BASE}.sha256" --acl private || true
fi
echo "[backup] done" | tee -a "$LOG"

#!/usr/bin/env bash
set -euo pipefail
OUT="${1:?}"; DAYS="${2:?}"
find "${OUT}" -type f -name 'jenkins_*.tgz' -mtime +${DAYS} -print -delete || true
find "${OUT}" -type f -name 'jenkins_*.manifest' -mtime +${DAYS} -print -delete || true
find "${OUT}" -type f -name 'jenkins_*.sha256' -mtime +${DAYS} -print -delete || true

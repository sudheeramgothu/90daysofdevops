#!/usr/bin/env bash
set -euo pipefail
OUT="${1:?}"
LATEST="$(ls -1t "${OUT}"/jenkins_*.tgz 2>/dev/null | head -n1)"
[ -z "${LATEST}" ] && { echo "[verify] no backups in ${OUT}"; exit 0; }
BASE="${LATEST%.tgz}"; SHA="${BASE}.sha256"; MANIFEST="${BASE}.manifest"
if [ -f "$SHA" ]; then
  SUM_FILE="$(cat "$SHA")"; CALC="$(sha256sum "$LATEST" | awk '{print $1}')"
  [ "$SUM_FILE" = "$CALC" ] || { echo "[verify] checksum mismatch"; exit 1; }
fi
tar -tzf "$LATEST" | head -n 20 || true
[ -f "$MANIFEST" ] && { echo "[verify] manifest:"; cat "$MANIFEST"; }
echo "[verify] OK"

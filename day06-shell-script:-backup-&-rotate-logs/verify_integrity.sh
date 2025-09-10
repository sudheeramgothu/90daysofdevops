#!/usr/bin/env bash
# Verify all sha256 checksums within a backup directory
# Usage: verify_integrity.sh <backup_dir>
set -euo pipefail
DIR="${1:-./backups}"
cd "$DIR"
ok=0; bad=0
shopt -s nullglob
for sum in *.sha256 */*.sha256; do
  [ -e "$sum" ] || continue
  if sha256sum -c "$sum"; then
    ok=$((ok+1))
  else
    bad=$((bad+1))
  fi
done
echo "Verification complete: OK=$ok BAD=$bad"

#!/usr/bin/env bash
set -euo pipefail
LAB_DIR="${1:-./lab-perms}"
SHARE="$LAB_DIR/tmp"

echo "== Before =="
ls -ld "$SHARE"

echo "== Apply sticky bit (1xxx) =="
chmod 1777 "$SHARE"
ls -ld "$SHARE"

cat <<'TXT'

With the sticky bit set on a world-writable dir:
- Users can create files, but only the owner (or root) can delete/rename their files.
- This is how /tmp behaves on Unix systems.

TXT

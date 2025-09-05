#!/usr/bin/env bash
set -euo pipefail
LAB_DIR="${1:-./lab-perms}"
GDIR="$LAB_DIR/groupdir"

echo "== Before =="
ls -ld "$GDIR"

echo "== Apply setgid on directory =="
chmod 2775 "$GDIR"
ls -ld "$GDIR"

cat <<'TXT'

setgid on a directory makes newly created files inside inherit the directory's group,
which is great for team-owned project folders (consistent group ownership).

TXT

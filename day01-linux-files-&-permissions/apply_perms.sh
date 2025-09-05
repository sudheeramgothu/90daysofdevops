#!/usr/bin/env bash
set -euo pipefail
LAB_DIR="${1:-./lab-perms}"

echo "== Start =="
ls -l "$LAB_DIR"/docs

echo "== Make private.txt owner-read/write only =="
chmod 600 "$LAB_DIR/docs/private.txt"
ls -l "$LAB_DIR/docs/private.txt"

echo "== Make readme.txt world-readable, not writeable =="
chmod 644 "$LAB_DIR/docs/readme.txt"
ls -l "$LAB_DIR/docs/readme.txt"

echo "== Add execute bit to script (symbolic) =="
chmod u+x "$LAB_DIR/scripts/example.sh"
ls -l "$LAB_DIR/scripts/example.sh"

echo "== Remove write for group/others on team.txt (symbolic) =="
chmod go-w "$LAB_DIR/docs/team.txt"
ls -l "$LAB_DIR/docs/team.txt"

echo "== Recursively tighten docs dir to 755/644 =="
find "$LAB_DIR/docs" -type d -exec chmod 755 {} \;
find "$LAB_DIR/docs" -type f -exec chmod 644 {} \;
tree "$LAB_DIR/docs" 2>/dev/null || find "$LAB_DIR/docs" -printf '%M %p\n'

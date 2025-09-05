#!/usr/bin/env bash
set -euo pipefail
command -v setfacl >/dev/null || { echo "setfacl not found — skipping ACL demo"; exit 0; }

LAB_DIR="${1:-./lab-perms}"
FILE="$LAB_DIR/docs/team.txt"

echo "== Before ACLs =="
ls -l "$FILE"
getfacl "$FILE" | sed 's/^#.*//'

echo "== Grant specific user read-only via ACL (replace USERNAME) =="
# setfacl -m u:USERNAME:r-- "$FILE"

echo "== Current ACLs =="
getfacl "$FILE" | sed 's/^#.*//'

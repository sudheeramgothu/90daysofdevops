#!/usr/bin/env bash
set -euo pipefail
LAB_DIR="${1:-./lab-perms}"

echo "== Current umask =="
umask

echo "== Demonstrate file creation masks =="
TMPD="$LAB_DIR/umask-demo"
rm -rf "$TMPD"; mkdir -p "$TMPD"

(
  umask 022
  echo "content" > "$TMPD/file_022.txt"
  mkdir "$TMPD/dir_022"
  echo "[umask 022]" ; ls -ld "$TMPD/"* | awk '{print $1,$9}'
)

(
  umask 027
  echo "content" > "$TMPD/file_027.txt"
  mkdir "$TMPD/dir_027"
  echo "[umask 027]" ; ls -ld "$TMPD/"* | awk '{print $1,$9}'
)

(
  umask 077
  echo "content" > "$TMPD/file_077.txt"
  mkdir "$TMPD/dir_077"
  echo "[umask 077]" ; ls -ld "$TMPD/"* | awk '{print $1,$9}'
)

#!/usr/bin/env bash
set -euo pipefail
LAB_DIR="${1:-./lab-perms}"

echo "== Stat & ls =="
ls -l "$LAB_DIR"/docs
printf "\n== Numeric vs symbolic ==\n"
for f in "$LAB_DIR"/docs/*; do
  printf "%s  " "$(ls -l "$f")"
  stat -c "(octal:%a owner:%U group:%G type:%F)" "$f"
done

printf "\n== Who can do what? ==\n"
cat <<'TXT'
r (4) = read file contents / list directory
w (2) = write file / create, delete, rename entries in directory
x (1) = execute file / traverse directory
TXT

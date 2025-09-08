#!/usr/bin/env bash
set -euo pipefail

LAB=lab-git
rm -rf "$LAB"
mkdir -p "$LAB"
cd "$LAB"

git init -b main >/dev/null

git config user.name "Your Name"
git config user.email "you@example.com"

echo "alpha" > app.txt
git add app.txt
git commit -m "init: add app.txt"

echo "one" > feature.txt
git add feature.txt
git commit -m "feat: seed feature.txt"

echo "readme" > README.md
git add README.md
git commit -m "docs: add README"

git log --oneline --graph --decorate --all
echo "Repo ready in $PWD"

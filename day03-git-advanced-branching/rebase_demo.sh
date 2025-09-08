#!/usr/bin/env bash
set -euo pipefail
cd lab-git

git checkout -b feature/rebase main
echo "r1" >> rebase.txt
git add rebase.txt
git commit -m "feat(rebase): add r1"
echo "r2" >> rebase.txt
git commit -am "feat(rebase): add r2"

git checkout main
echo "main-x" >> app.txt
git commit -am "chore: main x"

git checkout feature/rebase
git rebase main

echo "== Graph after rebase =="
git log --oneline --graph --decorate --all --max-count=30

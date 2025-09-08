#!/usr/bin/env bash
set -euo pipefail
cd lab-git

git checkout -b feature/ff main
echo "line-a" >> feature.txt
git commit -am "feat: add line-a to feature"
echo "line-b" >> feature.txt
git commit -am "feat: add line-b to feature"

git checkout main
git merge --ff-only feature/ff

echo "== Graph after FF merge =="
git log --oneline --graph --decorate --all --max-count=20

#!/usr/bin/env bash
set -euo pipefail
cd lab-git

git checkout -b feature/noff main
echo "nof-1" >> app.txt
git commit -am "feat(noff): change app 1"
echo "nof-2" >> app.txt
git commit -am "feat(noff): change app 2"

git checkout main
echo "hotfix" >> app.txt
git commit -am "fix: hotfix on main"

git merge --no-ff feature/noff -m "merge(feature/noff): keep history context"

echo "== Graph after --no-ff merge =="
git log --oneline --graph --decorate --all --max-count=30

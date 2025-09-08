#!/usr/bin/env bash
set -euo pipefail
cd lab-git

echo "bad change" >> app.txt
git commit -am "feat: introduce a buggy change"

git revert --no-edit HEAD

echo "== History with revert commit =="
git log --oneline --graph --decorate --all --max-count=20

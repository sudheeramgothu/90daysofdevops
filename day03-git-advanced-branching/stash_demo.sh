#!/usr/bin/env bash
set -euo pipefail
cd lab-git

git checkout -b feature/wip main
echo "WIP work" >> wip.txt
git add wip.txt
echo "unsaved" >> temp.txt

git stash push -u -m "wip: saving staged+unstaged"
git checkout main

git checkout feature/wip
git stash list
git stash apply 0

echo "== Status after stash apply =="
git status --short

#!/usr/bin/env bash
set -euo pipefail
cd lab-git

git checkout -b feature/docs main
echo "- doc line" >> README.md
git commit -am "docs: add doc line"
DOC_COMMIT=$(git rev-parse --short HEAD)

git checkout main
git cherry-pick "$DOC_COMMIT"

echo "Cherry-picked $DOC_COMMIT into main"
git log --oneline --graph --decorate --all --max-count=20

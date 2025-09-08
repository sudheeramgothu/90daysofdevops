#!/usr/bin/env bash
set -euo pipefail
cd lab-git

git tag -a v0.1.0 -m "Initial learning milestone"
git tag -a v0.1.1 -m "Docs cherry-picked"

git tag --list -n

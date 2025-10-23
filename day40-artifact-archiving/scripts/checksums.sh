#!/usr/bin/env bash
set -euo pipefail
DIST="${1:-day40-artifact-archiving/dist}"; REPORTS="${2:-day40-artifact-archiving/reports}"
mkdir -p "$REPORTS"
for f in "$DIST"/*; do
  [ -f "$f" ] || continue
  sha256sum "$f" > "$f.sha256"
  cp "$f.sha256" "$REPORTS/$(basename "$f").sha256"
done

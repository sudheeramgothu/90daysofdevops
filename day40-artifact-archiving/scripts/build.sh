#!/usr/bin/env bash
set -euo pipefail
APP="${1:-demo-app}"; FMT="${2:-tgz}"; OUT="${3:-day40-artifact-archiving/dist}"
VER="${BUILD_NUMBER:-0}"; STAMP="$(date -u +%Y%m%dT%H%M%SZ)"
TMP="$(mktemp -d)"; mkdir -p "$TMP/$APP"
echo "Build $VER at $STAMP" > "$TMP/$APP/README.txt"
echo '{"healthy": true}' > "$TMP/$APP/health.json"
mkdir -p "$OUT"
case "$FMT" in
  tgz) tar -C "$TMP" -czf "$OUT/${APP}-${VER}.tgz" "$APP" ;;
  zip) (cd "$TMP" && zip -qr "$OUT/${APP}-${VER}.zip" "$APP") ;;
  *) echo "unknown fmt" ; exit 2 ;;
esac

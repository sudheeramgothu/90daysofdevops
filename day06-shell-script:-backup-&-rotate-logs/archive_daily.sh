#!/usr/bin/env bash
# Daily archive: tar.gz of current logs (without truncation), retention in days
# Usage: archive_daily.sh <source_dir> <backup_dir> [retention_days]
set -euo pipefail
SRC="${1:-./lab-logs}"
DEST="${2:-./backups/daily}"
RETENTION_DAYS="${3:-14}"

mkdir -p "$DEST"
day="$(date '+%Y%m%d')"
archive="$DEST/daily-$day.tar.gz"

tar -C "$SRC" -czf "$archive" -- *.log
( cd "$DEST" && sha256sum "$(basename "$archive")" > "$(basename "$archive").sha256" )
echo "Daily archive created: $archive"

find "$DEST" -type f -name 'daily-*.tar.gz' -mtime +"$RETENTION_DAYS" -print -delete || true
find "$DEST" -type f -name 'daily-*.tar.gz.sha256' -mtime +"$RETENTION_DAYS" -print -delete || true

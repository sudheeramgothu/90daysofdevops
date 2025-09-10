#!/usr/bin/env bash
# Time-based rotation: copy-truncate current logs to a dated archive and prune old archives
# Usage: backup_rotate.sh <source_dir> <backup_dir> [retention_days]
set -euo pipefail
SRC="${1:-./lab-logs}"
DEST="${2:-./backups}"
RETENTION_DAYS="${3:-7}"

stamp="$(date '+%Y%m%d-%H%M%S')"
mkdir -p "$DEST"
tmpdir="$(mktemp -d)"
trap 'rm -rf "$tmpdir"' EXIT

# copy-truncate each *.log to avoid losing writes
shopt -s nullglob
for f in "$SRC"/*.log; do
  base="$(basename "$f")"
  cp --preserve=mode,timestamps "$f" "$tmpdir/$base"
  : > "$f"  # truncate
done

archive="$DEST/logs-$stamp.tar.gz"
tar -C "$tmpdir" -czf "$archive" .
echo "Created archive: $archive"

# checksum for integrity
( cd "$DEST" && sha256sum "$(basename "$archive")" > "$(basename "$archive").sha256" )
echo "Checksum written: $archive.sha256"

# prune by retention days
find "$DEST" -type f -name 'logs-*.tar.gz' -mtime +"$RETENTION_DAYS" -print -delete || true
find "$DEST" -type f -name 'logs-*.tar.gz.sha256' -mtime +"$RETENTION_DAYS" -print -delete || true

ls -lh "$DEST" | sed 's/^/  /'

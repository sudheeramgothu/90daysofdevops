#!/usr/bin/env bash
# Restore logs from an archive into a target directory
# Usage: restore_from_archive.sh <backup_dir> <archive_name.tar.gz> <restore_dir>
set -euo pipefail
BACKUP_DIR="${1:-./backups}"
ARCHIVE="${2:-}"
RESTORE_DIR="${3:-./restore}"

if [[ -z "$ARCHIVE" ]]; then
  echo "Usage: restore_from_archive.sh <backup_dir> <archive_name.tar.gz> <restore_dir>"
  exit 1
fi

mkdir -p "$RESTORE_DIR"
tar -C "$RESTORE_DIR" -xzf "$BACKUP_DIR/$ARCHIVE"
echo "Restored to $RESTORE_DIR"
ls -lh "$RESTORE_DIR"

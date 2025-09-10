#!/usr/bin/env bash
# Size-based rotation: rotate files larger than N MB into .1.gz and shift older ones
# Usage: rotate_by_size.sh <source_dir> <max_mb>
set -euo pipefail
SRC="${1:-./lab-logs}"
MAX_MB="${2:-1}"

bytes=$(( MAX_MB * 1024 * 1024 ))
shopt -s nullglob
for f in "$SRC"/*.log; do
  sz=$(stat -c %s "$f")
  if (( sz > bytes )); then
    # shift .3.gz -> .4.gz etc. keep 4 generations
    for n in 4 3 2 1; do
      if [[ -f "$f.$n.gz" ]]; then mv "$f.$n.gz" "$f.$((n+1)).gz"; fi
    done
    gzip -c "$f" > "$f.1.gz"
    : > "$f"
    echo "Rotated $f -> $f.1.gz (size was $sz bytes)"
  fi
done

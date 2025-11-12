#!/usr/bin/env bash
set -euo pipefail
RELEASE="${1:-demo-worker}"; REVISION="${2:-0}"
if [ "$REVISION" = "0" ]; then helm rollback "$RELEASE"; else helm rollback "$RELEASE" "$REVISION"; fi

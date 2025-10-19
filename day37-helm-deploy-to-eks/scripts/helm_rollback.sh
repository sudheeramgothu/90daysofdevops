#!/usr/bin/env bash
set -euo pipefail
helm rollback "${1}" "${2:-1}" -n "${3:-demo}"

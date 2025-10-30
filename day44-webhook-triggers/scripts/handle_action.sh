#!/usr/bin/env bash
set -euo pipefail
ENV=$1; ACT=$2; TAG=$3; REPL=$4; AUD=$5
log(){ echo "[$(date -u +%FT%TZ)] $*" | tee -a "$AUD"; }
case "$ACT" in deploy) log deploy "$ENV" "$TAG"; sleep 1;; rollback) log rollback "$ENV"; sleep 1;; scale) log scale "$ENV" "$REPL"; sleep 1;; *) log err; exit 1;; esac
log done

#!/usr/bin/env bash
set -euo pipefail
ENV=$1; ACT=$2; TAG=$3; BY=$4; REPL=$5; AUD=$6
case "$ENV" in staging|prod) ;; *) echo 'bad env' | tee -a "$AUD"; exit 1;; esac
case "$ACT" in deploy|rollback|scale) ;; *) echo 'bad action' | tee -a "$AUD"; exit 1;; esac
if [ "$ENV" = prod ] && [[ ! "$BY" =~ ^(release-bot|sre-oncall|automation-bot)$ ]]; then echo 'prod blocked' | tee -a "$AUD"; exit 1; fi
echo 'OK' | tee -a "$AUD"

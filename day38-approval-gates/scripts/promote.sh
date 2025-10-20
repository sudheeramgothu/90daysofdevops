#!/usr/bin/env bash
set -euo pipefail
IMAGE="${1:?}"; SRC="${2:?}"; ENV="${3:?}";
case "$ENV" in dev) DST=dev;; staging) DST=staging;; prod) DST=prod;; *) echo bad env; exit 2;; esac
echo "Tagging ${IMAGE}:${SRC} -> ${IMAGE}:${DST}"; docker pull "${IMAGE}:${SRC}" || true; docker tag "${IMAGE}:${SRC}" "${IMAGE}:${DST}" || true; docker push "${IMAGE}:${DST}" || true

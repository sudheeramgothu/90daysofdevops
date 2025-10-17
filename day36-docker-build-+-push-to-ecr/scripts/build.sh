#!/usr/bin/env bash
set -euo pipefail
ROOT='day36-docker-build-push-ecr'
APP_DIR="$ROOT/docker"
echo '[build] Building demo/app:local'
docker build -t demo/app:local "$APP_DIR"

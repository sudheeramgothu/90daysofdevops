#!/usr/bin/env bash
set -euo pipefail
ENV="${1:?usage: helm_template.sh <staging|prod>}"
helm template demo-worker charts/demo-worker -f charts/demo-worker/values-${ENV}.yaml

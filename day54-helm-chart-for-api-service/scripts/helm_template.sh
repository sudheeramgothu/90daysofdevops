#!/usr/bin/env bash
set -euo pipefail
ENV="${1:?usage: helm_template.sh <staging|prod>}"
helm template demo charts/demo-api -f charts/demo-api/values-${ENV}.yaml

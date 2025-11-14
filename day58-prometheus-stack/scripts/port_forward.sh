#!/usr/bin/env bash
set -euo pipefail
kubectl -n monitoring port-forward svc/kp-stack-grafana 3000:80

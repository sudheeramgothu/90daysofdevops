#!/usr/bin/env bash
set -euo pipefail
NS=logging
kubectl -n ${NS} get ds fluent-bit
kubectl -n ${NS} get pods -l app=fluent-bit -o wide

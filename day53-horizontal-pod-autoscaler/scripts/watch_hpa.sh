#!/usr/bin/env bash
set -euo pipefail
watch -n 3 'kubectl get hpa hpa-demo; echo ---; kubectl get deploy hpa-demo; echo ---; kubectl get pods -l app=hpa-demo -o wide'

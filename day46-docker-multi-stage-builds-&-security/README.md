# Day 46 — Docker Multi‑Stage Builds & Image Security

## Overview
Production‑grade container build for a small FastAPI service using multi‑stage Dockerfile, non‑root, pinned deps, SBOM (optional), and Trivy scan.

## Quickstart
docker build -t demo-api:day46 .
bash scripts/run_container.sh demo-api:day46 8080
curl -s localhost:8080/health


# Day 43 — Nightly Synthetic Tests

## Overview
Nightly synthetic monitoring pipeline: hit a live URL, measure health & latency, alert on failure, store JSON report.

## Goals
- Jenkins scheduled job (cron nightly)
- SLA-style availability check
- Optional Slack alert + S3 archival

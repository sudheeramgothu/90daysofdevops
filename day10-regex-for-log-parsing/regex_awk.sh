#!/usr/bin/env bash
set -euo pipefail
# Extract IP, method, path, status using awk regex and fields
awk '{
  ip=$1
  gsub(/"/,"",$6); method=$6
  path=$7
  status=$9
  bytes=$10
  printf "%s\t%s\t%s\t%s\t%s\n", ip, method, path, status, bytes
}' sample.log | column -t | sed '1i IP\tMETHOD\tPATH\tSTATUS\tBYTES'

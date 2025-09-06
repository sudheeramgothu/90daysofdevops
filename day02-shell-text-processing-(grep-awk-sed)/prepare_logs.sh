#!/usr/bin/env bash
set -euo pipefail
cat > sample.log <<'EOF'
192.168.0.10 - - [05/Sep/2025:10:00:00] "GET /index.html HTTP/1.1" 200 512
192.168.0.11 - - [05/Sep/2025:10:01:00] "GET /login HTTP/1.1" 200 2310
192.168.0.10 - - [05/Sep/2025:10:01:05] "GET /secret HTTP/1.1" 403 123
192.168.0.12 - - [05/Sep/2025:10:01:15] "GET /favicon.ico HTTP/1.1" 404 0
192.168.0.13 - - [05/Sep/2025:10:02:00] "POST /api/data HTTP/1.1" 200 999
192.168.0.10 - - [05/Sep/2025:10:03:00] "GET /old-path/page HTTP/1.1" 404 0
EOF
echo "Sample log created at sample.log"

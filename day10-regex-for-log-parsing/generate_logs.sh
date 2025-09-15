#!/usr/bin/env bash
set -euo pipefail
cat > sample.log <<'EOF'
192.168.1.10 - - [10/Sep/2025:10:00:00 +0000] "GET /index.html HTTP/1.1" 200 1024 "-" "Mozilla/5.0"
192.168.1.11 - - [10/Sep/2025:10:01:00 +0000] "POST /api/login HTTP/1.1" 401 321 "-" "curl/7.88.1"
10.0.0.5 - - [10/Sep/2025:10:02:10 +0000] "GET /favicon.ico HTTP/1.1" 404 0 "-" "Mozilla/5.0"
172.16.0.7 - - [10/Sep/2025:10:03:33 +0000] "GET /old-path/page HTTP/1.1" 301 0 "-" "Mozilla/5.0"
203.0.113.9 - - [10/Sep/2025:10:04:55 +0000] "GET /admin HTTP/1.1" 403 123 "-" "Mozilla/5.0"
203.0.113.9 - - [10/Sep/2025:10:05:05 +0000] "GET /wp-admin HTTP/1.1" 403 123 "-" "Mozilla/5.0"
192.168.1.10 - - [10/Sep/2025:10:06:42 +0000] "GET /api/data?id=42 HTTP/1.1" 200 2048 "-" "python-requests/2.31.0"
198.51.100.4 - - [10/Sep/2025:10:07:58 +0000] "GET /../../etc/passwd HTTP/1.1" 400 0 "-" "BadBot/1.0"
EOF
echo "sample.log created"

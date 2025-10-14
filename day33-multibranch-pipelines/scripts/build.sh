
#!/usr/bin/env bash
set -euo pipefail
echo "[build] building application (placeholder)"
cat > Dockerfile <<'EOF'
FROM alpine:3.20
RUN adduser -D app
USER app
CMD ["sh","-c","echo demo-api on $HOSTNAME"]
EOF

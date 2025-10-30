#!/usr/bin/env bash
set -euo pipefail
URL="${1:?url required}"
ENV="${2:?env required}"
OUTDIR="${3:?outdir required}"
mkdir -p "$OUTDIR"

BODY="$(mktemp)"
META="$(mktemp)"
curl -s -o "$BODY" -w "status=%{http_code}\ntime_total=%{time_total}\n" "$URL" > "$META" || true

STATUS_CODE="$(grep '^status=' "$META" | cut -d'=' -f2)"
TOTAL_TIME="$(grep '^time_total=' "$META" | cut -d'=' -f2)"
HEALTH="PASS"; [ "$STATUS_CODE" != "200" ] && HEALTH="FAIL"

STAMP="$(date -u +%Y-%m-%dT%H:%M:%SZ)"
REPORT_FILE="${OUTDIR}/synthetic-${ENV}-${STAMP}.json"
cat > "$REPORT_FILE" <<EOF
{"env":"${ENV}","url":"${URL}","timestamp_utc":"${STAMP}","status_code":${STATUS_CODE},"latency_seconds":${TOTAL_TIME:-0},"health":"${HEALTH}"}
EOF

echo "[synthetic] wrote $REPORT_FILE"
[ "$HEALTH" = "FAIL" ] && exit 1

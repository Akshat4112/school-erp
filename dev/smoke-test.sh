#!/usr/bin/env bash
set -euo pipefail
url="${1:-http://localhost:8080/SchoolERP/}"
response=$(mktemp)
trap 'rm -f "$response"' EXIT
for attempt in $(seq 1 30); do
  if curl --fail --silent --show-error --max-time 10 --output "$response" "$url"; then
    if grep -qiE 'Fatal error|An uncaught Exception|A PHP Error was encountered|A Database Error Occurred' "$response"; then
      echo "Application returned a PHP/database error. First sanitized response lines:" >&2
      sed -E 's/<[^>]+>/ /g' "$response" | sed -E '/^[[:space:]]*$/d' | head -c 1500 >&2 || true
      exit 1
    fi
    if grep -qiE 'SchoolERP|SchooLERP|school' "$response"; then
      echo "PASS: homepage responded without detected PHP/database errors"
      exit 0
    fi
    echo "Homepage responded but expected school branding was not found." >&2
    head -c 400 "$response" >&2
    exit 1
  fi
  sleep 2
done
echo "FAIL: homepage did not become available at $url" >&2
exit 1

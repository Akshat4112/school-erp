#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
base="${1:-http://localhost:8080/SchoolERP/}"
base="${base%/}"
jar="$(mktemp)"
response="$(mktemp)"
trap 'rm -f "$jar" "$response"' EXIT
password="$(sed -n 's/^SCHOOLERP_DEMO_ADMIN_PASSWORD=//p' .env | head -n1)"
if [[ -z "$password" ]]; then
  echo "Missing cloud demo credentials." >&2
  exit 1
fi
anonymous_status="$(curl -sS -o "$response" -w '%{http_code}' "$base/certificates/dashboard")"
if [[ "$anonymous_status" != "307" && "$anonymous_status" != "302" ]]; then
  echo "SECURITY FAIL: unauthenticated certificate dashboard returned HTTP $anonymous_status, expected redirect." >&2
  exit 1
fi
login_status="$(curl -sS -c "$jar" -b "$jar" -o "$response" -w '%{http_code}' \
  --data-urlencode 'email=cloud-demo@school.invalid' \
  --data-urlencode "password=$password" \
  "$base/home/admin_login")"
if [[ "$login_status" != "303" && "$login_status" != "302" ]]; then
  echo "AUTH FAIL: demo login returned HTTP $login_status, expected redirect." >&2
  exit 1
fi
dashboard_status="$(curl -sS -c "$jar" -b "$jar" -o "$response" -w '%{http_code}' "$base/dashboard")"
if [[ "$dashboard_status" != "200" ]]; then
  echo "AUTH FAIL: logged-in dashboard returned HTTP $dashboard_status." >&2
  exit 1
fi
if grep -qiE 'Fatal error|An uncaught Exception|A PHP Error was encountered|A Database Error Occurred' "$response"; then
  echo "AUTH FAIL: logged-in dashboard contains a PHP/database error." >&2
  exit 1
fi
echo "PASS: certificate endpoint rejects anonymous users; synthetic demo admin login and dashboard work"

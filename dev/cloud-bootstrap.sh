#!/usr/bin/env bash
# Private GitHub Codespaces and ephemeral GitHub Actions setup; never a public deployment.
set -euo pipefail
cd "$(dirname "$0")/.."
umask 077
if [[ ! -f .env ]]; then
  {
    printf 'SCHOOLERP_DB_PASSWORD=%s\n' "$(openssl rand -hex 24)"
    printf 'SCHOOLERP_DB_ROOT_PASSWORD=%s\n' "$(openssl rand -hex 24)"
    printf 'SCHOOLERP_DEMO_ADMIN_PASSWORD=%s\n' "$(openssl rand -hex 24)"
  } > .env
fi
if ! grep -q '^SCHOOLERP_DEMO_ADMIN_PASSWORD=' .env; then
  printf 'SCHOOLERP_DEMO_ADMIN_PASSWORD=%s\n' "$(openssl rand -hex 24)" >> .env
fi
python3 dev/prepare-schema.py school_erp.sql dev/schema-only.sql
# DDL contains no historical records or credentials; MariaDB's mysql user must read it.
chmod 644 dev/schema-only.sql
docker compose up -d --build
docker compose exec -T web php dev/seed-demo-admin.php
bash dev/smoke-test.sh
bash dev/test-cloud-auth.sh
printf '\nCloud development workspace ready.\n'
printf 'Open port 8080 and append /SchoolERP/ to the forwarded browser URL.\n'
printf 'Demo email: cloud-demo@school.invalid\n'
printf 'Demo password is stored in .env (not in Git).\n'

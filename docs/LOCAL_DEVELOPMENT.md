# School ERP — isolated local development

> **SECURITY WARNING**: This 2017–2018 CodeIgniter/PHP application has known serious vulnerabilities (see GitHub issue #36), and PHP 7.4 is end-of-life. The following setup is **only for local debugging and migration**. Never expose it to the Internet or use genuine student, parent, or staff data.

## Prerequisites

- Docker Engine with Docker Compose v2
- Git
- Port 8080 available on loopback

## Start

```bash
git clone https://github.com/Akshat4112/school-erp.git
cd school-erp
cp .env.example .env
# Optional: change the two demo database passwords in .env
docker compose up -d --build
bash dev/smoke-test.sh
```

Open http://localhost:8080/SchoolERP/ .

The local MariaDB instance starts without a published database port. On its first launch it imports `school_erp.sql` to `school_erp`. The code uses the database credentials and base URL supplied as container environment variables, while retaining the existing non-Docker defaults.

## Inspect and stop

```bash
docker compose ps
docker compose logs --tail=100 web db
docker compose down
```

To **delete** the local database and reimport the original dump on the next start:

```bash
docker compose down -v
```

Do not run `down -v` if you need to preserve local data.

## Important limitations

- This is a compatibility environment, not a secure production stack. It uses unsupported PHP 7.4 to help diagnose the original application. The compatibility image initially installs only the MySQL drivers; Excel/PDF/image workflows may require additional PHP extensions in a later milestone.
- The repository SQL dump contains legacy sample data and credentials. Do not reuse those credentials and do not expose this dataset.
- Existing controller-level authentication, plaintext password handling, SQL injection risks, CSRF settings and authorization must be repaired before deploying publicly.
- Do not assume a successful homepage smoke test validates business workflows, database integrity or security.
- If your database volume already exists, changing `.env` credentials does not reinitialize MariaDB. Use a fresh local volume.
- Apache rewrites assume the historical `/SchoolERP/` URL prefix. Browser requests should use that prefix.
- The GitHub Actions workflow performs PHP lint and a local HTTP smoke test for pull requests.

## First modernization milestones

1. Security: authenticated-by-default routing, password hashing/migration, role checks, query-column allowlists, CSRF and safe session cookies.
2. Reliability: confirm import, login, admissions, fees, attendance, certificates and report generation with synthetic fixtures.
3. Compatibility: upgrade legacy CodeIgniter/PHP and vendored dependencies, and add regression tests before removing the isolated runtime.
4. UX: responsive navigation, usable tables, consistent forms, role-specific dashboards and accessibility.

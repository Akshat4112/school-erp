# School ERP — browser-only cloud development

This application is an insecure legacy CodeIgniter project. Do not use genuine student or staff information or make any forwarded port public.

## Open the entire project in GitHub Codespaces (no local software)

1. Open [School ERP on GitHub](https://github.com/Akshat4112/school-erp).
2. Select **Code → Codespaces → Create codespace** and choose the `chore/schoolerp-reproducible-local-setup` branch until PR #38 is merged. After merge, use `master`.
3. Codespaces initializes Docker in the cloud, creates random local demo credentials in the gitignored `.env` file, generates a schema-only database (without records from the historical dump), and starts the PHP ERP automatically.
4. In the browser Codespaces **Ports** tab, open forwarded port **8080** and append `/SchoolERP/` to the generated URL if it is not already present.
5. Log in with email `cloud-demo@school.invalid` and the **SCHOOLERP_DEMO_ADMIN_PASSWORD** value in the workspace's `.env`.

GitHub Codespaces forwarded ports are private by default. **Keep port 8080 private**. Never change it to public. The app has other known vulnerabilities and is not secure for public deployment. The browser port may be an HTTPS GitHub-forwarded URL while Apache serves HTTP inside the container.

## Continuous checks entirely on GitHub

Every pull request runs a disposable GitHub-hosted environment that:

- Imports only DDL (34 expected tables) from the original SQL, never historical INSERT data
- Creates one synthetic administrator using a unique random password hash
- Starts PHP + MariaDB and tests the homepage, unauthenticated certificate access, admin login, and logged-in dashboard
- Lints the app's PHP controllers/models/core
- Confirms zero historical student records were imported
- Attempts to capture a homepage PNG and uploads it to the Actions run as a downloadable artifact
- Shuts down the containers and deletes the ephemeral DB volume

Run checks from **Actions → School ERP cloud integration → Run workflow** once the workflow is merged to the default branch. CI logs and screenshots are viewable on GitHub, with no local installation.

## Security and migration limitations

- This is a **private development workspace**, not a persistent public production deployment or staging server. Codespaces may incur usage charges.
- PHP 7.4 is unsupported and is used only for compatibility debugging.
- Existing plaintext credentials in `school_erp.sql` are explicitly omitted from the runtime; the synthetic demo admin uses a salted PHP password hash.
- No legacy real accounts will authenticate through the hash-only login path until a secure password-reset/migration flow is designed.
- Identity, role-based authorization, CSRF protection, input validation, file uploads, and supported dependency upgrades remain outstanding security work.
- You can stop or delete the Codespace from GitHub to stop compute usage. The workspace's database is disposable demo data only.

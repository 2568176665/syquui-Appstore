---
name: 1panel-app-builder
description: Use when packaging Docker deployments as 1Panel local app store apps, including GitHub projects, docker-compose.yml files, docker run commands, app metadata, version directories, icons, README files, and 1Panel validation.
---

# 1Panel App Builder

Build or review 1Panel local app store packages from Docker deployments.

## When To Use

Use this skill when the user asks to:

- Add or package a 1Panel local app store app.
- Convert a GitHub project, `docker-compose.yml`, or `docker run` command into `apps/<app-key>/`.
- Fix 1Panel app metadata, port variables, compose files, README files, icons, or version directories.
- Validate an app package before commit.

For detailed real app examples, read `references/1panel-examples.md` only when needed.

## Required Shape

```text
apps/<app-key>/
├── data.yml
├── logo.png
├── README.md
├── README_en.md
└── <version>/
    ├── data.yml
    ├── docker-compose.yml
    └── data/
```

Some apps also include `latest/`. When both `latest/` and a concrete version exist, `latest/` must use image tag `latest`, and the concrete version directory should use the pinned tag.

## Workflow

1. Inspect the source deployment.
   - GitHub: inspect README/deploy docs and registry image; the generator checks common compose paths before README `docker run` fallback.
   - Compose: parse services, image tags, ports, volumes, environment, dependencies.
   - Docker run: parse image, `--name`, `-p/--publish`, `-v/--volume`, `-e/--env`, and `--env-file`.
2. Choose a stable app key.
   - Lowercase, hyphenated, directory-safe.
   - `additionalProperties.key` must match the directory name.
3. Generate or edit app files.
   - Prefer `latest/` plus a concrete version when a concrete image tag is known.
   - Preserve source volumes and environment unless they conflict with 1Panel conventions.
4. Resolve a real icon.
   - Do not create placeholders.
   - Use `--icon-mode skip` for drafts, `cache-only` for offline work, and `required` when an icon is mandatory.
5. Validate before delivery.
   - From the skill directory, run `./scripts/validate-app.sh ../../../apps/<app-key>`.
   - For Skill script changes, run `./tests/run_all.sh`.

## 1Panel Rules

- `container_name` should be `${CONTAINER_NAME}`.
- Services should use `restart: always`.
- Use external `1panel-network`.
- Port mappings should use `PANEL_APP_PORT_*` variables defined in the version `data.yml`.
- Persistent mounts should prefer relative `./data/...` paths.
- Add `labels: createdBy: "Apps"`.
- Keep metadata tags aligned with top-level `data.yaml`.

Preferred port variables:

```text
PANEL_APP_PORT_HTTP
PANEL_APP_PORT_HTTPS
PANEL_APP_PORT_API
PANEL_APP_PORT_ADMIN
PANEL_APP_PORT_PROXY
PANEL_APP_PORT_PROXY_HTTP
PANEL_APP_PORT_PROXY_HTTPS
PANEL_APP_PORT_DB
PANEL_APP_PORT_SSH
PANEL_APP_PORT_S3
PANEL_APP_PORT_SYNC
```

## Known failure modes and fixes

Use this checklist when an app depends on a 1Panel-managed database or one-shot initialization service.

### Passwords

- Declare `PANEL_DB_USER_PASSWORD` as a `password` form field with a non-empty alphanumeric `default` when `random: true` is used. 1Panel generates `default + "_" + six-character-random-string`; an empty default produces `_xxxxxx`, which fails because a special character cannot be first.
- For the current 1Panel `paramComplexity` rule, allow English letters, digits, `.%@!~_-`, length 6–128, and require an English letter or digit at both ends. Do not copy older documentation that says 6–30 or includes `$`/`&` without checking the target 1Panel version.
- Apply the same valid-password check to database, administrator, and other generated secrets. Test a generated example, not only the literal `default` value.

### Named databases and users

- Declare `PANEL_DB_NAME`, `PANEL_DB_USER`, and `PANEL_DB_USER_PASSWORD` in every version-level `data.yml`; a Compose variable alone does not make the database visible in 1Panel.
- Give all three fields non-empty defaults. Use `random: true` for the database name and user when multiple installations may share the host, and keep their generated values within `paramCommon`.
- Bind the exact same variables in Compose and pass them to the application. When 1Panel pre-creates the database and user, do not let the application create, drop, or silently rename the database.

### Permissions and initialization

- For bind-mounted directories owned by the application user, add a root one-shot permission service that creates required files/directories and runs `chown` before configurator, migration, or site-creation services. Gate dependents with `condition: service_completed_successfully`.
- For Frappe site creation, pass the named database/user/password explicitly and use `--no-setup-db` when 1Panel has already created the database; retain the application's schema/bootstrap step.
- Verify the actual command supported by the image with its `--help`. Do not use unsupported options such as `bench new-site --no-enqueue`, and do not add runtime `bench new-site --force` to work around an existing database or site.
- Frappe stable images may be based on v15, where `bench new-site --db-user` is unsupported; set `db_user` in `common_site_config.json` before site creation and verify the image's actual `--help` output instead of copying v16 options.
- Frappe's Docker frontend includes its own nginx-like service. Keep its internal target port separate from the 1Panel host port, and choose an external default that does not collide with 1Panel's proxy ports.
- Frappe creates `site_config.json` before database bootstrap. Do not treat an existing site directory as a successful installation; verify the installed app with `bench --site <site> list-apps` and fail clearly on incomplete leftovers instead of deleting them or retrying with `--force`.
- Distinguish the generator's `generate-app.sh --force` (overwriting a generated output directory) from an application's runtime `--force`; use either only with explicit scope and a verified target.

### Redis and site names

- When Redis authentication is enabled, use a complete URI such as `redis://:<password>@<host>:6379` consistently for cache, queue, and websocket configuration; a missing `:` or password creates misleading startup failures.
- Do not treat a VPS IP used as a Frappe site name as the first explanation for database-creation failures. Inspect the `CreateSite` logs, database credentials, service dependencies, and permissions first; keep the site name and reverse-proxy host consistent.

### Host port safety

- Never use `80`, `443`, or `8080` as an application's default host port; these commonly belong to 1Panel's Nginx or proxy services. This restriction applies to the host side of `HOST:CONTAINER` mappings, not to an application's required internal target port.
- When a source Compose file uses a reserved host port, remap the generated 1Panel default to a safe high port and keep the container target unchanged. Document any proxy-specific mapping explicitly.
- When remapping reserved ports, compare each candidate with all original and already-assigned host ports so the generated defaults cannot collide with another mapping.

### Validation

- Resolve script paths from the actual skill root. In this repository the tools live under `.agents/skills/1panel-app-builder/scripts`; do not assume the upstream `/root/github/1Panel-Appstore/skills` path or a top-level `skills/` directory exists.
- Validate every `latest/` and concrete version directory after changing shared form fields. Check the generated database name, user, and password against their rules and confirm every Compose reference has a matching form field.
- Treat a validator warning about a path such as `/home/frappe/...` as a container-target-path warning; only change it when the host-side volume source is actually absolute and should be converted to `./data/...`.
- Inspect `git status --short` before and after edits and preserve unrelated user changes, including untracked files.

## Scripts

Run from the skill directory unless noted. In this repository, that is `.agents/skills/1panel-app-builder`.

Generate a draft:

```bash
./scripts/generate-app.sh --app-key my-app --name MyApp --version 1.2.3 --icon-mode skip ./docker-compose.yml
```

Useful generation options:

```text
--output <dir>       Output base directory. Default: ./apps
--app-key <key>      Override app directory key.
--name <name>        Override display name.
--service <name>     Select the main service from a multi-service compose file.
--version <tag>      Override concrete version and image tag.
--icon-mode <mode>   auto|required|skip|cache-only
--icon-url <url>     Download icon from a known URL.
--force              Allow overwriting an existing generated directory.
--dry-run            Print parsed values without writing files.
--check-deps         Check required local tools.
```

Download an icon:

```bash
./scripts/download-icon.sh --mode cache-only redis ./logo.png
./scripts/download-icon.sh --mode required --url https://example.com/logo.png myapp ./logo.png
```

Validate an app:

```bash
./scripts/validate-app.sh ../../../apps/<app-key>
```

Validate Skill tooling:

```bash
./tests/run_all.sh
```

## Icon Policy

Icon lookup order:

1. Known explicit URL (`--icon-url`).
2. Local cache under `.cache/icons` in the skill directory.
3. Dashboard Icons.
4. Simple Icons.
5. selfh.st Icons.

Missing icons are acceptable for drafts only. For final app delivery, leave `logo.png` absent and tell the user what is missing instead of inventing an inaccurate image.

## Validation Gate

Before considering an app ready:

- Run `./scripts/validate-app.sh ../../../apps/<app-key>` from the skill directory.
- Confirm `latest/` uses `:latest`.
- Confirm concrete version directories use matching image tags or document the exception.
- Confirm every compose `PANEL_APP_PORT_*` variable exists in the version `data.yml`.
- Inspect generated README and metadata manually; the generator is a starting point, not an authority.

## Common Mistakes

- Keeping a placeholder `logo.png`.
- Using a host absolute volume path when `./data/...` would work.
- Forgetting to define a port variable used by `docker-compose.yml`.
- Letting `additionalProperties.key` drift from the app directory name.
- Treating generated metadata, descriptions, tags, and architectures as final without review.

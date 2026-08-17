---
name: 1panel-app-builder
description: Build, review, repair, and validate 1Panel local App Store packages from Docker deployments. Use for GitHub projects, Compose files, docker run commands, app metadata, version directories, external 1Panel database/Redis integration, initialization/migration flows, icons, README files, and delivery ZIPs.
---

# 1Panel App Builder

Build or review production-oriented 1Panel local App Store packages.

## When To Use

Use this skill when the user asks to:

- Add or package a 1Panel local App Store app.
- Convert a GitHub project, `docker-compose.yml`, or `docker run` command into `apps/<app-key>/`.
- Review or repair an existing 1Panel app package.
- Reuse 1Panel-managed MySQL/MariaDB/PostgreSQL/Redis instead of bundling duplicate services.
- Fix first-run initialization, migrations, permissions, health checks, ports, persistent volumes, WebSocket/reverse-proxy behavior, or version pinning.
- Validate and ZIP an app package for delivery.

For concrete upstream examples, read `references/1panel-examples.md` only when needed.

## Required Shape

```text
apps/<app-key>/
├── data.yml
├── logo.png
├── README.md
├── README_en.md
└── <version>/
    ├── data.yml
    └── docker-compose.yml
```

Runtime data directories such as `data/`, `logs/`, `conf/`, or `storage/` are **optional**. Create or commit them only when the app actually needs seed/config files. Bind mounts may create empty runtime directories automatically.

## Source Of Truth

Before editing a non-trivial app, verify both:

1. The current upstream deployment instructions/image for the application.
2. The current 1Panel App Store conventions from official `1Panel-dev/appstore` examples.

Do not infer a production architecture from a README snippet when the upstream repository provides a dedicated production Compose file.

## Version Policy

Default to a **pinned concrete version only**.

- Prefer the concrete image tag already present in the verified upstream Compose/release.
- Preserve `v` in the image tag when upstream uses it; version directories may omit the leading `v`.
- Do **not** create `latest/`, `stable/`, or other floating channel directories by default.
- Do not replace a concrete upstream tag with whatever tag a registry happens to report as newest.
- Add a floating channel only when the user explicitly requests it and the upstream project documents that channel as safe.
- For business-critical apps, avoid automatic upgrades. Treat each new app version as an explicit tested package update.

## Workflow

1. **Inspect the source deployment.**
   - Prefer upstream production Compose/deployment docs.
   - Record all services, images, ports, volumes, environment, commands, health checks, dependencies, init/migrate jobs, required extensions, and proxy/WebSocket behavior.
2. **Classify the app.**
   - Single-service: the generator can usually create a useful draft.
   - Multi-service: preserve the full stack manually unless every dropped dependency is intentionally replaced by a 1Panel-managed service.
3. **Choose a stable app key.**
   - Lowercase, hyphenated, directory-safe.
   - `additionalProperties.key` must match the app directory name.
4. **Decide dependency strategy.**
   - Prefer 1Panel-managed DB/Redis only when the app supports external instances cleanly.
   - Keep a bundled dependency when the app requires a special database image/extension/version (for example pgvector) or an upstream-specific topology.
5. **Build first-run and upgrade flows.**
   - Separate one-shot permission/init/migrate jobs from long-running services.
   - Make initialization idempotent; a partially-created directory must not be treated as successful setup.
6. **Generate/edit app metadata and Compose.**
   - Preserve upstream semantics; never invent generic volumes, PUID/PGID, or environment variables that the source app does not use.
7. **Resolve a real icon.**
   - Never invent a placeholder logo.
8. **Validate.**
   - Validate YAML, version tags, form variables, persistent paths, external service selectors, init/migrate behavior, reverse-proxy behavior, and app-specific requirements.
9. **Package.**
   - Preserve executable bits for scripts and include only intentional files; remove caches/build garbage before zipping.

## 1Panel Conventions

- The main app service should normally use `container_name: ${CONTAINER_NAME}`. Dependency/one-shot services may omit `container_name` unless a stable name is required.
- Long-running services normally use `restart: always`. One-shot init/config/migrate services should not be forced into an infinite restart loop.
- Join external `1panel-network` when the app needs to reach 1Panel-managed services or be reachable by 1Panel proxying.
- Host port mappings should use `PANEL_APP_PORT_*` form variables.
- Prefer relative persistent host paths such as `./data/...`, `./logs/...`, and `./conf/...`.
- Add `labels: createdBy: "Apps"` to the main app service.
- Keep top-level metadata and version-level form fields aligned with current official examples.
- `80` and `443` are unsafe default **host** ports on a typical 1Panel server because they normally belong to the reverse proxy. `8080` is **not** globally forbidden; official 1Panel apps use it. Choose defaults based on actual collision risk rather than a hardcoded 8080 ban.

Preferred port variables include:

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

## Reusing 1Panel Database / Redis

Prefer a 1Panel app selector when it simplifies operations **and** upstream supports an external service.

Typical database selector pattern:

```yaml
- child:
    default: ""
    envKey: PANEL_DB_HOST
    required: true
    type: service
  default: mariadb
  envKey: PANEL_DB_TYPE
  labelEn: Database Service
  labelZh: 数据库服务
  required: true
  type: apps
  values:
    - label: MariaDB
      value: mariadb
```

Then bind application settings to values such as:

```text
PANEL_DB_HOST
PANEL_DB_PORT
PANEL_DB_NAME
PANEL_DB_USER
PANEL_DB_USER_PASSWORD
```

Rules:

- Use a dedicated database and user per app/installation.
- Do not let an app silently create/drop/rename a database that 1Panel already manages unless the upstream initialization flow explicitly requires root-level bootstrap and you have tested it.
- Redis may be shared when the application supports it. Use separate logical DB numbers or namespaces when practical.
- For authenticated Redis, construct a complete URI such as `redis://:<password>@<host>:6379/8`.
- Do not force reuse of 1Panel PostgreSQL when the application needs a special image/extension that is not guaranteed to exist (e.g. pgvector). In that case bundle the required PostgreSQL variant and document why.

## Initialization / Migration Rules

- Use one-shot permission/init/migrate services when startup ordering matters.
- Gate dependents using `condition: service_completed_successfully` or health checks where Compose support permits it.
- Make first-run detection verify a meaningful success marker, not merely the existence of a directory created early in a failed bootstrap.
- Never use destructive `--force` behavior to hide an incomplete initialization state.
- On upgrades, run the application's supported migration command before starting workers/web services when required.
- Verify every app-specific CLI option against the **actual target image/version**. Do not hardcode brittle Frappe/ERPNext `bench new-site` flags across major versions.

### Frappe-family apps

Frappe CRM, ERPNext, Insights, and other Frappe apps are multi-process systems. Review at least:

- frontend/nginx entrypoint
- backend
- websocket/socketio
- scheduler
- short/default/long workers as required
- site/configurator/init/migrate jobs
- MariaDB/MySQL requirements
- Redis cache/queue/socketio settings
- persistent `sites` and `logs`

Do not assume `stable`/`latest` images contain the expected app. Verify the image contents or a known-good release before publishing.

## Reverse Proxy / WebSocket Rules

- Distinguish container-internal endpoints from browser-visible endpoints.
- Never configure a browser-visible WebSocket URL to a Docker-only hostname such as `ws://service:8080`.
- For a 1Panel website/reverse proxy, expose only the app HTTP port when possible and proxy WebSocket paths/headers correctly.
- If an app can work without WebSocket, disabling it is safer than publishing a broken internal URL; document how to enable it correctly later.

## Passwords / Secrets

- Use `type: password` for sensitive form values.
- If `random: true` is used, give the field a non-empty safe default prefix and verify the generated value against the target rule.
- Avoid putting default production secrets in Compose files.
- Do not include real `.env` credentials or user secrets in the packaged skill/app ZIP.

## Generator Safety

`scripts/generate-app.sh` is a **draft generator**, not a replacement for app-specific review.

- It defaults to one pinned version directory.
- It preserves a concrete source image tag instead of silently resolving “latest”.
- It refuses multi-service Compose input by default because dropping DB/Redis/workers creates broken packages.
- `--allow-partial-compose` exists only for an explicitly acknowledged draft.
- It refuses unsupported/lossy selected-service fields unless `--allow-lossy` is explicitly provided.
- It does not invent generic volumes or PUID/PGID variables.

## Scripts

Run from the skill directory.

Check dependencies:

```bash
bash ./scripts/generate-app.sh --check-deps
```

Generate a pinned single-service draft:

```bash
bash ./scripts/generate-app.sh \
  --app-key my-app \
  --name MyApp \
  --version 1.2.3 \
  --icon-mode skip \
  ./docker-compose.yml
```

Explicit partial extraction from a multi-service Compose (draft only):

```bash
bash ./scripts/generate-app.sh \
  --service web \
  --allow-partial-compose \
  --app-key my-app \
  --version 1.2.3 \
  ./docker-compose.yml
```

Useful options:

```text
--output <dir>             Output base directory. Default: ./apps
--app-key <key>            Override app directory key
--name <name>              Override display name
--service <name>           Select one service from Compose
--version <tag>            Explicit image tag/version
--resolve-version          Resolve a concrete registry tag only when source is floating
--architectures <csv>      Metadata architectures; default amd64 only
--cross-version-update     Mark crossVersionUpdate true (default false)
--allow-partial-compose    Allow dropping other Compose services for a draft
--allow-lossy              Allow dropping unsupported selected-service keys for a draft
--icon-mode <mode>         auto|required|skip|cache-only
--icon-url <url>           Download icon from a known URL
--force                    Overwrite generated output directory
--dry-run                  Parse and print without writing files
--check-deps               Check local dependencies
```

Validate an app:

```bash
bash ./scripts/validate-app.sh ../../../apps/<app-key>
```

Draft validation (missing icon/README can be warnings):

```bash
bash ./scripts/validate-app.sh --draft ../../../apps/<app-key>
```

Validate skill tooling:

```bash
bash ./tests/run_all.sh
```

## Icon Policy

Icon lookup order:

1. Explicit known URL (`--icon-url`).
2. Local cache under `.cache/icons`.
3. Dashboard Icons.
4. Simple Icons.
5. selfh.st Icons.

Missing icons are acceptable for drafts only. For a final app, require a real logo and validate that `logo.png` is actually an image response.

## Validation Gate

Before considering an app ready:

- YAML parses successfully.
- `additionalProperties.key` matches the directory name.
- Every version directory has `data.yml` and `docker-compose.yml`.
- Primary app images are pinned to the intended version; no accidental `latest`/`stable` in a concrete production version.
- Every `PANEL_APP_PORT_*` reference has a matching form field.
- Unresolved `${VAR}` references are reviewed and either defined by form fields/1Panel or intentionally supplied another way.
- No static host binding to 80/443 unless explicitly justified.
- Persistent data uses intentional relative paths; dangerous host mounts are reviewed.
- Multi-service dependencies, health checks, commands, entrypoints, capabilities, and init jobs have not been silently dropped.
- External 1Panel DB/Redis integration uses the correct host/port/auth variables and the app supports that topology.
- First-run initialization is idempotent and upgrade migration is covered.
- Browser-visible WebSocket/proxy URLs do not point to Docker-only hostnames.
- README states any non-obvious setup, external dependencies, proxy steps, or upgrade caveats.
- Real icon is present for final delivery.
- Run `bash ./tests/run_all.sh` after changing skill scripts.

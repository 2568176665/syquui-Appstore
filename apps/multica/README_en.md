# Multica

Multica brings humans and AI coding agents into a shared workspace for task assignment, execution tracking, discussion, and human review.

- Pinned version: `0.6.2`, using `v0.6.2` for both backend and web images.
- Floating version: `latest`, using the official stable-release image channel.
- Linux amd64 / arm64; includes the frontend, backend, and upstream PostgreSQL 17 / pgvector database.
- Database and uploads persist in `./data/postgres` and `./data/uploads`. The database has no published host port.

## Installation

1. Generate an alphanumeric database password of at least 32 characters, for example with `openssl rand -hex 16`. It is embedded in a database URI: do not use unencoded `@`, `:`, `/`, or other special characters.
2. Generate the JWT secret with `openssl rand -hex 32`. Keep both secrets safe. Changing the form password after database initialization does not change the existing database password.
3. Set the actual browser-facing Web and API URLs without trailing slashes. Use HTTPS domains for remote access instead of the default localhost URLs.
4. Configure a Resend API key and verified sender address. Without email, temporary login codes appear in backend logs as `[DEV] Verification code for ...:`. Configure email for production.
5. Default Web / API host ports are `3300` / `8380`, bound only to `127.0.0.1`. Direct access through the server IP is unavailable.

## 1Panel reverse proxy

Create two HTTPS websites:

- `https://app.example.com` → `http://127.0.0.1:3300`.
- `https://api.example.com` → `http://127.0.0.1:8380`, with WebSocket support.
- On the Web website, also proxy `/ws` to `http://127.0.0.1:8380`, preserving the path and enabling WebSocket support for live browser updates.

Set the form Web URL to `https://app.example.com` and API URL to `https://api.example.com`. Ordinary API requests are forwarded by the frontend over the private Docker network. The browser must never use the internal `backend` hostname. These loopback targets require a proxy on the same host; a containerized proxy needs reachable container addresses. Avoid exposing unprotected ports publicly.

## Agent runtime

The package provides the server. Run the daemon on your own work machine. Install the Multica CLI and your AI coding tools following the [official guide](https://github.com/multica-ai/multica/blob/v0.6.2/SELF_HOSTING.md), then run:

```bash
multica setup self-host --server-url https://api.example.com --app-url https://app.example.com
multica daemon status
```

## Configuration and upgrades

- After initial signup, disable signup or set a comma-separated email allowlist. This does not replace email authentication.
- Production mode is used without a fixed login code. Anonymous deployment telemetry is disabled with `DO_NOT_TRACK=true`.
- For SMTP, OAuth, S3, GitHub App, plugins, and other advanced features, add backend environment settings from the [upstream configuration guide](https://github.com/multica-ai/multica/blob/v0.6.2/SELF_HOSTING_ADVANCED.md).
- The official backend entrypoint runs database migrations before starting the API server.
- Back up the database and uploads before upgrading. Keep frontend and backend versions aligned. Pulling `latest` may introduce database migrations; do not downgrade without a restoration plan. Prefer the pinned version in production.

Project: https://github.com/multica-ai/multica

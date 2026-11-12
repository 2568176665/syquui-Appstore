# FreeLLMAPI

FreeLLMAPI is a locally hosted LLM router that stacks the free tiers of dozens of providers behind a single OpenAI-compatible endpoint. It ranks your chain by speed, capability and reliability, fails over to the next provider on rate limits or errors, and tracks per-key usage so requests stay under every free-tier cap.

Provider keys are encrypted with AES-256-GCM in a local SQLite database, and clients only ever see one unified `freellmapi-...` token. Beyond `/v1` it also serves Anthropic Messages, Gemini and Ollama surfaces, plus a dashboard for managing keys, reordering fallback chains and reading analytics.

## Usage

- After installation, open the dashboard at `http://<server>:<web port>`. The default port is `3001`.
- Sign in with the dashboard admin email and password from the install form. 1Panel generates the password; you can read it on the app's parameter page.
- Add provider API keys on the **Keys** page, then reorder the **Fallback Chain** to taste.
- Copy the unified `freellmapi-...` token from the top of the **Keys** page and point any OpenAI-compatible client at `http://<server>:3001/v1`.
- Data (SQLite database, encryption key file, backups) persists in the version directory's `data/`, so it survives container re-creation.

## Configuration

| Parameter | Default | Description |
| --- | --- | --- |
| `PANEL_APP_PORT_HTTP` | `3001` | Host port for the dashboard and API |
| `ENCRYPTION_KEY` | - | 64-character hex key used to encrypt provider keys at rest |
| `PANEL_APP_ADMIN_EMAIL` | `admin@freellmapi.local` | Dashboard admin email |
| `PANEL_APP_ADMIN_PASSWORD` | random | Dashboard admin password, at least 8 characters |

## Notes

- `ENCRYPTION_KEY` must be a 64-character hex string; generate one with `openssl rand -hex 32`. Do not change it after installing: a different key makes every stored provider key fail to decrypt.
- The admin account is created only on first boot, while no account exists. Changing the email or password in the form afterwards has no effect; edit them inside the dashboard instead.
- The admin password may only contain letters, digits and `.%@!~_-`, because the value is embedded in the container's `FREEAPI_CONFIG_JSON`.
- The server listens on all interfaces and the app is single-user by design, so do not expose it directly to the internet. For HTTPS, put a 1Panel website reverse proxy in front of the port.
- Two version directories are published: pinned `0.16.26` uses a fixed image tag and suits controlled upgrades, while `latest` follows the upstream image and may update when the container is recreated.
- Upgrading the app version works in place as long as `data/` and `ENCRYPTION_KEY` stay the same; database migrations run automatically on container start.
- Upstream's optional Watchtower self-update sidecar needs the Docker socket and is not included here. Upgrade through the 1Panel App Store instead.
- The container maps `host.docker.internal`, so a custom provider can target Ollama, LM Studio or vLLM running on the host (for example `http://host.docker.internal:11434/v1`).

## Disclaimer

Upstream describes this project as intended for personal experimentation and learning, not for production. Free-tier availability, rate limits and terms are set by each provider, and those terms still apply when traffic is proxied through this app.

## Links

- Website: https://freellmapi.co
- Repository: https://github.com/tashfeenahmed/freellmapi
- Install docs: https://github.com/tashfeenahmed/freellmapi/blob/main/docs/en/install/01-install.md
- Docker image: https://github.com/tashfeenahmed/freellmapi/pkgs/container/freellmapi

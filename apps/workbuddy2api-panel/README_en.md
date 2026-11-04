# WorkBuddy2API Panel

An OpenAI-compatible multi-account gateway for personal Tencent WorkBuddy / CodeBuddy accounts, with a web panel for account-pool rotation, circuit breaking and cooldown, session stickiness, scheduled check-ins and growth tasks, plus hot-reloaded configuration.

The default port is `7863`; if you change it during installation, replace the port in these URLs. Open `http://server-address:7863/panel/` to add an account. The API base URL is `http://server-address:7863/v1` (also `/v1/responses` and `/v1/messages`).

On first start the app writes `data/config.json` in the app data directory with a random API key. The panel does not display that key; read `api_key` from `data/config.json` in the app directory on the server. Everything else can be edited in the panel and takes effect immediately.

Use only accounts you are authorized to access. Account credentials are stored in the app data directory. Keep the service private; if exposed publicly, put it behind an HTTPS reverse proxy and restrict access. The project is intended for personal use and does not support public resale or quota redistribution.

The former upstream `linguo2625469/workbuddy2api-panel` stopped maintenance on 2026-10-21, so this app follows the fork that is still maintained.

Project: [GitHub](https://github.com/misakano7545/workbuddy2api-panel)

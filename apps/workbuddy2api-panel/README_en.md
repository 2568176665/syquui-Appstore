# WorkBuddy2API Panel

An OpenAI-compatible gateway for personal Tencent CodeBuddy accounts, with a web panel, OAuth sign-in, and account-pool management.

The default port is `7863`; if you change it during installation, replace the port in these URLs. Open `http://server-address:7863/panel/` to add an account. The API base URL is `http://server-address:7863/v1`. A random API key is generated on first start; view or change it in `/app/data/config.json` inside the container.

Use only accounts you are authorized to access. Account credentials are stored in the app data directory. Keep the service private; if exposed publicly, put it behind an HTTPS reverse proxy and restrict access. The project is intended for personal use and does not support public resale or quota redistribution.

Project: [GitHub](https://github.com/linguo2625469/workbuddy2api-panel)

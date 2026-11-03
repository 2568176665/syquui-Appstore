# WorkBuddy Manager

Web management console for Tencent CodeBuddy account pools, designed to accompany the [workbuddy2api](https://github.com/ithtelab/workbuddy-manager) upstream gateway. This package deploys both the web console and the upstream gateway together out-of-the-box.

## Features

- **Account Management**: QR login via WeChat / QQ, expiration tracking, one-click renewal, connectivity probes, and manual check-ins across multiple account pools.
- **Scheduled Tasks**: Timed check-in, travel, activity, and keep-alive tasks with configurable execution windows.
- **Reverse Proxy Gateway**: OpenAI-compatible `/v1` endpoints with multi-key distribution, independent quotas, expirations, IP and model allowlists.
- **Auditing & Stats**: Records API key, client IP, model, HTTP status, time-to-first-token, and credit cost for every call.
- **Visual Settings**: Multiple upstream instances, inbound CIDR allowlists/blocklists, remote PostgreSQL backups, and five-language UI.

## Deployment Architecture

| Service | Image | Description |
| --- | --- | --- |
| `workbuddy-manager` | `ghcr.io/ithtelab/workbuddy-manager` | Web management console, exposes host web port |
| `workbuddy2api` | `ghcr.io/ithtelab/workbuddy2api` | Upstream gateway, connected over `1panel-network`, no host port exposed |

Upstream files (`config.json`, `auths/`, `data/`) are kept in the `data/upstream/` directory under application data, allowing the web console to read and write account auth files directly.

## First-time Setup

1. During installation, `init.sh` automatically creates `data/upstream/config.json` with a random `api_key` if one does not already exist. Existing configurations are never overwritten.
2. Open `http://<server-ip>:7864` in your browser. Default username is `admin`.
3. The initial administrator password is generated randomly on first run and written to the container log as well as `data/initial-admin-password.txt`:

   ```bash
   docker logs <container-name> 2>&1 | grep -A2 "初始管理员"
   ```

4. Log in and change the password immediately under "Settings -> Manage Users", then add your CodeBuddy accounts under the "Accounts" page.

## Usage

Standard three-step workflow: **Authorize Accounts -> Issue API Keys -> Point Clients to `/v1`**.

- Web Console: `http://<server-ip>:7864`
- Gateway API: `http://<server-ip>:7864/v1` (use the gateway API key created in the console)

## Notes

- The console stores account credentials; **do not expose it directly to the public Internet**. Always place it behind an HTTPS reverse proxy with access control.
- Ensure the `data/` directory is owned by uid `10001` (handled by `init.sh`; for manual runs use `chown -R 10001:10001 ./data`).
- Features like "Update Upstream in UI" and "View Upstream Logs" require mounting `/var/run/docker.sock`. This package leaves it unmounted by default for security; those operations will prompt you to run them on the host instead.
- If the upstream `api_key` in `config.json` is left empty, the upstream gateway endpoints become unauthenticated. Keep a strong random key configured.
- Only manage accounts authorized voluntarily by yourself or family members; bulk registration, account trading, and commercial resale are strictly forbidden.

## Versions

- `2.11.9`: Pinned release version with both manager and upstream images pinned to `2.11.9`.
- `latest`: Tracks the upstream `latest` tag for testing bleeding-edge changes.

Project: [GitHub](https://github.com/ithtelab/workbuddy-manager)

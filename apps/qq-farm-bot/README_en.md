# QQ Farm Bot

QQ Farm Bot is a Node.js-based QQ farm automation tool with multi-account management, automated planting and harvesting, friend interactions, event management, real-time logs, and a web control panel.

## Usage

- After installation, open `http://server-address:port` to access the panel. The default port is `3007`.
- You can select QQ Farm Bot in 1Panel under “Websites → Create Website → One-Click Deployment” (install a new app or select an installed one), then configure the domain and HTTPS. The app's web port defaults to `3007`.
- The initial username and password are both `admin`. Change the administrator password immediately in “Settings → System Settings”. The initial administrator password cannot be configured through environment variables.
- QQ QR-code login requires the external `qq-miniapp-auth` service, which is not bundled with this app. Deploy that service first, then configure its reachable NapCat API address and API signature in the panel before enabling QQ QR-code login.
- Runtime data and logs are persisted in the app `data/` directory. Back up this directory before rebuilding the container.

## Images and versions

The app pulls pre-built images from `ghcr.io/2568176665/qq-farm-bot`; it does not build from source during installation. `20260928` is pinned to commit `864caf335192321c6a6c3737f4801f9b6a2b3a82`. The fork's GitHub Actions workflow builds and publishes `latest` after syncing upstream changes. After the first publish, the repository owner must make the GHCR package public so 1Panel can pull it anonymously.

## Security

The management panel contains accounts, game settings, and runtime data. Do not expose its management port directly to the public Internet. Use a 1Panel reverse proxy, VPN, or access controls instead.

## Disclaimer

The upstream project states that this tool is for learning and research purposes only. Use of this tool may violate game service terms, and users are responsible for any consequences.

## Links

- Repository: https://github.com/liyangpengs/qq-farm-bot
- Upstream version: 20260928

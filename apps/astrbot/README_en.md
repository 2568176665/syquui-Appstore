# AstrBot

A cross-platform chatbot framework that brings LLM capabilities to QQ, WeChat, Telegram, Discord, Slack and other messaging platforms, with a web dashboard for visual configuration, a plugin marketplace, knowledge bases, agent tool calling and session management.

- Project: <https://github.com/AstrBotDevs/AstrBot>
- Documentation: <https://docs.astrbot.app>
- Docker deployment guide: <https://docs.astrbot.app/deploy/astrbot/docker.html>

## Ports

| Port | Purpose |
| --- | --- |
| 6185 | Web dashboard (the "Dashboard Port" field) |
| 6199 | OneBot v11 WebSocket, used when connecting platforms such as a personal QQ account (the "OneBot v11 WebSocket Port" field) |

## First login

Open `http://<server-ip>:6185`, sign in as `astrbot` with the "Dashboard Initial Password" from the install form. AstrBot asks you to change it on first login.

If the initial password from the form did not take effect (for example because an older `cmd_config.json` already exists in the data directory), the random one is printed in the container log:

```bash
docker logs <container> | grep -i password
```

To reset a forgotten password, use the built-in CLI and restart afterwards:

```bash
docker exec -it <container> astrbot password
docker restart <container>
```

> Docker isolates the network, so **the dashboard cannot be reached through `localhost`**. Use the server's real address.

## Connecting a messaging platform

This package deploys AstrBot only, with no messaging platform implementation included. For a personal QQ account, deploy an OneBot v11 implementation such as [NapCat](https://github.com/NapNeko/NapCat-Docker) separately and point it at this container's port 6199. Containers on the same network can reach each other by name, e.g. `ws://<container>:6199/ws`.

## Data and upgrades

- All state lives in `./data` (`/AstrBot/data` in the container): `cmd_config.json`, plugins, knowledge bases, temporary files and databases.
- Upgrading or changing version keeps that directory; deleting it is equivalent to a fresh install.

## Notes

- **The agent sandbox is not included.** Upstream's `compose-with-shipyard.yml` mounts `/var/run/docker.sock` and runs an extra Shipyard container, which is a high-privilege combination this package does not ship. Deploy it from the upstream guide if you need native Python/Shell code execution.
- The container runs with `no-new-privileges`. Plugins and their dependencies are installed inside the container, so it needs outbound network access.
- Upstream's Compose file also mounts `/etc/localtime:/etc/localtime:ro`; this package uses the `TZ` environment variable instead, which has the same effect without a host path.
- On a cloud server, make sure the security group allows 6185 (and 6199 when connecting a platform).

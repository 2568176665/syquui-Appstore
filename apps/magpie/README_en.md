# Magpie

Magpie is a local AI gateway. It collects subscription accounts (Claude Code, Codex, Grok and others) and provider API keys in one place and serves them as OpenAI Chat/Responses, Anthropic Messages and Gemini compatible endpoints, translating between the protocols with streaming, tool calls and reasoning included.

This package runs Magpie in its **browser console mode**, which suits a server or NAS without a desktop. The container finds no agents to wire, so it is a gateway: the agents that use it run elsewhere.

- Project: <https://github.com/yetone/magpie>
- Docker guide: <https://usemagpie.ai/docs/docker>

## Ports

| Port | Purpose |
| --- | --- |
| 3430 | Browser console (the "Console Port" field) |
| 3425 | Gateway for agents and OpenAI/Anthropic/Gemini clients (the "Gateway Port" field) |

## First run

1. Open the console at:

   ```text
   http://<server-ip>:3430/?k=<console-key>
   ```

   The console key is the "Console Key" field of the install form (looks like `magpiewebkey_xxxxxx`). A page opened without `?k=` is turned away with 401, by design: anyone with the link can change Magpie and see its keys.

2. Add providers and API keys on **Providers**. A subscription sign-in opens the vendor's page in your browser, and the vendor then sends that browser back to `localhost`, which is your own computer and not the container, so the page does not load. Copy the whole address from the address bar and paste it into the sign-in's **Callback URL** field.

3. On **Gateway → Gateway keys**, make a gateway key for each machine. Every request from outside the container, the host's own included, must carry an enabled gateway key or gets 401.

4. Point agents on the other machines at the gateway:

   ```bash
   # OpenAI-compatible clients
   export OPENAI_BASE_URL=http://<server-ip>:3425/v1
   export OPENAI_API_KEY=sk-magpie-key-...

   # Anthropic-compatible clients
   export ANTHROPIC_BASE_URL=http://<server-ip>:3425
   export ANTHROPIC_API_KEY=sk-magpie-key-...
   ```

## Data and upgrades

- All state lives in `./data/config` (`/config` in the container): `settings.json`, providers, gateway keys, routing groups, plugins, subscription sign-ins and the model cache.
- `scripts/init.sh` creates that directory and chowns it to uid `65532` on install and on upgrade. If you moved it by hand and the container reports a permission error, run `chown -R 65532:65532 ./data/config` again.
- Changing version or upgrading keeps the data; installing under a different container name starts a separate configuration.

## Notes

- **Do not publish the console port to the internet.** Put it behind a 1Panel reverse proxy with access control, or keep it on a LAN or VPN. Across the network, serve it over HTTPS, either by giving Magpie `MAGPIE_TLS_CERT` / `MAGPIE_TLS_KEY` or by putting a TLS-terminating reverse proxy in front.
- The container only sees Docker's own address, so the "on the network" address shown in the console is not the host's. To make it show the right one, add `MAGPIE_PUBLIC_URL=http://<server-ip>:3425` to the Compose file.
- To restrict which addresses may connect, add `MAGPIE_ALLOW_IPS` (comma-separated IPs or CIDR ranges). Magpie judges the connection's own address and never an `X-Forwarded-For` header, so behind a reverse proxy limit the callers at the proxy instead.
- Claude Code's status line cannot reach another machine's `~/.claude/settings.json`; follow the upstream guide and point it at the gateway's `/v1/magpie/statusline` endpoint instead.

## Versions

- The pinned `0.1.3829` directory uses `ghcr.io/yetone/magpie:0.1.3829` for reproducible deployments.
- The `latest` directory uses `ghcr.io/yetone/magpie:latest`. Magpie releases several times a day; pin a version if you prefer stability.

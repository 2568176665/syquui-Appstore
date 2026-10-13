# Agent2API

Agent2API turns sessions from multiple AI coding clients into an OpenAI-compatible API. Application data is stored in `/data`.

After installation, access the management panel through a 1Panel website reverse proxy pointing to `http://agent2api:3066`. On first visit, register an administrator account, then create an API key on the “Gateway Keys” page. The client API endpoint is `http://server-address:3065/v1` (the port can be changed during installation).

The management panel and API gateway use separate ports. Compose publishes only the API port; the management panel is reachable through the internal `1panel-network`. Do not expose the management panel directly to the public internet.

The upstream project reuses sessions from third-party AI clients. Review the relevant service terms before use. The upstream project states that it is for personal learning only and not for commercial use.

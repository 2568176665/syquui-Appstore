# Agent2API

Agent2API turns sessions from multiple AI coding clients into an OpenAI-compatible API. Application data is stored in `/data`.

After installation, open `http://server-address:3066` to access the management panel. On first visit, register an administrator account, then create an API key on the “Gateway Keys” page. The client API endpoint is `http://server-address:3065/v1`; both ports can be changed during installation.

The management panel and API gateway use separate ports: 3066 and 3065 by default. If these ports are publicly reachable, restrict access to the management panel with a firewall or reverse proxy.

The upstream project reuses sessions from third-party AI clients. Review the relevant service terms before use. The upstream project states that it is for personal learning only and not for commercial use.

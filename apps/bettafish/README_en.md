# BettaFish

BettaFish is a multi-agent public opinion analysis system built from scratch. Insight Agent mines private databases, Media Agent analyses multimodal content, Query Agent searches the web, Report Agent consolidates findings into structured reports, and ForumEngine coordinates the discussion between agents.

## Version and architecture

- Pinned version: `3.0.0`, image `ghcr.io/666ghj/bettafish:v3.0.0`.
- Linux amd64 / arm64.
- Bundled PostgreSQL 15; data persists in `./data/db_data` and no host port is published for it.

## Ports

| Variable | Default | Purpose |
| --- | --- | --- |
| `PANEL_APP_PORT_HTTP` | 5000 | Flask main UI |
| `PANEL_APP_PORT_INSIGHT` | 8501 | Insight Agent (Streamlit) |
| `PANEL_APP_PORT_MEDIA` | 8502 | Media Agent (Streamlit) |
| `PANEL_APP_PORT_QUERY` | 8503 | Query Agent (Streamlit) |

The main UI loads each agent in an iframe using `window.location.hostname` plus ports 8501–8503, so those ports must stay reachable from the browser. If you serve the UI behind a domain, expose 8501–8503 as well or keep using server IP plus port.

## Installation and configuration

1. Installation generates the database password and writes it to `.env` in the application directory (mode 600), pinning `DB_HOST=db`, `DB_PORT=5432` and `DB_DIALECT=postgresql`. Upgrades reuse the existing password; do not delete or edit this file.
2. Database tables are created by the application when the system is first started; no manual initialisation is needed.
3. Agent API keys in the install form may be left empty and filled in later under Configuration in the main UI, which writes them back to `.env`.
4. Every agent uses an OpenAI-compatible API, so each one needs `*_API_KEY`, `*_BASE_URL` and `*_MODEL_NAME`.
5. Web search requires exactly one provider: set `SEARCH_TOOL_TYPE=AnspireAPI` with an Anspire key, or `BochaAPI` with a Bocha key. Tavily is an optional extra.

## Usage

1. Open `http://<server-ip>:5000`.
2. Complete the model and search keys under Configuration, then click "Save and start system".
3. Once Insight / Media / Query agents are running, submit a query; reports are written to `./data/final_reports`.

## Upgrading

Back up `./data` and `.env` before updating. `crossVersionUpdate` is `false`; verify upstream database changes manually when moving across versions.

Project: https://github.com/666ghj/BettaFish

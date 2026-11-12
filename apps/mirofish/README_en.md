# MiroFish

A swarm intelligence forecasting engine. It turns a document, news item or event description into an ontology and a cast of agent profiles, runs hundreds of agents through a simulated social network where each behaves in character, watches how a topic spreads, and produces a forecast report with its evidence.

- Project: <https://github.com/666ghj/MiroFish>
- Upstream README: <https://github.com/666ghj/MiroFish/blob/main/README.md>

## Prepare before installing

The backend validates its configuration at startup and exits when either item is missing, so the container will not start without them:

| Setting | Notes |
| --- | --- |
| LLM API key | A key for any OpenAI-compatible endpoint. The defaults point at Alibaba Bailian with `qwen-plus`; change them for any other compatible service |
| Zep Cloud key | The memory graph uses [Zep Cloud](https://app.getzep.com/); the free monthly quota is enough for simple use. MiroFish only supports Zep Cloud, not a self-hosted Zep (`ZEP_API_URL` is rejected as a configuration error) |

## Access

Open `http://<server-ip>:3000` after installing.

The Flask backend listens on port 5001 inside the container and the frontend dev server proxies `/api` to it, so **only port 3000 needs publishing**. To call the API directly, use `http://<server-ip>:3000/api/...`; exposing 5001 is unnecessary.

## Data

- Uploaded documents and simulation output live in `./data/uploads` (`/app/backend/uploads` in the container), including the simulation data under `uploads/simulations`.
- That directory is the only persistent state and survives upgrades and version changes.

## Notes

- **It is token-hungry.** One simulation makes many rounds of multi-agent model calls. Start with a run of fewer than 40 rounds to gauge the cost before scaling up.
- The image starts both processes with `npm run dev`, which is how upstream ships it: it is not a production static site. The first start takes about a minute, and the health check's `start_period` is set to 90 seconds.
- For the optional "boost" model, add `LLM_BOOST_API_KEY`, `LLM_BOOST_BASE_URL` and `LLM_BOOST_MODEL_NAME` to the Compose file. **Do not add them unless you use them**: upstream expects all three together or none at all.
- Uploads are capped at 50 MB and accept `pdf`, `md`, `txt` and `markdown`.

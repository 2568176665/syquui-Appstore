# Auto Ontology

NVIDIA's open-source semantic ontology layer. It builds terms, relationships and SQL attributes from enterprise metadata, then exposes that context to agents over a web UI, REST API and MCP so natural-language questions become validated SQL with provenance.

## Deployment notes

1. An NVIDIA API Key (`nvapi-...`, from https://build.nvidia.com) is required; enter it in **NVIDIA API Key**. Endpoints and model names for all four model roles (reasoning, non-reasoning, embedding, rerank) are derived from the key prefix (`nvapi-` / `sk-`). To use a self-hosted NIM or another OpenAI-compatible endpoint, add `DEFAULT_MODELS_ENDPOINT`, `DEFAULT_MODELS_MODEL`, `EMBED_ENDPOINT`, `EMBED_MODEL`, `RERANK_ENDPOINT` and `RERANK_MODEL` to the deployment yourself (see upstream `.env.example`); the embedding model must match between ingestion and query.
2. Images come from NVIDIA NGC (`nvcr.io`), so the server must be able to reach that registry. The images are public and need no login to pull.
3. The bundle ships its own `pgvector/pgvector:pg17` PostgreSQL: pgvector is required for ontology embedding search, so 1Panel's PostgreSQL is not reused.
4. **Application URL** (`APP_URL`) must exactly match the URL you browse to, including scheme, port or domain, otherwise sign-in fails with `Invalid origin`. When you front it with a 1Panel website reverse proxy over HTTPS, enter that HTTPS URL; the proxy target is the app container name plus `:3000`, where the container name looks like `1Panel-auto-ontology-abcd`.
5. On first install two database migrations run first (Alembic owns `public`, Prisma owns `frontend`), then the backend, ingestion service and frontend start.
6. Sign in with the admin email and password entered during installation. Self-service sign-up is disabled.

## First steps

1. Open the app and sign in as the admin.
2. Add sources under `Settings → Connections` (PostgreSQL, MySQL, ClickHouse, Snowflake, Databricks, Trino and others).
3. Turn on `Settings → Semantic Compilation`; once compilation finishes, ask questions in `Chat` and each answer comes back with its SQL and the steps that produced it.

## Components and ports

| Component | Container port | Published |
| --- | --- | --- |
| Frontend (Next.js) | 3000 | Yes, `PANEL_APP_PORT_HTTP` |
| Backend (FastAPI) | 3001 | No |
| Ingestion service | 3002 | No |
| PostgreSQL + pgvector | 5432 | No |

The backend trusts the user identity the frontend forwards, and the ingestion service's write/delete/compile endpoints have no authentication of their own, so those two ports stay on the container network. Do not publish them.

## Data and upgrades

- `data/postgres`: PostgreSQL data (catalog, ontology, conversations).
- `data/secrets.env`: generated at install time; holds `POSTGRES_PASSWORD` (the bundled database password) and `AUTH_SECRET` (session signing key). The database password is generated rather than asked for because the application builds `postgresql://user:password@host` without URL-encoding, so characters such as `@ : / #` in it break every connection immediately.
- `scripts/upgrade.sh` keeps both values across upgrades. If the file is lost while `data/postgres` still exists, `init.sh` refuses to continue: recover the original values, or delete `data/postgres` and start over.
- Upgrades re-run the database migrations. If a migration fails the app does not start; check the `*-migrate` container logs in 1Panel.

## Notes

- The upstream development pgAdmin and the optional MCP server (`nvcr.io/nvidia/auto-ontology-mcp`) are not included. Deploy MCP separately and point `AUTO_ONTOLOGY_MCP_PUBLIC_URL` at its public URL.
- Upstream publishes only version tags on NGC (such as `1.2.0`), never `latest`, so the `latest` directory pins the newest published release.
- 4 GB of memory or more is recommended.

## Links

- Source: https://github.com/NVIDIA/auto-ontology
- Docs: https://github.com/NVIDIA/auto-ontology/blob/main/README.md
- Kubernetes deployment: https://github.com/NVIDIA/auto-ontology/blob/main/DEPLOYMENT.md

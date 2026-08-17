# Chatwoot

Chatwoot is a self-hosted open-source omnichannel customer support platform.

## 1Panel Deployment

1. Install Redis in 1Panel first.
2. Select that Redis service during Chatwoot installation and enter its password (leave blank if Redis has no password).
3. This package runs its own `pgvector/pgvector:pg16` PostgreSQL because Chatwoot requires pgvector; a separate 1Panel PostgreSQL service is not required.
4. First boot automatically runs `db:chatwoot_prepare` for database initialization and migrations.
5. Set `FRONTEND_URL` to the final public URL and use a 1Panel reverse proxy with HTTPS.
6. Persistent data is stored under `data/postgres` and `data/storage`.

## Links

- Website: https://www.chatwoot.com
- Docs: https://www.chatwoot.com/docs
- Source: https://github.com/chatwoot/chatwoot

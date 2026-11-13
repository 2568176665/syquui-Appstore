# Auto Ontology

NVIDIA 开源的语义本体层。它从企业元数据自动构建术语、关系与 SQL 属性，并通过 Web UI、REST API 与 MCP 把这份上下文提供给智能体，使自然语言问题转化为经过校验的 SQL 并附带溯源。

## 部署说明

1. 需要 NVIDIA API Key（`nvapi-` 开头，在 https://build.nvidia.com 获取），安装时填入「NVIDIA API Key」。推理、非推理、向量、重排四个模型角色的地址与模型名会按 Key 前缀（`nvapi-` / `sk-`）自动推导；改用自建 NIM 或其他 OpenAI 兼容服务时，需在应用编排中补充 `DEFAULT_MODELS_ENDPOINT`、`DEFAULT_MODELS_MODEL`、`EMBED_ENDPOINT`、`EMBED_MODEL`、`RERANK_ENDPOINT`、`RERANK_MODEL` 等变量（见上游 `.env.example`），其中向量模型在摄取与查询两端必须一致。
2. 镜像来自 NVIDIA NGC（`nvcr.io`），服务器需能访问该仓库。镜像为公开镜像，无需登录即可拉取。
3. 使用包内独立的 `pgvector/pgvector:pg17` PostgreSQL：pgvector 是本体向量检索的硬依赖，因此不复用 1Panel PostgreSQL。
4. 「应用访问地址」（`APP_URL`）必须与浏览器实际访问的地址完全一致（含协议、端口或域名），否则登录会失败。通过 1Panel 网站反向代理并启用 HTTPS 时，请填写该 HTTPS 地址，反代目标为 `http://<容器名>:3000`。
5. 首次安装会先执行两段数据库迁移（Alembic 负责 `public`，Prisma 负责 `frontend`），完成后才启动后端、摄取服务与前端。
6. 登录账号即安装时填写的管理员邮箱与密码。应用不支持自助注册。

## 首次使用

1. 打开应用并用管理员账号登录。
2. 在 `Settings → Connections` 添加数据源，支持 PostgreSQL、MySQL、ClickHouse、Snowflake、Databricks、Trino 等。
3. 在 `Settings → Semantic Compilation` 开启语义编译，编译完成后即可在 `Chat` 中用自然语言提问，回答会附带 SQL 与推导步骤。

## 组件与端口

| 组件 | 容器内端口 | 对外 |
| --- | --- | --- |
| 前端（Next.js） | 3000 | 是，`PANEL_APP_PORT_HTTP` |
| 后端（FastAPI） | 3001 | 否 |
| 摄取服务 | 3002 | 否 |
| PostgreSQL + pgvector | 5432 | 否 |

后端信任前端转发的用户身份，摄取服务的写入/删除/编译接口没有独立鉴权，因此这两个端口只在容器内网暴露，请勿自行发布。

## 数据与升级

- `data/postgres`：PostgreSQL 数据（catalog、本体、会话）。
- `data/secrets.env`：安装时自动生成的 `AUTH_SECRET`（会话签名密钥）。升级时由 `scripts/upgrade.sh` 保留；删除该文件会使所有用户重新登录。
- 升级会重新执行数据库迁移，迁移失败时应用不会启动，可在 1Panel 容器日志中查看 `*-migrate` 容器的输出。

## 说明

- 未包含上游开发用的 pgAdmin 与可选 MCP 服务（`nvcr.io/nvidia/auto-ontology-mcp`）。MCP 需单独部署，并通过 `AUTO_ONTOLOGY_MCP_PUBLIC_URL` 指定其公开地址。
- 上游在 NGC 只发布版本号标签（如 `1.2.0`），没有 `latest` 标签，因此 `latest` 目录固定指向当前最新发布版本。
- 建议内存不低于 4 GB。

## 链接

- 源码：https://github.com/NVIDIA/auto-ontology
- 文档：https://github.com/NVIDIA/auto-ontology/blob/main/README.md
- Kubernetes 部署：https://github.com/NVIDIA/auto-ontology/blob/main/DEPLOYMENT.md

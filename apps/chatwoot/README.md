# Chatwoot

Chatwoot 是一个自托管、开源的全渠道客户支持平台。

## 1Panel 部署说明

1. 先在 1Panel 安装 Redis。
2. 安装 Chatwoot 时选择该 Redis，并填写 Redis 密码（如果 Redis 未设置密码可留空）。
3. Chatwoot 使用包内独立的 `pgvector/pgvector:pg16` PostgreSQL，以满足 Chatwoot 的 pgvector 依赖；无需另外选择 1Panel PostgreSQL。
4. 首次启动会自动执行 `db:chatwoot_prepare` 完成数据库初始化/迁移。
5. `FRONTEND_URL` 请填写最终访问地址，建议通过 1Panel 网站反向代理配置 HTTPS。
6. 持久化数据位于 `data/postgres` 与 `data/storage`。

## 链接

- 官网：https://www.chatwoot.com
- 文档：https://www.chatwoot.com/docs
- 源码：https://github.com/chatwoot/chatwoot

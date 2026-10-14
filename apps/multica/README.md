# Multica

Multica 将团队成员与 AI 编程代理放在同一工作空间，支持任务分配、执行进度、协作讨论和人工审核。

- 固定版本：`0.6.2`，前后端镜像均使用 `v0.6.2`。
- 浮动版本：`latest`，前后端镜像均使用官方稳定发布通道 `latest`。
- 支持 Linux amd64 / arm64，包含前端、后端和上游使用的 PostgreSQL 17 / pgvector。
- 数据库与上传文件分别保存在 `./data/postgres`、`./data/uploads`，数据库不发布宿主机端口。

## 安装与访问

1. 数据库密码使用至少 32 位随机字母数字，例如执行 `openssl rand -hex 16`。密码写入数据库 URI，不能包含未编码的 `@`、`:`、`/` 等特殊字符。
2. JWT 密钥使用 `openssl rand -hex 32` 生成。数据库密码和 JWT 密钥必须妥善保存；数据库初始化后修改表单密码不会自动修改数据库中的密码。
3. 填写浏览器实际访问的 Web 地址与 API 地址，不含末尾斜杠。远程访问使用自己的 HTTPS 域名，不要保留 `localhost`。
4. 配置 Resend API 密钥和已验证的发件邮箱。未配置邮件时，可从后端容器日志中的 `[DEV] Verification code for ...:` 取得临时登录验证码；正式部署应配置邮件。
5. 默认 Web / API 宿主机端口为 `3300` / `8380`，仅绑定 `127.0.0.1`，通过服务器 IP 直接访问端口不可用。

## 1Panel 反向代理

建立两个 HTTPS 网站，例如：

- `https://app.example.com` → `http://127.0.0.1:3300`。
- `https://api.example.com` → `http://127.0.0.1:8380`，启用 WebSocket 支持。
- Web 网站额外将 `/ws` 路径代理到 `http://127.0.0.1:8380`，保留 `/ws` 路径并启用 WebSocket 支持，确保浏览器实时更新可用。

安装表单的 Web 地址填写 `https://app.example.com`，API 地址填写 `https://api.example.com`。前端通过私有 Docker 网络转发普通 API 请求，浏览器不访问 `backend` 这个内部主机名。以上本机地址要求反向代理运行在同一宿主机；容器化代理应使用可达的容器地址，并避免直接向公网发布未受保护的端口。

## AI 执行端

应用包提供服务器，执行任务的 daemon 在自己的工作机器上运行。按[官方自托管指南](https://github.com/multica-ai/multica/blob/v0.6.2/SELF_HOSTING.md)安装 Multica CLI 和所需 AI 编程工具，然后执行：

```bash
multica setup self-host --server-url https://api.example.com --app-url https://app.example.com
multica daemon status
```

## 配置与升级

- 首次注册后可关闭“允许注册”，或设置逗号分隔的邮箱白名单；这不代替邮件登录验证。
- 默认使用生产模式，不配置固定登录验证码，并关闭匿名部署遥测（`DO_NOT_TRACK=true`）。
- SMTP、OAuth、S3、GitHub App、插件等高级功能，可按[上游配置文档](https://github.com/multica-ai/multica/blob/v0.6.2/SELF_HOSTING_ADVANCED.md)在后端 Compose 的 `environment` 中添加设置。
- 后端官方入口脚本在启动前自动执行数据库迁移，无需另建初始化服务。
- 更新前备份数据库及上传文件，保持前后端版本一致。`latest` 拉取后可能引入新的数据库迁移，不应直接降级；生产环境优先使用固定版本。

项目：https://github.com/multica-ai/multica

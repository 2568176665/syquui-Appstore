# FreeLLMAPI

FreeLLMAPI 是一个本地运行的大模型路由器：它把数十家提供商的免费额度聚合到同一个 OpenAI 兼容接口后面，按速度、能力和可靠性为每个请求挑选模型，遇到限流或故障自动切换到下一个提供商，并按密钥统计用量以守住各家的免费配额。

提供商密钥使用 AES-256-GCM 加密后保存在本地 SQLite 中，客户端只需要一个统一的 `freellmapi-...` 令牌。除 `/v1` 之外，它还提供 Anthropic Messages、Gemini 与 Ollama 兼容接口，以及一个可管理密钥、调整回退链、查看分析的控制台。

## 使用说明

- 安装完成后通过 `http://服务器地址:Web 端口` 打开控制台，默认端口为 `3001`。
- 登录账号为安装表单中的「控制台管理员邮箱」和「控制台管理员密码」。密码由 1Panel 随机生成，可在应用的参数页面查看。
- 登录后在 **Keys** 页添加各提供商的 API Key，在 **Fallback Chain** 页调整模型回退顺序。
- 在 **Keys** 页顶部获取统一令牌 `freellmapi-...`，然后让任意 OpenAI 兼容客户端把 Base URL 指向 `http://服务器地址:3001/v1`。
- 数据（SQLite 数据库、加密密钥文件、备份）持久化在应用版本目录下的 `data/` 中，容器重建后不会丢失。

## 配置参数

| 参数 | 默认值 | 说明 |
| --- | --- | --- |
| `PANEL_APP_PORT_HTTP` | `3001` | 控制台与 API 的宿主机端口 |
| `ENCRYPTION_KEY` | - | 64 位十六进制密钥，用于加密存储提供商密钥 |
| `PANEL_APP_ADMIN_EMAIL` | `admin@freellmapi.local` | 控制台管理员邮箱 |
| `PANEL_APP_ADMIN_PASSWORD` | 随机生成 | 控制台管理员密码，至少 8 位 |

## 注意事项

- `ENCRYPTION_KEY` 必须是 64 位十六进制字符串，可用 `openssl rand -hex 32` 生成。安装后请勿修改：更换密钥会让已保存的提供商密钥全部无法解密。
- 管理员账号只在首次启动、用户表为空时创建。之后再修改表单中的邮箱或密码不会生效，需在控制台内修改。
- 管理员密码只能使用字母、数字和 `.%@!~_-`，因为该值会被写入容器的 `FREEAPI_CONFIG_JSON`。
- 容器内服务监听所有网卡，应用本身是单用户设计，不建议直接暴露到公网。需要 HTTPS 访问时，请使用 1Panel 网站的「反向代理」功能指向该端口。
- 升级应用版本时，`data/` 目录与 `ENCRYPTION_KEY` 保持不变即可平滑升级，数据库迁移在容器启动时自动执行。
- 上游提供可选的 Watchtower 自更新组件，需要挂载 Docker socket，本应用包未包含；升级请通过 1Panel 应用商店完成。
- 容器已加入 `host.docker.internal` 映射，自定义提供商可以指向宿主机上运行的 Ollama、LM Studio、vLLM 等服务（例如 `http://host.docker.internal:11434/v1`）。

## 免责声明

上游明确该项目面向个人实验与学习，不适合用于生产环境。免费额度的可用性、速率与条款由各提供商决定，使用时应遵守对应提供商的服务条款。

## 官方资源

- 官网：https://freellmapi.co
- 项目仓库：https://github.com/tashfeenahmed/freellmapi
- 安装文档：https://github.com/tashfeenahmed/freellmapi/blob/main/docs/en/install/01-install.md
- Docker 镜像：https://github.com/tashfeenahmed/freellmapi/pkgs/container/freellmapi

# Magpie

Magpie 是一个本地 AI 网关：把订阅账号（Claude Code、Codex、Grok 等）与各家 API 密钥收拢到一处，对外提供 OpenAI Chat/Responses、Anthropic Messages 与 Gemini 兼容接口，并在其间完成协议转换、流式输出、工具调用与思考内容转发。

本应用以容器方式运行 Magpie 的**浏览器控制台模式**，适合部署在没有桌面的服务器或 NAS 上：容器本身没有可接管的本地 Agent，它只作为网关，供其它机器上的 Agent 调用。

- 项目主页：<https://github.com/yetone/magpie>
- Docker 说明：<https://usemagpie.ai/docs/docker>

## 端口

| 端口 | 用途 |
| --- | --- |
| 3430 | 浏览器控制台（本应用默认的「控制台端口」） |
| 3425 | 网关，Agent 与 OpenAI/Anthropic/Gemini 客户端调用（本应用默认的「网关端口」） |

## 首次使用

1. 安装完成后，用下面的地址打开控制台：

   ```text
   http://<服务器 IP>:3430/?k=<控制台密钥>
   ```

   控制台密钥就是安装时表单里的「控制台密钥」（形如 `magpiewebkey_xxxxxx`）。地址里不带 `?k=` 会被拒绝并返回 401，这是 Magpie 的设计：拿到链接的人就能修改配置并查看密钥。

2. 在 **Providers** 页添加提供商与 API 密钥。订阅类登录（ChatGPT、Claude 等）会把浏览器跳回 `localhost`，而那是你自己的电脑而不是容器，页面打不开；把地址栏里的完整回调地址复制到登录框的 **Callback URL** 里即可。

3. 在 **Gateway → Gateway keys** 为每台机器签发一个网关密钥。容器之外的任何请求（包括宿主机自己）都必须携带一个启用的网关密钥，否则返回 401。

4. 在其它机器上把 Agent 指向网关：

   ```bash
   # OpenAI 兼容客户端
   export OPENAI_BASE_URL=http://<服务器 IP>:3425/v1
   export OPENAI_API_KEY=sk-magpie-key-...

   # Anthropic 兼容客户端
   export ANTHROPIC_BASE_URL=http://<服务器 IP>:3425
   export ANTHROPIC_API_KEY=sk-magpie-key-...
   ```

## 数据与升级

- 全部状态保存在 `./data/config`（容器内 `/config`）：`settings.json`、提供商、网关密钥、路由组、插件、订阅登录态与模型缓存。
- 该目录在安装与升级时由 `scripts/init.sh` 创建并 chown 给 uid `65532`。若你手工搬移过目录导致容器报权限错误，重新执行一次 `chown -R 65532:65532 ./data/config` 即可。
- 更换版本或升级不会丢失数据；换容器名则会新建一套配置，请注意。

## 注意

- **控制台端口不要直接暴露到公网。** 推荐通过 1Panel 网站反向代理并叠加访问认证，或者只在内网/VPN 中开放。跨网络使用时请务必启用 HTTPS：既可以给 Magpie 配置 `MAGPIE_TLS_CERT` / `MAGPIE_TLS_KEY`，也可以在前面放一个带 TLS 的反向代理。
- 容器只看到 Docker 内网地址，控制台里显示的「网络地址」因此不是宿主机地址。如果希望它显示正确，可以在 Compose 里追加 `MAGPIE_PUBLIC_URL=http://<服务器 IP>:3425`。
- 需要限制来源 IP 时，追加 `MAGPIE_ALLOW_IPS`（逗号分隔的 IP 或 CIDR）。Magpie 判断的是连接本身的地址，不读 `X-Forwarded-For`；放在反向代理后面时，请改为在代理层限制来源。
- 若要让宿主机上的 Claude Code 使用 Magpie 的状态栏，容器内没有宿主机的 `~/.claude/settings.json`，需按官方文档改为调用网关的 `/v1/magpie/statusline` 接口。

## 版本

- 固定版本目录 `0.1.3829` 使用 `ghcr.io/yetone/magpie:0.1.3829`，适合需要可复现部署的场景。
- `latest` 目录使用 `ghcr.io/yetone/magpie:latest`，跟随上游最新发布。Magpie 发布频率很高，追求稳定可考虑固定版本。

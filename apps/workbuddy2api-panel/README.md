# WorkBuddy2API Panel

将腾讯 WorkBuddy / CodeBuddy 账号接入 OpenAI 兼容 API 的多账号网关，附带 Web 管理面板：账号池轮转与熔断冷却、会话粘性、定时签到与成长任务、配置热更新。

默认端口为 `7863`；安装时若修改端口，请将下方地址中的端口替换为所选值。访问 `http://服务器地址:7863/panel/` 添加账号，API 地址为 `http://服务器地址:7863/v1`（同时支持 `/v1/responses` 与 `/v1/messages`）。

首次启动会在应用数据目录生成 `data/config.json` 并写入随机 API 密钥，面板不会显示该密钥；请在服务器上的应用目录 `data/config.json` 中查看 `api_key`，其余配置可在面板中修改并即时生效。

仅使用本人授权账号。账号凭据保存在应用数据目录中；请勿将服务直接暴露到公网，公网使用时应通过 HTTPS 反向代理并限制访问。本项目作者声明仅供个人自用，不支持公开售卖或转售额度。

上游 `linguo2625469/workbuddy2api-panel` 已于 2026-10-21 停止维护，本应用改用仍在维护的延续分支。

项目：[GitHub](https://github.com/misakano7545/workbuddy2api-panel)

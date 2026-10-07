# WorkBuddy2API Panel

将腾讯 CodeBuddy 账号接入 OpenAI 兼容 API，并提供 Web 管理面板、OAuth 登录和多账号管理。

默认端口为 `7863`；安装时若修改端口，请将下方地址中的端口替换为所选值。访问 `http://服务器地址:7863/panel/` 添加账号，API 地址为 `http://服务器地址:7863/v1`。首次启动会生成随机 API 密钥，可在容器的 `/app/data/config.json` 中查看和修改。

仅使用本人授权账号。账号凭据保存在应用数据目录中；请勿将服务直接暴露到公网，公网使用时应通过 HTTPS 反向代理并限制访问。本项目作者声明仅供个人自用，不支持公开售卖或转售额度。

项目：[GitHub](https://github.com/linguo2625469/workbuddy2api-panel)

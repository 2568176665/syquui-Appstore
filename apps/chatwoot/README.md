# Chatwoot

Chatwoot 是一个自托管、开源的全渠道客户支持平台，提供实时聊天、多平台收件箱、工单管理、自动化流程与团队协作等功能。

## 主要特性

- 💬 实时在线聊天与网站挂件。
- 📥 统一的跨渠道收件箱（邮件、微信、WhatsApp、Facebook、Telegram 等）。
- 🎫 工单管理与多级指派。
- 🤖 自动化流程、机器人对话与智能分配。
- 🏷️ 对话标签、私密备注与团队协作。
- 📊 客服绩效与对话分析。
- 🔐 精细的角色与权限控制。
- 🌐 多语言支持。

## 官网与文档

- 官网：https://www.chatwoot.com
- 文档：https://www.chatwoot.com/docs
- 源码：https://github.com/chatwoot/chatwoot

## 1Panel 部署说明

1. 在 1Panel 应用商店搜索 Chatwoot 并安装。
2. 填写密钥、数据库密码、Redis 密码、数据库名称以及前台访问地址。
3. 安装完成后，访问 `http://服务器IP:端口` 进行初始化设置。
4. 数据默认持久化在 `data` 目录下。

> 提示：请通过 `FRONTEND_URL` 填写的地址访问（首次启动需注册企业账号）。建议在反向代理中开启 HTTPS 并设置 `FORCE_SSL`。

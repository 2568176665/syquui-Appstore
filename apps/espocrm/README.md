# EspoCRM

EspoCRM 是一个自托管、开源的企业级 CRM 系统，支持联系人管理、销售管道、邮件集成、自动化流程、工作流等功能。

## 主要特性

- 👤 客户、联系人、线索、商机全流程管理。
- 📈 可视化销售管道与自定义报表。
- ✉️ 邮件收发、邮件模板与邮件自动化。
- ⚙️ 可视化业务流程与工作流设计器。
- 🔑 精细的角色与权限控制。
- 🌐 多语言支持与多语言界面。
- 🧩 丰富的扩展市场与开放 API。

## 官网与文档

- 官网：https://www.espocrm.com
- 文档：https://docs.espocrm.com
- 源码：https://github.com/espocrm/espocrm

## 1Panel 部署说明

1. 在 1Panel 应用商店搜索 EspoCRM 并安装。
2. 填写数据库名称、数据库用户/密码、管理员账号/密码以及站点访问地址。
3. 安装完成后，访问 `http://服务器IP:端口` 进行登录使用。
4. 数据默认持久化在 `data`、`custom`、`client-custom`、`db-data` 目录下。

> 注：实时 WebSocket 推送默认通过容器内部网络工作；如需通过反向代理对外提供 WebSocket，请额外配置代理转发。

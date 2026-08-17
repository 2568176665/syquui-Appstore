# Frappe CRM

Frappe CRM 是一个开源的 CRM 系统，基于 Frappe 框架构建，专注于简洁、快速的客户关系管理与销售流程，并可持续扩展为完整的 ERP 生态。

## 主要特性

- 👤 联系人、线索、客户与商机管理。
- 🎯 可视化的销售管道（Pipeline）看板。
- ✍️ 支持 Markdown 备注与团队协作。
- 🔔 自动化通知与跟进提醒。
- 📊 销售分析与数据看板。
- 🔌 基于 Frappe 框架，可无缝扩展 ERPNext 等应用。

## 官网与文档

- 官网：https://frappe.io/crm
- 文档：https://docs.frappe.io/crm
- 源码：https://github.com/frappe/crm

## 1Panel 部署说明

1. 在 1Panel 应用商店搜索 Frappe CRM 并安装。
2. 选择已安装的 MariaDB 数据库服务和 Redis 服务，填写数据库 Root 密码、站点域名和管理员密码。
3. 首次启动会自动初始化站点并安装 CRM 应用，请耐心等待。
4. 安装完成后，将你的访问域名解析到服务器，并使用该域名访问 `http://站点域名:端口`。
5. 默认管理员账号为 `Administrator`，密码为安装时填写的管理员密码。
6. 数据默认持久化在 `sites` 目录下。

> 提示：需要先在 1Panel「数据库」中安装 MariaDB 与 Redis 服务，安装 Frappe CRM 时下拉选择，并填写该 MariaDB 的 root 密码（用于创建站点数据库）。Frappe 根据站点域名路由访问，请使用你填写的站点域名（而非服务器 IP）访问；如需反向代理，请将 `FRAPPE_SITE_NAME` 对应的域名转发到本服务端口。

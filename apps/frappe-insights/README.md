# Frappe Insights

Frappe Insights 是一个开源的商业智能与数据分析平台，帮助团队连接数据源、编写 SQL 查询、创建可视化图表和构建交互式仪表盘。

## 主要特性

- 📊 交互式 BI 仪表盘与数据可视化。
- 🔎 支持 SQL 查询和数据探索。
- 📈 多种图表、指标卡和筛选器。
- 🧩 与 Frappe Framework 及 ERPNext 生态集成。
- 👥 支持团队协作和权限管理。
- ⚙️ 基于 Frappe 的可扩展应用架构。

## 官网与文档

- 官网：https://frappe.io/insights
- 文档：https://docs.frappe.io/insights
- 源码：https://github.com/frappe/insights

## 1Panel 部署说明

1. 在 1Panel「数据库」中先安装 MariaDB 和 Redis 服务。
2. 在 1Panel 应用商店搜索 Frappe Insights 并安装。
3. 在安装表单中选择已安装的 MariaDB 和 Redis 服务，填写 MariaDB Root 密码、站点域名和管理员密码。
4. 首次启动会自动创建 Frappe 站点、安装 Insights 并初始化配置，请耐心等待。
5. 将站点域名解析到服务器，然后使用 `http://站点域名:端口` 访问。
6. 默认管理员账号为 `Administrator`，密码为安装时填写的管理员密码。
7. 数据持久化在版本目录下的 `data/sites` 和 `data/logs`。

> 重要：Frappe 根据请求的 Host 域名进行站点路由，请使用填写的站点域名访问，不要直接使用服务器 IP。配置反向代理时，请保留正确的 Host 请求头并转发到应用端口。

> Frappe Insights 官方部署要求启用 Server Scripts，应用初始化时会自动完成该配置。

> Redis 逻辑库：默认使用 10/11，如果同一 Redis 中已有其他应用占用这些 DB，请在安装时改成未使用的编号。

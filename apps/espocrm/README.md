# EspoCRM

EspoCRM 是一个自托管、开源的企业级 CRM。

## 1Panel 部署说明

1. 先在 1Panel 安装 MySQL 或 MariaDB。
2. 安装 EspoCRM 时从下拉框选择数据库服务，1Panel 会向应用提供数据库主机/端口，并创建所填写的数据库与用户。
3. WebSocket 默认关闭，基础 CRM 功能可直接使用。
4. 如需实时 WebSocket：将“启用 WebSocket”改为 Enable，设置 WebSocket 端口，并把“公网 WebSocket 地址”填写为浏览器可以访问的地址，例如 `wss://crm.example.com/ws` 或 `ws://server-ip:8005`。使用 `wss://` 时需要在 1Panel 反向代理中把对应路径转发到 WebSocket 端口。
5. 持久化数据位于 `data`、`custom`、`client-custom`。

## 链接

- 官网：https://www.espocrm.com
- 文档：https://docs.espocrm.com
- 源码：https://github.com/espocrm/espocrm

# S-UI

S-UI 是一个基于 SagerNet/Sing-Box 的多协议代理管理面板，支持入站管理、订阅服务、流量统计、路由配置和多语言界面。

## 使用说明

- 管理面板： http://服务器地址:面板端口/app/
- 订阅服务： http://服务器地址:订阅端口/sub/
- 默认用户名/密码： admin / admin
- 持久化数据： ./data/db
- 证书目录： ./data/cert
- 80 和 443 端口用于常见的代理入站，实际使用前请在 S-UI 中配置对应入站。

首次登录后请立即修改默认密码。若面板或入站端口与 1Panel 现有服务冲突，请修改安装表单中的端口，并同步调整 S-UI 的入站配置。

官方仓库声明该项目仅用于个人学习和交流，不建议用于生产环境。请遵守部署所在地的法律法规和服务商政策。

## 相关链接

- GitHub 项目：https://github.com/alireza0/s-ui
- Docker Compose 配置：https://github.com/alireza0/s-ui/blob/main/docker-compose.yml
- API 文档：https://github.com/alireza0/s-ui/wiki

# AstrBot

跨平台的聊天机器人框架：把大模型接入 QQ、微信、Telegram、Discord、Slack 等消息平台，提供可视化配置的网页管理面板、插件市场、知识库、Agent 工具调用与会话管理。

- 项目主页：<https://github.com/AstrBotDevs/AstrBot>
- 官方文档：<https://docs.astrbot.app>
- Docker 部署文档：<https://docs.astrbot.app/deploy/astrbot/docker.html>

## 端口

| 端口 | 用途 |
| --- | --- |
| 6185 | 网页管理面板（本应用默认的「管理面板端口」） |
| 6199 | OneBot v11 WebSocket，接入 QQ 个人号等平台时使用（本应用默认的「OneBot v11 WebSocket 端口」） |

## 首次登录

打开 `http://<服务器 IP>:6185`，用户名 `astrbot`，密码为安装表单里的「管理面板初始密码」。首次登录后 AstrBot 会要求修改密码。

如果表单里的初始密码没有生效（例如数据目录里已经存在旧的 `cmd_config.json`），可以从容器启动日志里找随机初始密码：

```bash
docker logs <容器名> | grep -i password
```

忘记密码时用内置 CLI 重置，改完需重启容器：

```bash
docker exec -it <容器名> astrbot password
docker restart <容器名>
```

> 容器隔离了网络，**不能用 `localhost` 访问管理面板**，请使用服务器的实际地址。

## 接入消息平台

本应用只部署 AstrBot 本体，不包含任何消息平台实现。接入 QQ 个人号时，需要另外部署 [NapCat](https://github.com/NapNeko/NapCat-Docker) 等 OneBot v11 实现，并把它指向本容器的 6199 端口。容器之间可以直接用容器名互访，例如 `ws://<容器名>:6199/ws`。

## 数据与升级

- 全部状态保存在 `./data`（容器内 `/AstrBot/data`）：`cmd_config.json`、插件、知识库、临时文件与数据库。
- 升级或更换版本都会保留该目录；删除它等于全新安装。

## 注意

- **未包含 Agent 沙盒。** 上游的 `compose-with-shipyard.yml` 需要挂载 `/var/run/docker.sock` 并额外运行 Shipyard 容器，属于高权限组合，本应用没有打包。需要原生 Python/Shell 代码执行能力时请按官方文档自行部署。
- 容器以 `no-new-privileges` 运行；插件市场与插件依赖安装在容器内完成，需要容器能访问外网。
- 上游 compose 还挂载了 `/etc/localtime:/etc/localtime:ro`，本应用改用 `TZ` 环境变量控制时区，效果相同且不需要宿主机路径。
- 部署在云服务器上时，请确认安全组已放行 6185（以及接入平台时需要的 6199）。

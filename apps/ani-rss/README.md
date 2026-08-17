# ANI-RSS

ANI-RSS 是一款专为动漫爱好者设计的自动订阅与下载工具，支持 Docker 快速部署，自动追番、下载、推送，适配主流下载器（如 qBittorrent、Aria2 等），让追番更智能高效。

![](https://raw.githubusercontent.com/xiaoY233/PicList/main/public/assets/ANI-RSS.png)

![](https://img.shields.io/badge/Copyright-arch3rPro-ff9800?style=flat&logo=github&logoColor=white)

## 主要功能

- **动漫 RSS 订阅**：自动订阅番剧更新，支持多站点源。
- **自动下载与推送**：集成 qBittorrent、Aria2 等主流下载器，自动推送下载任务。
- **多平台支持**：兼容 Docker、Linux、群晖 NAS 等主流环境。
- **配置灵活**：支持自定义订阅源、下载路径、推送规则等。
- **Web 管理界面**：直观易用的 Web UI，便捷管理订阅与下载。
- **多用户与权限**：支持多用户协作与权限分配。
- **日志与通知**：详细日志、支持多种通知方式。

## 部署模式说明

ANI-RSS 推荐使用 Docker 部署，支持 host/bridge 两种网络模式：

- **host 模式（推荐）**：
  - 使用主机网络，端口固定，适合需要完整网络能力的场景。
- **bridge 模式**：
  - 支持自定义端口映射，适合端口隔离、面板统一管理。

> 配置目录（容器内）：`/config`，主机目录可自定义，建议持久化保存。

## 典型使用场景

- 自动追番与下载，番剧更新实时推送
- 多站点动漫 RSS 聚合与管理
- 家庭/个人 NAS 动漫自动化下载
- 多用户协作与权限管理

## 平台与架构支持

- Docker、Linux、群晖 NAS 等
- 支持 amd64、arm64、arm/v7 等主流架构

## 快速部署（Docker 示例）

**host 网络模式（推荐）**
```yaml
version: "3"
services:
  ani-rss:
    image: wushuo894/ani-rss:latest
    container_name: ani-rss
    environment:
      - PUID=0
      - PGID=0
      - UMASK=022
      - PORT=7789
      - CONFIG=/config
      - TZ=Asia/Shanghai
    volumes:
      - ./ani-rss-config:/config
      - /your/media/path:/Media
    restart: always
    network_mode: host
```

**bridge 网络模式**
```yaml
version: "3"
services:
  ani-rss:
    image: wushuo894/ani-rss:latest
    container_name: ani-rss
    environment:
      - PUID=0
      - PGID=0
      - UMASK=022
      - PORT=7789
      - CONFIG=/config
      - TZ=Asia/Shanghai
    volumes:
      - ./ani-rss-config:/config
      - /your/media/path:/Media
    ports:
      - "7789:7789"
    restart: always
```

## 常见问题 FAQ

- **Q: 默认管理端口和账号密码？**
  A: 默认端口 7789，账号/密码均为 admin。
- **Q: 如何持久化配置？**
  A: 挂载主机目录到 `/config`，如 `./ani-rss-config:/config`。
- **Q: 支持哪些下载器？**
  A: 支持 qBittorrent、Aria2 等主流下载器。
- **Q: 支持哪些平台？**
  A: Docker、Linux、群晖 NAS 等。
- **Q: 官方文档地址？**
  A: [https://docs.wushuo.top/deploy/docker](https://docs.wushuo.top/deploy/docker)

## 官方文档与支持

- 官网：[https://docs.wushuo.top/](https://docs.wushuo.top/)
- 安装文档：[https://docs.wushuo.top/deploy/docker](https://docs.wushuo.top/deploy/docker)
- GitHub：[https://github.com/wushuo894/ani-rss](https://github.com/wushuo894/ani-rss) 
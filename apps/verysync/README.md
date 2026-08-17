# Verysync 微力同步

Verysync（微力同步）是一款基于智能P2P技术的极速文件同步工具，支持多平台部署，适合家庭、企业、开发者等多场景使用。

![](https://cdn.jsdelivr.net/gh/xiaoY233/PicList@main/public/assets/Verysync.png)

![](https://img.shields.io/badge/Copyright-arch3rPro-ff9800?style=flat&logo=github&logoColor=white)

## 主要功能

- **极速P2P同步**：智能P2P加速，文件分块同步，传输速度快。
- **多平台支持**：兼容 Windows、Linux、macOS、NAS、Docker 等主流平台。
- **数据加密**：全程 AES 加密，保障数据安全。
- **Web 管理界面**：直观易用的 Web UI，支持多用户管理。
- **灵活同步策略**：支持单向/双向同步、定时同步等多种策略。
- **多架构镜像**：支持 amd64、arm64、armv7 等主流架构。

## 端口说明

- **8886**：Web 管理端口（主端口，需自定义变量）
- **22330**：数据传输端口（需自定义变量）
- **3000**：公共中继端口（可选，默认不映射）
- **22027/22037**：内网 UDP 发现端口（可选，默认不映射）

## 快速部署（Docker 示例）

```yaml
services:
  verysync:
    image: jonnyan404/verysync:v2.20.1
    container_name: verysync
    ports:
      - "${PANEL_APP_PORT_HTTP}:8886"   # Web管理端口
      - "${VERYSYNC_TRANSFER_PORT}:22330"   # 数据传输端口
      # - "3000:3000"         # 公共中继端口（可选）
      # - "22027:22027/udp"   # 内网UDP发现端口（可选）
      # - "22037:22037/udp"   # 内网UDP发现端口（可选）
    volumes:
      - "${VERYSYNC_DATA_PATH}:/data"
    restart: unless-stopped
```

> 配置与数据目录（容器内）：`/data`，建议挂载主机目录持久化保存。

## 典型使用场景

- 家庭/企业多设备文件同步与备份
- NAS/服务器与多终端数据同步
- 跨平台文件高速传输与共享
- 私有云数据同步与安全备份

## 平台与架构支持

- Windows、Linux、macOS、NAS、Docker
- 支持 amd64、arm64、armv7 等主流架构

## 常见问题 FAQ

- **Q: 默认管理端口和账号密码？**
  A: 默认端口 8886，首次无密码，建议登录后设置。
- **Q: 如何持久化配置和数据？**
  A: 挂载主机目录到 `/data`，如 `VERYSYNC_DATA_PATH:/data`。
- **Q: 支持哪些平台和架构？**
  A: Windows、Linux、macOS、NAS、Docker，支持 amd64、arm64、armv7。
- **Q: 如何自定义端口？**
  A: 通过 compose 变量自定义 8886/22330 端口，其他端口可按需映射。
- **Q: 镜像版本如何选择？**
  A: 推荐使用 [Docker Hub](https://hub.docker.com/r/jonnyan404/verysync/tags) 查看最新版本。

## 官方文档与支持

- 官网：[https://www.verysync.com/](https://www.verysync.com/)
- 安装文档：[https://www.verysync.com/manual/install/docker.html](https://www.verysync.com/manual/install/docker.html)
- GitHub：[https://github.com/Jonnyan404/verysync](https://github.com/Jonnyan404/verysync) 
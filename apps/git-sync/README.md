# Git-Sync

Git-Sync 是一款支持多平台的 Git 仓库自动同步与备份工具，支持定时任务、Docker 快速部署，适合个人和团队代码备份。

## 主要功能

- **多仓库同步**：支持同步多个 Git 仓库，自动拉取、推送。
- **定时任务**：内置 cron 功能，支持定时自动同步。
- **备份管理**：可将仓库备份到本地指定目录。
- **配置灵活**：支持自定义配置文件路径、备份目录、用户权限。
- **Docker 部署**：一键部署，环境隔离，易于管理。

## 快速部署（Docker 示例）

```yaml
version: "3"
services:
  git-sync:
    image: akashrajpuroh1t/git-sync:latest
    container_name: git-sync
    environment:
      - PUID=1000
      - PGID=1000
    volumes:
      - /你的/config.yaml:/git-sync/config.yaml
      - /你的/备份目录:/backups
    restart: unless-stopped
```

> 建议将 config.yaml 和备份目录挂载到主机，便于持久化和管理。

## 变量说明

- **GITSYNC_CONFIG_PATH**：配置文件路径（如 /git-sync/config.yaml）。
- **GITSYNC_BACKUP_PATH**：备份目录（如 /backups）。
- **PUID/PGID**：容器内运行用户及组（建议与主机一致，常用 1000）。

## 常见问题 FAQ

- **Q: 如何定时同步？**
  A: 在 config.yaml 中配置 cron 规则，容器会自动定时同步。
- **Q: 配置文件如何写？**
  A: 详见 [官方文档](https://github.com/AkashRajpurohit/git-sync/wiki/Installation#with-docker)。
- **Q: 支持哪些平台？**
  A: 支持 Docker、Linux、Windows 等主流平台。

## 官方文档与支持

- GitHub: https://github.com/AkashRajpurohit/git-sync
- 安装文档: https://github.com/AkashRajpurohit/git-sync/wiki/Installation#with-docker 
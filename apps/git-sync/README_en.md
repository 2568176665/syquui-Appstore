# Git-Sync

Git-Sync is a cross-platform tool for automatic synchronization and backup of Git repositories. It supports cron jobs, easy Docker deployment, and is suitable for both personal and team code backup.

## Main Features

- **Multi-repo sync**: Sync multiple Git repositories, auto pull and push.
- **Cron jobs**: Built-in cron support for scheduled sync.
- **Backup management**: Backup repositories to a specified local directory.
- **Flexible config**: Custom config file path, backup directory, user permissions.
- **Docker deployment**: One-click deployment, isolated environment, easy management.

## Quick Deployment (Docker Example)

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
      - /your/config.yaml:/git-sync/config.yaml
      - /your/backup:/backups
    restart: unless-stopped
```

> It is recommended to mount config.yaml and backup directory to the host for persistence and management.

## Variable Description

- **GITSYNC_CONFIG_PATH**: Config file path (e.g. /git-sync/config.yaml).
- **GITSYNC_BACKUP_PATH**: Backup directory (e.g. /backups).
- **PUID/PGID**: User and group ID inside the container (should match host, usually 1000).

## FAQ

- **Q: How to schedule sync?**
  A: Configure cron rules in config.yaml, the container will sync automatically.
- **Q: How to write the config file?**
  A: See [official docs](https://github.com/AkashRajpurohit/git-sync/wiki/Installation#with-docker).
- **Q: Which platforms are supported?**
  A: Docker, Linux, Windows, etc.


## Official Docs & Support

- GitHub: https://github.com/AkashRajpurohit/git-sync
- Install Guide: https://github.com/AkashRajpurohit/git-sync/wiki/Installation#with-docker 
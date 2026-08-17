# AdGuardHome-Sync

AdGuardHome-Sync 是一个用于在多个 AdGuardHome 实例之间同步配置的工具。

![AdGuardHome-Sync.png](https://raw.githubusercontent.com/xiaoY233/PicList/main/public/assets/AdGuardHome-Sync.png)

![Copyright-arch3rPro](https://img.shields.io/badge/Copyright-arch3rPro-ff9800?style=flat&logo=github&logoColor=white)

## 功能特性

- 支持多个 AdGuardHome 实例之间的配置同步
- 提供 Web API 接口进行管理
- 支持定时同步任务
- 基于 LinuxServer.io 的 Docker 镜像

## 使用方法

配置文件已映射：/config/adguardhome-sync.yaml
- 默认账号：username
- 默认密码：password

1. 部署后访问 Web API 端口（默认 8080）
2. 配置 AdGuardHome 实例的连接信息
3. 设置同步规则和时间间隔
4. 启动同步任务

## 相关链接

- [GitHub 项目](https://github.com/bakito/adguardhome-sync)
- [LinuxServer.io 文档](https://docs.linuxserver.io/images/docker-adguardhome-sync/) 
# Lucky

Lucky 是一款集端口转发、流量转发、WAF、防火墙、备份等多功能于一体的网络加速与安全工具，支持 OpenWrt、Docker、Linux 等多平台部署，适用于家庭、企业、开发者等多种场景。

## 主要功能

- **端口转发/流量转发**：支持多种协议的端口转发，轻松实现内外网互通。
- **WAF 防火墙**：内置 Web 应用防火墙，有效防护常见攻击。
- **多平台支持**：兼容 OpenWrt、Docker、Linux、Windows 等主流平台。
- **IPv4/IPv6 支持**：支持双栈网络，适应多种网络环境。
- **配置备份与还原**：一键备份/恢复配置，升级无忧。
- **Web 管理界面**：直观易用的 Web UI，支持多用户管理。
- **自动升级**：支持后台上传升级包或手动替换升级。

![Copyright-arch3rPro](https://img.shields.io/badge/Copyright-arch3rPro-ff9800?style=flat&logo=github&logoColor=white)


## 部署模式说明

Lucky 提供两种 Docker 部署模式：

- **host 模式（推荐）**：
  - 使用主机网络，支持 IPv4/IPv6，端口固定 16601。
  - 适合需要完整网络能力、IPv6、端口穿透等高级场景。
- **bridge 模式**：
  - 支持自定义端口映射（默认 16601:16601），仅支持 IPv4。
  - 适合需要端口隔离、面板统一管理的场景。

> 配置目录（容器内）：`/goodluck`，主机目录可自定义，建议持久化保存。

## 典型使用场景

- 家庭/企业内网穿透与端口映射
- 多端口/多协议转发与流量管理
- Web 服务安全防护（WAF）
- OpenWrt 路由器高级网络管理
- Docker 环境下的统一端口转发与备份

## 平台与架构支持

- OpenWrt、Docker、Linux、Windows
- 支持 amd64、arm64、arm/v7 等主流架构

## 快速部署（Docker 示例）

**host 网络模式（推荐，支持 IPv4/IPv6）**
```yaml
services:
  lucky:
    image: gdy666/lucky
    container_name: lucky
    network_mode: host
    volumes:
      - ./luckyconf:/goodluck
    restart: always
```

**bridge 网络模式（仅支持 IPv4，部分功能受限）**
```yaml
services:
  lucky:
    image: gdy666/lucky
    container_name: lucky
    ports:
      - 16601:16601
    volumes:
      - ./luckyconf:/goodluck
    restart: always
```

## 常见问题 FAQ

- **Q: 默认管理端口和账号密码？**
  A: 默认端口 16601，账号/密码均为 666。
- **Q: 如何备份和升级？**
  A: 可在 Web 后台一键备份/还原配置，或上传升级包升级。
- **Q: bridge 模式下端口无法访问？**
  A: 建议优先使用 host 模式，bridge 模式部分环境下端口访问有限制。
- **Q: 支持哪些平台？**
  A: OpenWrt、Docker、Linux、Windows 等。
- **Q: 配置目录如何持久化？**
  A: 挂载主机目录到 `/goodluck`，如 `./luckyconf:/goodluck`，升级/重装不丢失配置。

## 官方文档与支持

- 官网：[https://lucky666.cn/](https://lucky666.cn/)
- 安装文档：[https://lucky666.cn/docs/install](https://lucky666.cn/docs/install)
- GitHub：[https://github.com/gdy666/lucky](https://github.com/gdy666/lucky) 
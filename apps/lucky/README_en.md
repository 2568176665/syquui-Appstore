# Lucky

Lucky is an all-in-one network acceleration and security tool integrating port forwarding, traffic proxy, WAF, firewall, and backup. It supports OpenWrt, Docker, Linux, and more, suitable for home, enterprise, and developer scenarios.

## Main Features

- **Port/Traffic Forwarding**: Supports multiple protocols, easily connect internal and external networks.
- **WAF Firewall**: Built-in web application firewall for effective protection.
- **Multi-Platform Support**: Compatible with OpenWrt, Docker, Linux, Windows, etc.
- **IPv4/IPv6 Support**: Dual-stack network support for various environments.
- **Config Backup & Restore**: One-click backup/restore, worry-free upgrades.
- **Web UI**: Intuitive web management, multi-user support.
- **Auto Upgrade**: Upgrade via web or manual replacement.

## Typical Use Cases

- Home/enterprise NAT traversal and port mapping
- Multi-port/protocol forwarding and traffic management
- Web service security (WAF)
- Advanced network management for OpenWrt routers
- Unified port forwarding and backup in Docker

## Platform & Architecture Support

- OpenWrt, Docker, Linux, Windows
- Supports amd64, arm64, arm/v7, etc.

## Quick Deployment (Docker Example)

**Host network mode (recommended, IPv4/IPv6 supported)**
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

**Bridge network mode (IPv4 only, some features limited)**
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

> Config directory (in container): `/goodluck`, host path customizable.

## FAQ

- **Q: Default admin port and credentials?**
  A: Default port 16601, username/password: 666/666.
- **Q: How to backup and upgrade?**
  A: Use web UI for one-click backup/restore or upload upgrade package.
- **Q: Bridge mode port not accessible?**
  A: Host mode is recommended; bridge mode may have port access issues in some environments.
- **Q: Which platforms are supported?**
  A: OpenWrt, Docker, Linux, Windows, etc.

## Official Docs & Support

- Website: [https://lucky666.cn/](https://lucky666.cn/)
- Install Guide: [https://lucky666.cn/docs/install](https://lucky666.cn/docs/install)
- GitHub: [https://github.com/gdy666/lucky](https://github.com/gdy666/lucky) 
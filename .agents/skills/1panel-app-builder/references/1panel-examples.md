# 1Panel App Store 参考模式

本文件用于给 1Panel App Builder 提供**结构模式**。正式打包时仍应以当前 `1Panel-dev/appstore` 和目标应用上游生产部署文档为准。

## 1. 标准目录

```text
apps/<app-key>/
├── data.yml
├── logo.png
├── README.md
├── README_en.md
└── <version>/
    ├── data.yml
    └── docker-compose.yml
```

`data/`、`logs/`、`conf/` 等不是必须提交的目录；只在需要预置文件时加入。

---

## 2. 顶层 data.yml

推荐完整元数据结构：

```yaml
name: DemoApp
tags:
  - 实用工具
title: DemoApp
description: 一个示例应用
additionalProperties:
  key: demo-app
  name: DemoApp
  tags:
    - Utility
  shortDescZh: 一个示例应用
  shortDescEn: A demo application
  description:
    en: A demo application
    es-es: A demo application
    fa: A demo application
    ja: A demo application
    ms: A demo application
    pt-br: A demo application
    ru: A demo application
    ko: A demo application
    zh-hant: 一個示例應用
    zh: 一个示例应用
    tr: A demo application
  type: website
  crossVersionUpdate: false
  limit: 0
  recommend: 50
  website: https://example.com
  github: https://github.com/example/demo
  document: https://example.com/docs
  architectures:
    - amd64
```

注意：

- `additionalProperties.key` 必须和目录名一致。
- 不要未经验证就声明 `arm64`。
- 对自动生成草稿，`crossVersionUpdate` 默认 `false` 更保守；只有确认跨版本升级路径后再设 `true`。

---

## 3. 版本 data.yml：端口

```yaml
additionalProperties:
  formFields:
    - default: 18080
      edit: true
      envKey: PANEL_APP_PORT_HTTP
      labelEn: Web Port
      labelZh: Web端口
      required: true
      rule: paramPort
      type: number
      label:
        en: Web Port
        es-es: Web Port
        fa: Web Port
        ja: Web Port
        ms: Web Port
        pt-br: Web Port
        ru: Web Port
        ko: Web Port
        zh-hant: Web 埠
        zh: Web端口
        tr: Web Port
```

宿主机默认端口：

- `80` / `443` 通常应避开，因为常由 1Panel 反向代理占用。
- `8080` **不是官方禁止端口**，当前官方应用也会使用；是否改成高位端口应看服务器实际冲突风险。
- 容器内部端口无需改变，例如 `${PANEL_APP_PORT_HTTP}:80` 完全正常。

---

## 4. 简单单服务 Compose

```yaml
services:
  demo:
    container_name: ${CONTAINER_NAME}
    restart: always
    networks:
      - 1panel-network
    ports:
      - "${PANEL_APP_PORT_HTTP}:8080"
    volumes:
      - ./data:/app/data
    image: example/demo:1.2.3
    labels:
      createdBy: "Apps"
networks:
  1panel-network:
    external: true
```

不要为了“看起来标准”而添加应用本身不使用的 `/app/data`、PUID、PGID 等配置。

---

## 5. 复用 1Panel MariaDB / MySQL

当前 1Panel 官方应用使用的数据库服务选择模式类似：

```yaml
additionalProperties:
  formFields:
    - child:
        default: ""
        envKey: PANEL_DB_HOST
        required: true
        type: service
      default: mariadb
      envKey: PANEL_DB_TYPE
      labelEn: Database Service
      labelZh: 数据库服务
      required: true
      type: apps
      values:
        - label: MySQL
          value: mysql
        - label: MariaDB
          value: mariadb

    - default: demo
      envKey: PANEL_DB_NAME
      labelEn: Database
      labelZh: 数据库
      random: true
      required: true
      rule: paramCommon
      type: text

    - default: demo
      envKey: PANEL_DB_USER
      labelEn: Database User
      labelZh: 数据库用户
      random: true
      required: true
      rule: paramCommon
      type: text

    - default: demoPass
      envKey: PANEL_DB_USER_PASSWORD
      labelEn: Database Password
      labelZh: 数据库密码
      random: true
      required: true
      type: password
```

Compose：

```yaml
services:
  app:
    container_name: ${CONTAINER_NAME}
    networks:
      - 1panel-network
    environment:
      DB_HOST: ${PANEL_DB_HOST}
      DB_PORT: ${PANEL_DB_PORT}
      DB_NAME: ${PANEL_DB_NAME}
      DB_USER: ${PANEL_DB_USER}
      DB_PASSWORD: ${PANEL_DB_USER_PASSWORD}
    image: example/app:1.2.3
```

原则：

- 只有应用支持外部数据库时才复用。
- 一个应用一个数据库和数据库用户。
- `PANEL_DB_PORT` 一般由 1Panel 数据库服务选择逻辑提供，不必把它做成普通用户表单端口。
- 如果应用首次启动需要 root 权限建库，而 1Panel 已经预创建数据库/用户，必须重新设计初始化流程，不能两套机制同时抢着建库。

---

## 6. Redis 复用

如果目标应用支持外部 Redis，可复用 1Panel Redis。

认证 URI 推荐：

```text
redis://:<password>@<host>:6379/8
```

多个应用或同一应用不同用途可使用不同 logical DB：

```text
cache   -> DB 8
queue   -> DB 9
socket  -> DB 9
```

不要默认把所有应用都塞进 Redis DB 0。

---

## 7. 不应强制复用数据库的情况

例如应用要求：

```yaml
image: pgvector/pgvector:pg16
```

而 1Panel 安装的是普通 PostgreSQL 镜像时，不能只因为“服务器已经有 PostgreSQL”就强行复用。

正确做法通常是：

```text
应用专用 pgvector PostgreSQL
+
复用 1Panel Redis（如果兼容）
```

先满足上游技术要求，再考虑减少容器数量。

---

## 8. 多服务应用

Frappe、Chatwoot、Dify 这类应用通常包含：

```text
frontend / web
backend / rails
worker
scheduler
websocket
init / migrate
DB
Redis
```

不要把官方多服务 Compose 直接抽成一个 `web` 容器。

可优化的是“替换依赖”：

```text
原 Compose DB  -> 1Panel MariaDB/PostgreSQL（确认兼容后）
原 Compose Redis -> 1Panel Redis（确认兼容后）
```

而不是丢掉 worker/scheduler/websocket/init。

---

## 9. 一次性初始化服务

```yaml
services:
  init:
    image: example/app:1.2.3
    restart: "no"
    command: ["./init.sh"]
    networks:
      - 1panel-network

  app:
    image: example/app:1.2.3
    restart: always
    depends_on:
      init:
        condition: service_completed_successfully
```

注意：

- one-shot 服务不应该 `restart: always`。
- 初始化判断要找真正成功标记，不能只看一个可能在失败前就创建的目录。
- 升级需要 migrate 的应用，应把迁移流程独立出来并保证失败会阻断主服务启动。

---

## 10. WebSocket / Reverse Proxy

错误示例：

```text
WEB_SOCKET_URL=ws://espocrm-websocket:8080
```

如果这个 URL 会被发送给浏览器，用户电脑无法解析 Docker 内部 hostname。

正确方向：

```text
wss://crm.example.com/ws
```

并由 1Panel / Nginx 将 `/ws` 代理到内部 WebSocket 服务。

如果应用允许关闭 WebSocket，草稿阶段关闭它也比发布一个必坏的内部 URL 更安全。

---

## 11. 固定版本

推荐：

```text
apps/demo/1.2.3/docker-compose.yml
image: example/demo:1.2.3
```

或：

```text
目录: 1.2.3
镜像: example/demo:v1.2.3
```

不建议正式业务包：

```text
目录: 1.2.3
镜像: example/demo:latest
```

`latest` / `stable` 目录只有在用户明确需要并且上游通道可靠时才添加。

---

## 12. 发布前清单

1. 上游生产 Compose / 安装文档已核对。
2. 主镜像固定到确定版本。
3. 架构声明已验证。
4. DB/Redis 拓扑与上游兼容。
5. worker/scheduler/websocket/init/migrate 未丢。
6. 端口变量与表单一致。
7. 80/443 不被静态占用。
8. 数据卷持久化明确。
9. `.env`/密钥未打包泄漏。
10. WebSocket 使用客户端可访问地址。
11. 真实 logo 已准备。
12. `validate-app.sh` 通过。

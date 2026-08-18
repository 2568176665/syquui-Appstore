# 1Panel App Builder

用于把 Docker 部署整理成 **可维护、可审查、偏生产使用** 的 1Panel 本地应用商店包。

AI 使用入口是 `SKILL.md`；人工常用入口是 `scripts/` 下的生成、验证和图标脚本。

## 设计原则

- 默认只生成**固定版本**，不自动创建 `latest/` / `stable/`。
- 优先保留已经验证过的上游具体镜像 tag，不自动追新。
- 多服务 Compose 默认拒绝“只抽主服务”，避免把 DB / Redis / worker / init / websocket 等依赖丢掉。
- 不凭空添加来源中不存在的 `/app/data`、PUID、PGID、UMASK 等配置。
- 生成器只负责安全草稿；正式包必须结合上游生产部署文档人工复核。
- 可复用 1Panel 的 MariaDB/MySQL/PostgreSQL/Redis，但只有在上游明确支持外部服务时才这么做。
- 遇到 pgvector 等特殊数据库扩展时，不为了统一而强行复用普通 1Panel 数据库。

## 快速使用

从技能目录执行：

```bash
# 检查依赖
bash ./scripts/generate-app.sh --check-deps

# 从单服务 Compose 生成固定版本草稿
bash ./scripts/generate-app.sh \
  --app-key my-app \
  --name MyApp \
  --version 1.2.3 \
  --icon-mode skip \
  ./docker-compose.yml

# 验证最终应用
bash ./scripts/validate-app.sh ./apps/my-app

# 草稿验证（缺少图标时只警告）
bash ./scripts/validate-app.sh --draft ./apps/my-app

# 验证技能脚本
bash ./tests/run_all.sh
```

## 多服务 Compose

默认不会自动生成，因为把多服务堆栈缩成单容器通常会得到一个“看起来能装、实际启动失败”的包。

如果只是为了快速提取某个服务做草稿：

```bash
bash ./scripts/generate-app.sh \
  --service web \
  --allow-partial-compose \
  --allow-lossy \
  --version 1.2.3 \
  ./docker-compose.yml
```

最终发布前必须手工补回依赖，或明确改成 1Panel 托管数据库/Redis。

## 版本策略

如果来源镜像已经是：

```text
myorg/myapp:v1.2.3
```

生成器默认直接使用这个具体版本，不会偷偷改成 registry 当前最新版本。

如果来源只有 `latest` / `stable`，默认会要求你显式提供：

```bash
--version v1.2.3
```

只有明确知道自己在做什么时才使用：

```bash
--resolve-version
```

## 依赖

生成器需要：

- Bash
- curl
- jq
- Python 3
- PyYAML（`python3 -c "import yaml"` 可成功）

`yq` 不是必需依赖；验证器如果检测到 Mike Farah `yq` v4+ 会优先使用，否则自动使用 Python + PyYAML。

## 图标策略

- `auto`: 缓存优先，缺失时尝试网络源。
- `skip`: 完全跳过，适合草稿。
- `cache-only`: 只读 `.cache/icons`。
- `required`: 最终包模式；找不到真实图标则失败。

不会创建伪造的占位图。

## 主要验证项

- YAML 能否解析。
- `additionalProperties.key` 是否与目录一致。
- 固定版本目录是否意外使用 `latest/stable` 主镜像。
- `PANEL_APP_PORT_*` 是否有对应表单字段。
- `${VAR}` 是否存在未定义来源。
- 是否静态占用宿主机 80/443。
- 是否存在可疑绝对数据卷。
- `env_file` 是否在包内缺失。
- 浏览器 WebSocket URL 是否误写 Docker 内部 hostname。
- `logo.png` 是否实际是图片而不是 HTML 错误页。

更详细的规则见 `SKILL.md`。

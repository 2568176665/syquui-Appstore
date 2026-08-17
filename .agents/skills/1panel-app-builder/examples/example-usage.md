# 使用示例

## 1. 单服务 Compose → 固定版本草稿

```bash
bash ./scripts/generate-app.sh \
  --app-key demo-app \
  --name DemoApp \
  --version 1.25.3 \
  --icon-mode skip \
  --output ../../../apps \
  /tmp/demo-compose.yml
```

生成：

```text
apps/demo-app/
├── data.yml
├── README.md
├── README_en.md
└── 1.25.3/
    ├── data.yml
    └── docker-compose.yml
```

不会自动生成 `latest/`。

## 2. 来源已经是具体 tag

Compose：

```yaml
services:
  web:
    image: nginx:1.25.3
    ports:
      - "18080:80"
```

可以省略 `--version`：

```bash
bash ./scripts/generate-app.sh --app-key nginx-demo ./compose.yml
```

生成器会保留 `1.25.3`，不会自动追到 registry 里更高版本。

## 3. 来源使用 latest/stable

如果 Compose 使用：

```yaml
image: example/app:latest
```

推荐：

```bash
bash ./scripts/generate-app.sh \
  --version 2.4.1 \
  ./compose.yml
```

不建议依赖浮动 channel。

## 4. 多服务 Compose

以下 Compose：

```yaml
services:
  web:
    image: example/web:1.0.0
    depends_on:
      - db
      - redis
  db:
    image: postgres:16
  redis:
    image: redis:7
```

生成器会默认拒绝，因为只生成 `web` 会丢失依赖。

若只是想生成一个待人工修改的草稿：

```bash
bash ./scripts/generate-app.sh \
  --service web \
  --allow-partial-compose \
  --allow-lossy \
  --version 1.0.0 \
  ./compose.yml
```

正式包应该：

- 保留完整多服务堆栈；或
- 把数据库/Redis 改成明确测试过的 1Panel 托管服务。

## 5. docker run

```bash
bash ./scripts/generate-app.sh \
  --app-key nginx-demo \
  --name NginxDemo \
  --version 1.25.3 \
  --icon-mode skip \
  'docker run -d --name nginx-demo -p 18080:80 -v ./data/html:/usr/share/nginx/html nginx:1.25.3'
```

如果命令包含 `--privileged`、`--device`、`--entrypoint` 等生成器不能无损保留的选项，默认会拒绝。只有草稿才使用 `--allow-lossy`。

## 6. 验证

```bash
bash ./scripts/validate-app.sh ../../../apps/demo-app
```

草稿：

```bash
bash ./scripts/validate-app.sh --draft ../../../apps/demo-app
```

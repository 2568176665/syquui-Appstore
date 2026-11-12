# 仓库指南

官方仓库：https://github.com/1Panel-dev/appstore
第三方仓库：https://github.com/okxlin/appstore

## 项目形态

本仓库是第三方 1Panel 本地应用商店，主要由 YAML、Docker Compose 文件、README、图标和辅助 shell 脚本组成，没有集中的应用构建步骤。

顶层文件：

- `data.yaml`：应用商店元数据以及分类/标签定义。
- `apps/<app-key>/`：每个应用一个目录。
- `.agents/skills/`：应用生成指南、模板和辅助脚本。

## 应用包目录结构

每个应用采用如下结构：

```text
apps/<app-key>/
├── data.yml
├── logo.png
├── README.md
├── README_en.md
├── <version>/
│   ├── data.yml
│   ├── docker-compose.yml
│   └── data/
└── latest/
    ├── data.yml
    └── docker-compose.yml
```

每个应用必须同时提供一个固定版本目录和一个 `latest/` 目录：

- 固定版本目录以具体版本号命名（不以 `v` 开头），使用固定的镜像标签。
- `latest/` 使用 `latest` 镜像标签，其余内容（端口、卷、环境变量、健康检查、标签）与固定版本目录保持一致。
- 两个目录的 `data.yml` 表单字段必须完全一致，否则安装表单会因所选版本不同而变化。

1Panel 会把 `apps/<app-key>/` 下的**每个子目录**都当作版本目录，并强制要求其中的 `docker-compose.yml` 与 `data.yml`，否则同步本地应用时报“docker-compose.yml 文件不存在”。因此测试脚本等非版本内容必须放在 `apps/` 之外，不能放在应用目录内。

## 1Panel 约定

- 应用 key 使用小写字母和连字符，且必须与应用目录名一致。
- 顶层 `apps/<app-key>/data.yml` 存放展示元数据。
- 版本级 `data.yml` 存放 `additionalProperties.formFields`。
- 优先使用标准端口变量，例如 `PANEL_APP_PORT_HTTP`、`PANEL_APP_PORT_HTTPS`、`PANEL_APP_PORT_API`、`PANEL_APP_PORT_ADMIN`、`PANEL_APP_PORT_PROXY`、`PANEL_APP_PORT_DB`、`PANEL_APP_PORT_SSH`、`PANEL_APP_PORT_S3`、`PANEL_APP_PORT_SYNC`。
- `docker-compose.yml` 中用到的每个 `PANEL_APP_PORT_*` 都应在版本 `data.yml` 中有对应的表单字段。
- Compose 服务应使用 `container_name: ${CONTAINER_NAME}`、`restart: always`、外部 `1panel-network`、相对 `./data/` 卷路径做持久化，并添加 `labels: createdBy: "Apps"`。
- 使用 `./data/...` 挂载，而不是宿主机绝对路径，除非应用确实需要宿主机集成。
- 格式严格的密钥（定长十六进制、固定前缀等）不要用表单 `random: true`，应在版本目录的 `scripts/init.sh` 中生成到 `data/secrets.env`，再用 `env_file` 注入；细节见 `.agents/skills/1panel-app-builder/SKILL.md`。
- 保持应用元数据标签与 `data.yaml` 一致。

## 应用创建流程

添加或修改应用包之前，先阅读 `.agents/skills/1panel-app-builder/SKILL.md`。它记录了预期的 1Panel 打包流程、元数据字段、compose 转换规则、README 形态以及图标查找顺序。

常用辅助脚本（在仓库根目录执行）：

```bash
./.agents/skills/1panel-app-builder/scripts/generate-app.sh <github-url-or-compose-or-docker-run>
./.agents/skills/1panel-app-builder/scripts/download-icon.sh <app-name> <output-path> 200
./.agents/skills/1panel-app-builder/scripts/validate-app.sh ./apps/<app-key>
```

生成器只是起点。在认为应用完成之前，请检查并调整生成的元数据、端口、卷、环境变量、README 内容和图标。

## 验证

对改动的应用运行：

```bash
./.agents/skills/1panel-app-builder/scripts/validate-app.sh ./apps/<app-key>
```

对 YAML 或 Compose 的修改，还应直接检查受影响的文件。验证器基于 shell/grep，能发现常见的结构性问题，但不能发现所有语义问题。

## 编辑说明

- 保持正在编辑文件内的 YAML 缩进风格。
- 保持 README 简洁、聚焦应用；许多应用同时包含中文和英文 README。
- 不要用占位图替换真实 logo。如果找不到图标，请明确指出，而不是伪造一个不准确的资源。
- 将工作区中无关的改动视为用户所有，保持不动。

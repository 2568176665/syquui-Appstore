# BettaFish（微舆）

微舆（BettaFish）是一个从零实现的多 Agent 舆情分析系统：Insight Agent 挖掘私有数据库，Media Agent 分析多模态内容，Query Agent 联网检索，Report Agent 汇总生成结构化报告，ForumEngine 负责 Agent 之间的讨论。

## 版本与架构

- 固定版本：`3.0.0`，镜像 `ghcr.io/666ghj/bettafish:v3.0.0`。
- 支持 Linux amd64 / arm64。
- 内置 PostgreSQL 15，数据保存在 `./data/db_data`，不发布宿主机端口。

## 端口

| 端口变量 | 默认 | 用途 |
| --- | --- | --- |
| `PANEL_APP_PORT_HTTP` | 5000 | Flask 主界面 |
| `PANEL_APP_PORT_INSIGHT` | 8501 | Insight Agent（Streamlit） |
| `PANEL_APP_PORT_MEDIA` | 8502 | Media Agent（Streamlit） |
| `PANEL_APP_PORT_QUERY` | 8503 | Query Agent（Streamlit） |

主界面通过 `window.location.hostname` 加 8501–8503 端口加载各 Agent 的 iframe，因此这三个端口必须对浏览器可达。若通过域名反向代理访问，需要在同一个域名下把 8501–8503 一并放通，或者直接使用服务器 IP + 端口访问。

## 安装与配置

1. 安装时自动生成数据库密码并写入应用目录的 `.env`（权限 600），同时固定 `DB_HOST=db`、`DB_PORT=5432`、`DB_DIALECT=postgresql`。升级会复用已有密码，不要删除或修改该文件。
2. 数据库表在首次启动系统时由应用自动创建，无需手动初始化。
3. 安装表单中的各 Agent 密钥可以留空，稍后在主界面「配置」中填写并保存，配置会写回 `.env`。
4. 每个 Agent 均使用 OpenAI 兼容接口，需分别配置 `*_API_KEY`、`*_BASE_URL`、`*_MODEL_NAME`。
5. 联网搜索必须二选一：`SEARCH_TOOL_TYPE=AnspireAPI` 时填写 Anspire 密钥，`BochaAPI` 时填写 Bocha 密钥；Tavily 为可选补充。

## 使用

1. 打开 `http://<服务器IP>:5000`。
2. 在「配置」中补全模型与搜索密钥，点击「保存并启动系统」。
3. 系统启动 Insight / Media / Query 三个 Agent 后即可提交查询，报告输出到 `./data/final_reports`。

## 升级

更新前备份 `./data` 与 `.env`。`crossVersionUpdate` 为 `false`，跨版本升级请手动确认上游数据库结构变化。

项目：https://github.com/666ghj/BettaFish

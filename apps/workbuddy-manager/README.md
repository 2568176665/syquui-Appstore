# WorkBuddy Manager

腾讯 CodeBuddy 账号池的 Web 管理控制台，配套 [workbuddy2api](https://github.com/ithtelab/workbuddy-manager) 上游网关使用。本应用包会同时部署面板与上游网关，装完即可用。

## 功能

- **账号管理**：微信 / QQ 扫码纳管，有效期监控、一键续期、测活与手动签到，支持多账号池分组
- **定时任务**：签到、旅行、活跃、保活四类任务开关与执行时刻
- **反代网关**：对外提供 OpenAI 兼容的 `/v1` 接口，多密钥分发，每把密钥独立配额、有效期、IP 与模型白名单
- **审计与统计**：每次调用记录密钥、IP、模型、状态码、首字延迟与扣费
- **可视化设置**：多上游实例、IP 白 / 黑名单（CIDR）、PostgreSQL 备份、五语种界面

## 部署结构

| 服务 | 镜像 | 说明 |
| --- | --- | --- |
| `workbuddy-manager` | `ghcr.io/ithtelab/workbuddy-manager` | 管理面板，暴露 Web 端口 |
| `workbuddy2api` | `ghcr.io/ithtelab/workbuddy2api` | 上游网关，仅走 `1panel-network`，不对宿主机暴露端口 |

上游的 `config.json`、`auths/`、`data/` 都落在应用数据目录的 `data/upstream/` 下，面板通过同一目录读写账号授权文件。

## 首次启动

1. 安装时 `init.sh` 会生成 `data/upstream/config.json`，其中 `api_key` 为随机值；已存在的配置不会被覆盖。
2. 浏览器打开 `http://服务器地址:7864`，用户名 `admin`。
3. 初始管理员密码由面板首次启动随机生成，写在容器日志与 `data/initial-admin-password.txt` 中：

   ```bash
   docker logs <容器名> 2>&1 | grep -A2 "初始管理员"
   ```

4. 登录后立即在「设置 → 管理用户」修改密码，并在「账号」页扫码添加账号。

## 使用

日常三步：**纳管账号 → 分发密钥 → 把下游指到 `/v1`**。

- 面板地址：`http://服务器地址:7864`
- API 地址：`http://服务器地址:7864/v1`（使用面板「密钥」页签发的网关密钥）

## 注意事项

- 面板持有全部账号凭据，**请勿直接暴露到公网**；公网使用时应通过 HTTPS 反向代理并限制访问。
- 首次启动前请确认 `data/` 目录可被 uid `10001` 读写（`init.sh` 会处理，手动部署时需自行 `chown -R 10001:10001 ./data`）。
- 面板的「一键更新上游」「读上游日志」等功能依赖挂载 `/var/run/docker.sock`，本应用包默认**未挂载**，这些功能会提示改到宿主机执行，其余功能不受影响。
- 上游 `config.json` 的 `api_key` 为空时，上游所有端点无需鉴权，请勿清空该字段。
- 仅用于管理本人及亲属自愿授权的账号；禁止批量注册、账号交易、代注册与任何商业转售用途。

## 版本

- `2.11.9`：固定版本，面板与上游镜像均钉 `2.11.9`。
- `latest`：跟随上游 `latest` 标签，便于追新；不建议用于长期运行的实例。

项目地址：[GitHub](https://github.com/ithtelab/workbuddy-manager)

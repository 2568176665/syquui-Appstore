# APIPark

![APIPark](https://img.shields.io/github/stars/APIParkLab/APIPark?style=social)
![Docker Pulls](https://img.shields.io/docker/pulls/apipark/apipark)
![GitHub release](https://img.shields.io/github/v/release/APIParkLab/APIPark)
![License](https://img.shields.io/github/license/APIParkLab/APIPark)

## 项目简介

APIPark 是一个开源的企业级 API 全生命周期管理平台，旨在帮助企业和开发者更好地设计、开发、调试、发布和运维 API。它提供了直观的 Web 界面和强大的功能，让 API 管理变得简单高效。

## 核心特性

### 🚀 全生命周期管理
- **API 设计**: 支持 OpenAPI 规范的 API 设计和文档生成
- **API 开发**: 集成开发环境，支持多种编程语言
- **API 调试**: 内置 API 测试工具，支持多种认证方式
- **API 发布**: 一键发布 API 到生产环境
- **API 运维**: 实时监控 API 性能和健康状态

### 📊 监控与分析
- **实时监控**: 基于 InfluxDB 的高性能时序数据存储
- **日志聚合**: 集成 Loki 和 Grafana 的日志收集与可视化
- **性能分析**: 详细的 API 调用统计和性能指标
- **告警通知**: 智能的异常检测和告警机制

### 🔒 安全与权限
- **身份认证**: 多种认证方式支持（JWT、OAuth2、API Key 等）
- **权限控制**: 细粒度的权限管理和访问控制
- **安全审计**: 完整的操作日志和安全审计功能
- **数据加密**: 传输和存储数据的端到端加密

### 🌐 企业级特性
- **多租户**: 支持多租户架构，数据隔离
- **高可用**: 支持集群部署，确保服务高可用
- **扩展性**: 微服务架构，支持水平扩展
- **国际化**: 支持多语言界面

## 技术架构

APIPark 采用现代微服务架构，包含以下核心组件：

- **APIPark Core**: 核心 API 管理服务
- **MySQL**: 主数据库，存储业务数据
- **Redis**: 缓存服务，提高系统性能
- **InfluxDB**: 时序数据库，存储监控指标
- **NSQ**: 分布式消息队列，处理异步任务
- **Loki**: 日志聚合服务
- **Grafana**: 数据可视化平台

## 版本信息

- **当前版本**: v1.9.0-beta
- **最低配置**: 2核4G内存，200G存储
- **推荐配置**: 8核16G内存，200G存储

## 系统要求

### 硬件要求
- **CPU**: 最低 2 核，推荐 8 核
- **内存**: 最低 4G，推荐 16G
- **存储**: 最低 200G
- **系统**: Linux / Mac
- **架构**: AMD64 / ARM64

### 软件依赖
- **MySQL**: >= 5.7.x
- **Redis**: >= 6.2.x
- **InfluxDB**: >= 2.6
- **NSQ**: 分布式消息队列服务

## 快速开始

### 使用 1Panel 部署（推荐）

1. 在 1Panel 应用商店中搜索 "APIPark"
2. 点击安装，配置以下参数：
   - **Web 端口**: 默认 18288
   - **数据库密码**: 自动生成或自定义
   - **Redis 密码**: 自动生成或自定义
   - **管理员密码**: 设置管理员登录密码
   - **日志级别**: 选择合适的日志级别
3. 等待安装完成
4. 访问 `http://your-server:18288` 开始使用

### 手动部署

1. 下载配置文件：
```bash
curl -sSO https://download.apipark.com/install/quick-start.sh
bash quick-start.sh
```

2. 或使用 Docker Compose：
```bash
git clone https://github.com/APIParkLab/APIPark.git
cd APIPark
docker-compose up -d
```

## 配置说明

### 环境变量

| 变量名 | 说明 | 默认值 |
|-------|------|--------|
| `MYSQL_PWD` | MySQL 数据库密码 | - |
| `REDIS_PWD` | Redis 密码 | - |
| `ADMIN_PASSWORD` | 管理员登录密码 | admin123 |
| `LOG_LEVEL` | 日志级别 | info |
| `INFLUXDB_TOKEN` | InfluxDB 访问令牌 | - |

### 数据目录

- `/data/apipark`: APIPark 应用数据
- `/data/mysql`: MySQL 数据库文件
- `/data/redis`: Redis 数据文件
- `/data/influxdb`: InfluxDB 数据文件
- `/data/loki`: Loki 日志文件
- `/data/grafana`: Grafana 配置和数据

## 使用指南

### 首次登录

1. 使用浏览器访问部署的地址
2. 使用管理员账号登录（用户名：admin，密码：安装时设置的密码）
3. 按照向导完成初始化配置

### API 网关配置

APIPark 需要配置 API 网关节点才能完整使用：

1. 准备网关配置文件 `config.yml`
2. 配置网关服务地址和端口
3. 在 APIPark 控制台中添加网关节点

### 监控面板

系统自动配置 Grafana 监控面板：
- 系统会自动配置 Grafana 服务（内部访问）
- 自动配置 Loki 数据源
- 预设 APIPark 监控仪表板
- Grafana 登录密码与管理员密码相同

## 故障排除

### 常见问题

1. **容器启动失败**
   - 检查端口是否被占用
   - 验证配置文件格式
   - 查看容器日志：`docker logs container_name`

2. **数据库连接失败**
   - 确认 MySQL 服务正常运行
   - 检查数据库密码配置
   - 验证网络连接

3. **Redis 连接失败**
   - 确认 Redis 服务正常运行
   - 检查 Redis 密码配置
   - 验证网络连接

4. **Grafana 权限问题**
   - 如果出现权限错误，应用已自动配置权限修复
   - 初始化脚本会自动设置正确的目录权限
   - 如仍有问题，手动运行：`chown -R 472:472 ./data/grafana`

5. **InfluxDB 启动慢**
   - InfluxDB 首次启动需要较长初始化时间（可能超过60秒）
   - 请耐心等待健康检查通过
   - 可查看日志：`docker logs ${CONTAINER_NAME}_influxdb`

### 日志查看

- APIPark 日志：`docker logs ${CONTAINER_NAME}`
### 日志查看

- APIPark 日志：`docker logs ${CONTAINER_NAME}`
- MySQL 日志：`docker logs ${CONTAINER_NAME}_mysql`
- Redis 日志：`docker logs ${CONTAINER_NAME}_redis`
- InfluxDB 日志：`docker logs ${CONTAINER_NAME}_influxdb`
- NSQ 日志：`docker logs ${CONTAINER_NAME}_nsq`
- Grafana 日志：`docker logs ${CONTAINER_NAME}_grafana`
- Loki 日志：`docker logs ${CONTAINER_NAME}_loki`

## 更新升级

1. 停止当前容器：`docker-compose down`
2. 拉取最新镜像：`docker-compose pull`
3. 启动新版本：`docker-compose up -d`
4. 验证服务状态

## 注意事项

⚠️ **重要提醒**：
- 首次部署前请确保系统满足最低配置要求
- InfluxDB 首次启动可能需要60-120秒，请耐心等待
- Grafana 权限问题已通过初始化容器自动修复
- 生产环境建议使用外部数据库服务
- 定期备份重要数据
- 及时关注版本更新和安全补丁

💡 **性能优化建议**：
- 建议为 InfluxDB 分配至少 2GB 内存
- MySQL 和 Redis 数据目录建议使用 SSD 存储
- 在生产环境中考虑使用外部持久化存储

## 相关链接

- [官方网站](https://apipark.com)
- [GitHub 仓库](https://github.com/APIParkLab/APIPark)
- [在线文档](https://docs.apipark.com)
- [社区论坛](https://community.apipark.com)
- [问题反馈](https://github.com/APIParkLab/APIPark/issues)

## 许可证

本项目采用 Apache-2.0 许可证。详细信息请参阅 [LICENSE](https://github.com/APIParkLab/APIPark/blob/main/LICENSE) 文件。
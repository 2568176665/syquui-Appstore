# PanSou 网盘搜索API

PanSou是一个高性能的网盘资源搜索API服务，支持TG搜索和自定义插件搜索。系统设计以性能和可扩展性为核心，支持并发搜索、结果智能排序和网盘类型分类。

![](https://cdn.jsdelivr.net/gh/xiaoY233/PicList@main/public/assets/PanSou.png)

![](https://img.shields.io/badge/Copyright-arch3rPro-ff9800?style=flat&logo=github&logoColor=white)

## 特性

- **高性能搜索**：并发执行多个TG频道及异步插件搜索，显著提升搜索速度；工作池设计，高效管理并发任务
- **网盘类型分类**：自动识别多种网盘链接，按类型归类展示
- **智能排序**：基于插件等级、时间新鲜度和优先关键词的多维度综合排序算法
- **异步插件系统**：支持通过插件扩展搜索来源，支持"尽快响应，持续处理"的异步搜索模式，解决了某些搜索源响应时间长的问题。
- **二级缓存**：分片内存+分片磁盘缓存机制，大幅提升重复查询速度和并发性能  


## 支持的网盘类型

百度网盘 (`baidu`)、阿里云盘 (`aliyun`)、夸克网盘 (`quark`)、天翼云盘 (`tianyi`)、UC网盘 (`uc`)、移动云盘 (`mobile`)、115网盘 (`115`)、PikPak (`pikpak`)、迅雷网盘 (`xunlei`)、123网盘 (`123`)、磁力链接 (`magnet`)、电驴链接 (`ed2k`)、其他 (`others`)


## MCP服务

### 功能介绍

PanSou MCP 服务是一个基于 [Model Context Protocol (MCP)](https://modelcontextprotocol.io) 的工具服务，它将 PanSou 网盘搜索 API 的功能封装为可在支持 MCP 的客户端（如 Claude Desktop）中直接调用的工具。

通过 PanSou MCP 服务，可以直接在 Claude 等 AI 助手中搜索网盘资源，极大地提升了获取网盘资源的便捷性。

### 核心功能

1. **搜索网盘资源 (`search_netdisk`)**:
   - 支持通过关键词搜索网盘资源。
   - 可指定搜索来源：Telegram 频道、插件或两者结合。
   - 可过滤结果，仅显示特定类型的网盘链接（如百度网盘、阿里云盘、夸克网盘等）。
   - 支持强制刷新缓存以获取最新数据。
   - 支持传递扩展参数给后端插件。
   - 结果可按详细信息或按网盘类型分组展示。

2. **检查服务健康状态 (`check_service_health`)**:
   - 检查所连接的 PanSou 后端服务是否正常运行。
   - 获取后端服务的配置信息，如可用的 Telegram 频道列表和插件列表。

3. **启动后端服务 (`start_backend`)**:
   - 自动启动本地的 PanSou Go 后端服务（如果尚未运行）。
   - 等待服务完全启动并可用后才开始处理其他请求。

4. **获取静态资源信息 (`pansou://` URI scheme)**:
   - 提供可用插件列表、可用频道列表和支持的网盘类型列表等静态信息资源。

## 📚 API 文档

### 搜索 API

- 接口：`/api/search`
- 方法：`POST` / `GET`
- 参数：
  - `kw`：搜索关键词
  - `channels`：搜索的频道
  - `cloud_types`：网盘类型过滤
  - 更多详见[项目文档](https://github.com/fish2018/pansou)

### 健康检查 API

- 接口：`/api/health`
- 方法：`GET`

## 🔗 项目地址

- GitHub: https://github.com/fish2018/pansou
- 文档: https://github.com/fish2018/pansou
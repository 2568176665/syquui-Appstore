# MetaMCP

**MetaMCP** 是一个 MCP 代理，允许你动态聚合 MCP 服务器为统一的 MCP 服务器，并应用中间件。MetaMCP 本身也是一个 MCP 服务器，因此可以轻松接入**任何** MCP 客户端。

![](https://cdn.jsdelivr.net/gh/xiaoY233/PicList@main/public/assets/MetaMCP.png)

![](https://img.shields.io/badge/Copyright-arch3rPro-ff9800?style=flat&logo=github&logoColor=white)


## 主要特点

- 🏷️ **将 MCP 服务器分组到命名空间**，作为 meta-MCP 托管，并分配公共端点（SSE 或 Streamable HTTP），支持认证。一键切换端点的命名空间。
- 🎯 **在混合 MCP 服务器时只选择你需要的工具**。可应用其他可插拔中间件，如可观测性、安全等。
- 🔍 **作为增强版 MCP 检查器**，支持保存服务器配置，并可在本地检查 MetaMCP 端点是否可用。
- 🔍 **作为 MCP 工具选择的 Elasticsearch**。

## 核心概念

### MCP 服务器
MCP 服务器配置，告诉 MetaMCP 如何启动 MCP 服务器。

### MetaMCP 命名空间
- 将一个或多个 MCP 服务器分组到命名空间
- 支持在服务器或工具级别启用/禁用 MCP 服务器
- 可在命名空间级别应用中间件处理 MCP 请求和响应

### MetaMCP 端点
- 创建端点并为其分配命名空间
- 命名空间内的多个 MCP 服务器将被聚合并作为 MetaMCP 端点输出
- 可选择 API Key 认证或 MCP Spec 2025-06-18 标准 OAuth
- 通过 SSE 或 Streamable HTTP 传输协议以及 OpenAPI 端点对外提供服务

### 中间件
- 在命名空间级别拦截并转换 MCP 请求和响应
- 内置示例："过滤非活跃工具"——为 LLM 优化工具上下文

## 使用场景

- 作为基础设施，通过统一端点托管动态组合的 MCP 服务器
- 在混合 MCP 服务器时只选择需要的工具
- 作为增强版 MCP 检查器，支持保存服务器配置
- 作为 MCP 工具选择的搜索引擎

## 更多信息

更多详细信息，请访问官方文档：https://docs.metamcp.com
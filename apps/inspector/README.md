# MCP Inspector

MCP Inspector 是一个用于测试和调试 Model Context Protocol (MCP) 服务器的开发工具，提供直观的 Web UI 界面和命令行接口，帮助开发者探索和测试 MCP 服务器的功能。

![](https://cdn.jsdelivr.net/gh/xiaoY233/PicList@main/public/assets/MCP-Inspector.png)

![](https://img.shields.io/badge/Copyright-arch3rPro-ff9800?style=flat&logo=github&logoColor=white)

## 🚀 主要功能

- **🔌 连接管理** - 建立并维护与 MCP 服务器的连接
- **🔍 能力探索** - 发现和测试服务器的能力，例如工具、资源和提示
- **🔐 认证处理** - 支持 OAuth 流程和 Bearer Token 认证
- **📊 请求/响应检查** - 显示详细的 MCP 协议交互
- **⚙️ 配置管理** - 持久化用户设置和连接参数
- **💻 CLI 模式** - 提供命令行接口，用于自动化、脚本编写以及与 AI 编码助手的集成

## 💻 系统要求

- **内存**: 至少 1GB RAM
- **存储**: 至少 500MB 可用空间
- **网络**: 需要互联网连接以访问 MCP 服务器

## 🔧 使用方法

1. 在1Panel中安装应用后，配置以下参数：
   - Web界面端口：默认为6274，可根据需要更改

2. 启动应用后，通过浏览器访问 `http://您的IP:端口`

3. 在 Web UI 中配置 MCP 服务器连接信息：
   - 输入 MCP 服务器的 URL
   - 选择认证类型（无认证、Bearer Token 或 OAuth）
   - 配置相应的认证信息

4. 使用界面探索和测试 MCP 服务器的功能：
   - 查看可用的工具和资源
   - 发送请求并查看响应
   - 调试 MCP 协议交互

## 🔍 功能详解

### 连接管理

MCP Inspector 允许您连接到任何兼容 MCP 协议的服务器。您可以：

- 保存多个服务器配置
- 快速切换不同的服务器
- 测试连接状态和响应时间

### 能力探索

探索 MCP 服务器提供的各种能力：

- 查看可用的工具列表及其参数
- 浏览可访问的资源
- 测试提示模板

### 认证处理

支持多种认证方式：

- 无认证模式
- Bearer Token 认证
- 完整的 OAuth 流程，包括授权和令牌刷新

### 请求/响应检查

详细分析 MCP 协议交互：

- 查看原始请求和响应
- 格式化 JSON 数据
- 追踪请求时间线

## 🛠️ 配置选项

MCP Inspector 提供了多种配置选项，可以通过 `config.yaml` 文件进行设置：

```yaml
# 服务器设置
server:
  port: 3000
  https: false

# 客户端设置
client:
  defaultConnection:
    url: "http://localhost:8000"
    authType: "none"

# 日志设置
logging:
  level: "info"
  console: true
```

## 📚 更多信息

- [GitHub 仓库](https://github.com/modelcontextprotocol/inspector)
- [Model Context Protocol 规范](https://github.com/modelcontextprotocol/spec)
- [MCP 开发者文档](https://github.com/modelcontextprotocol/inspector/wiki)
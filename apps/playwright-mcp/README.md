# Playwright MCP

Playwright MCP 是一个基于模型上下文协议 (MCP) 的服务器，它使用 Playwright 提供浏览器自动化功能。该服务器让大语言模型 (LLM) 能够通过结构化的可访问性快照与网页交互，而无需使用截图或视觉调优模型。

![](https://cdn.jsdelivr.net/gh/xiaoY233/PicList@main/public/assets/Playwright-MCP.png)

![](https://img.shields.io/badge/Copyright-arch3rPro-ff9800?style=flat&logo=github&logoColor=white)


## ✨ 核心特性

- **🚀 快速轻量**：使用 Microsoft 官方 MCP 镜像，预配置完整
- **🤖 LLM 友好**：无需视觉模型，完全基于结构化数据操作
- **🎯 确定性工具应用**：避免基于截图方法常见的模糊性
- **🌐 多浏览器支持**：支持 Chromium、Firefox 和 WebKit
- **🔧 高度可配置**：支持多种配置选项和运行模式
- **📦 官方镜像**：使用 `mcr.microsoft.com/playwright/mcp` 官方镜像

## 📋 系统要求

- Node.js 18 或更新版本
- Docker 环境
- 1Panel 控制面板

## 🚀 快速开始

### 1Panel 部署

1. 在 1Panel 应用商店中搜索 "Playwright MCP"
2. 点击安装并配置以下参数：
   - **端口**：服务访问端口（默认：8931）
   - **浏览器类型**：选择 Chromium、Firefox 或 WebKit
   - **无头模式**：是否启用无头模式运行
   - **视窗大小**：浏览器视窗尺寸（格式：宽度,高度）
   - **用户代理**：自定义浏览器用户代理字符串

3. 点击确认安装

### 访问服务

安装完成后，您可以通过以下方式访问：

- **HTTP 端点**：`http://your-server-ip:port/mcp`
- **健康检查**：`http://your-server-ip:port/mcp`

## ⚙️ 配置说明

### 浏览器类型

- **Chromium**：推荐选择，兼容性最佳
- **Firefox**：Gecko 引擎，适合特定测试需求
- **WebKit**：Safari 内核，适合 Apple 生态测试

### 运行模式

- **有头模式**：显示浏览器界面，适合调试
- **无头模式**：后台运行，适合生产环境，性能更佳

### 视窗配置

- 格式：`宽度,高度`（如：1920,1080）
- 影响页面渲染和响应式布局
- 建议使用常见分辨率

## 🔌 MCP 客户端集成

### VS Code

```json
{
  "mcpServers": {
    "playwright": {
      "url": "http://your-server:8931/mcp"
    }
  }
}
```

### Claude Desktop

```json
{
  "mcpServers": {
    "playwright": {
      "url": "http://your-server:8931/mcp"
    }
  }
}
```

## 📊 性能优化

- 启用无头模式可减少资源消耗
- 选择合适的视窗大小避免不必要的渲染
- 定期清理用户数据目录
- 监控容器资源使用情况

## 🐛 故障排除

### 常见问题

1. **服务无法启动**
   - 检查端口是否被占用
   - 确认 Docker 容器状态
   - 查看容器日志

2. **浏览器启动失败**
   - 验证浏览器类型配置
   - 检查系统资源是否充足
   - 确认依赖安装完成

3. **连接问题**
   - 检查防火墙设置
   - 验证网络配置
   - 确认端口映射正确

### 日志查看

```bash
# 查看容器日志
docker logs playwright-mcp

# 实时跟踪日志
docker logs -f playwright-mcp
```

## 🔗 相关链接

- [官方项目](https://github.com/microsoft/playwright-mcp)
- [Playwright 文档](https://playwright.dev/)
- [MCP 协议规范](https://modelcontextprotocol.io/introduction)
- [1Panel 文档](https://1panel.cn/docs/)

## 📄 许可证

本项目遵循原项目的开源许可证。详细信息请参考 [官方仓库](https://github.com/microsoft/playwright-mcp)。

## 🤝 贡献

欢迎提交 Issue 和 Pull Request 来帮助改进这个应用配置。
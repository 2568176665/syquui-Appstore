
# Blinko - 开源、自托管的笔记应用

Blinko 是一个创新的开源项目，专为那些想要快速捕捉和组织灵感的人设计。它允许用户在灵感闪现的瞬间无缝记录想法，确保不错过任何创意火花。

![](https://cdn.jsdelivr.net/gh/xiaoY233/PicList@main/public/assets/Blinko.png)

![](https://img.shields.io/badge/Copyright-arch3rPro-ff9800?style=flat&logo=github&logoColor=white)

## 使用方式

1. 安装时，请将应用配置中的IP地址由1.2.3.4 改为您的宿主机IP
2. blimko不提供默认账号和密码，请访问http://1.2.3.4:1111 注册后登录

## 🚀主要特性
- 🤖**AI 增强笔记检索**：通过 Blinko 的先进 AI 驱动的 RAG（检索增强生成）技术，你可以使用自然语言查询快速搜索和访问笔记，轻松找到所需内容。支持 OpenAI、Azure OpenAI 和 Ollama。

- 🔒**数据所有权**：你的隐私至关重要。所有笔记和数据都安全存储在你的自托管环境中，确保对信息的完全控制。

- 🚀**高效快速**：即时捕捉想法并以纯文本形式存储以便于访问，完全支持 Markdown 格式，便于快速排版和分享。

- 💡**轻量架构，多端支持**：基于 Tauri 构建的 Blinko 采用简洁轻量的架构，在保持卓越速度和效率的同时，并且支持Macos,Windows,Android,Linux等多平台。

- 🔓**开放协作**：作为开源项目，Blinko 欢迎社区贡献。所有代码都在 GitHub 上公开透明，培养协作和持续改进的精神。

## 💡 Demo

[在线演示](https://demo.blinko.space) •
[文档](https://docs.blinko.space/introduction) •

在线演示账号: 

- username:blinko 
- password:blinko

## 🤖 AI 模型支持
### OpenAI
- 支持 OpenAI API
- 支持自定义 API 地址
- 支持 Azure OpenAI

### Ollama
- 支持本地部署
- 默认地址：http://127.0.0.1:11434
- 支持所有 Ollama 模型
- 完全免费，无需 API Key

## 环境配置

您可以通过设置不同的选项在运行时配置Blinko服务器。这些选项既可以作为环境变量定义，也可以作为命令行参数在启动服务器时指定。如果两种方法同时使用，命令行参数将优先于环境变量。以下是可用的配置选项列表：

| 环境变量               | 描述                                           |
|------------------------|------------------------------------------------|
| NEXTAUTH_URL           | 指定应用程序的基础URL，通常是部署站点的根URL，用于身份验证回调和重定向。 |
| NEXT_PUBLIC_BASE_URL   | 定义应用程序的公共基础URL，用作前端和API请求的基础路径。 |
| NEXTAUTH_SECRET        | 用于加密会话和身份验证令牌的密钥，以确保用户数据的安全性。 |
| DATABASE_URL           | 数据库连接URL，用于连接和访问Blinko的数据库。 |
# GPT-Load

一个高性能、企业级的 AI 接口透明代理服务，专门为需要集成多种 AI 服务的企业和开发者设计。采用 Go 语言开发，具备智能密钥管理、负载均衡和完善的监控功能，专为高并发生产环境而设计。

![](https://cdn.jsdelivr.net/gh/xiaoY233/PicList@main/public/assets/GPT-Load.png)

![](https://img.shields.io/badge/Copyright-arch3rPro-ff9800?style=flat&logo=github&logoColor=white)

详细请查看[官方文档](https://www.gpt-load.com/docs)


## 功能特性

- **透明代理**: 完全保留原生 API 格式，支持 OpenAI、Google Gemini 和 Anthropic Claude 等多种格式
- **智能密钥管理**: 高性能密钥池，支持分组管理、自动轮换和故障恢复
- **负载均衡**: 支持多上游端点的加权负载均衡，提升服务可用性
- **智能故障处理**: 自动密钥黑名单管理和恢复机制，确保服务连续性
- **动态配置**: 系统设置和分组配置支持热重载，无需重启即可生效
- **企业级架构**: 分布式主从部署，支持水平扩展和高可用
- **现代化管理**: 基于 Vue 3 的 Web 管理界面，直观易用
- **全面监控**: 实时统计、健康检查、详细请求日志
- **高性能设计**: 零拷贝流式传输、连接池复用、原子操作
- **生产就绪**: 优雅关闭、错误恢复、完善的安全机制
- **双重认证体系**: 管理端与代理端认证分离，代理认证支持全局和分组级别密钥

## 支持的 AI 服务

GPT-Load 作为透明代理服务，完整保留各 AI 服务商的原生 API 格式：

- **OpenAI 格式**: 官方 OpenAI API、Azure OpenAI、以及其他 OpenAI 兼容服务
- **Google Gemini 格式**: Gemini Pro、Gemini Pro Vision 等模型的原生 API
- **Anthropic Claude 格式**: Claude 系列模型，支持高质量的对话和文本生成

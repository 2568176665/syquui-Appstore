# GPT-Load

A high-performance, enterprise-grade AI API transparent proxy service designed specifically for enterprises and developers who need to integrate multiple AI services. Built with Go, featuring intelligent key management, load balancing, and comprehensive monitoring capabilities, designed for high-concurrency production environments.

![](https://cdn.jsdelivr.net/gh/xiaoY233/PicList@main/public/assets/GPT-Load.png)

![](https://img.shields.io/badge/Copyright-arch3rPro-ff9800?style=flat&logo=github&logoColor=white)

For detailed information, please check the [Official Documentation](https://www.gpt-load.com/docs)

## Features

- **Transparent Proxy**: Fully preserves native API formats, supporting OpenAI, Google Gemini, Anthropic Claude, and other formats
- **Intelligent Key Management**: High-performance key pool with group management, automatic rotation, and fault recovery
- **Load Balancing**: Supports weighted load balancing across multiple upstream endpoints to improve service availability
- **Smart Fault Handling**: Automatic key blacklist management and recovery mechanism to ensure service continuity
- **Dynamic Configuration**: System settings and group configurations support hot reload, taking effect without restart
- **Enterprise Architecture**: Distributed master-slave deployment with horizontal scaling and high availability support
- **Modern Management**: Vue 3-based web management interface, intuitive and user-friendly
- **Comprehensive Monitoring**: Real-time statistics, health checks, detailed request logging
- **High-Performance Design**: Zero-copy streaming, connection pool reuse, atomic operations
- **Production Ready**: Graceful shutdown, error recovery, comprehensive security mechanisms
- **Dual Authentication System**: Separation of management and proxy authentication, proxy authentication supports global and group-level keys

## Supported AI Services

GPT-Load serves as a transparent proxy service, fully preserving the native API formats of various AI service providers:

- **OpenAI Format**: Official OpenAI API, Azure OpenAI, and other OpenAI-compatible services
- **Google Gemini Format**: Native API for Gemini Pro, Gemini Pro Vision, and other models
- **Anthropic Claude Format**: Claude series models, supporting high-quality conversation and text generation

## Quick Start

### Default Configuration

After deployment, access the service through your web browser to begin setup. For first-time use, it's recommended to:

1. Configure API keys for different AI service providers
2. Set up load balancing and failover policies  
3. Configure monitoring and logging preferences
4. Test the proxy endpoints with your applications

### API Integration

GPT-Load maintains full compatibility with original AI service APIs, allowing seamless integration:

- Use your existing OpenAI SDK/libraries
- Simply change the base URL to your GPT-Load instance
- All request/response formats remain unchanged
- Authentication handled transparently

## Core Capabilities

### Intelligent Key Management

- **Key Pool**: Centralized management of API keys across multiple providers
- **Auto Rotation**: Intelligent key switching based on usage quotas and rate limits
- **Fault Recovery**: Automatic detection and recovery of failed keys
- **Group Management**: Organize keys by project, team, or usage patterns

### Load Balancing & High Availability

- **Multi-Upstream Support**: Distribute requests across multiple AI service endpoints
- **Weighted Routing**: Configure traffic distribution based on endpoint capacity
- **Health Monitoring**: Continuous endpoint health checks and automatic failover
- **Circuit Breaker**: Prevent cascade failures with intelligent request routing

### Monitoring & Analytics

- **Real-time Metrics**: Request rates, response times, error rates, and usage statistics
- **Detailed Logging**: Comprehensive request/response logging for debugging and audit
- **Health Dashboard**: Visual monitoring of system status and performance metrics
- **Alert System**: Configurable alerts for system anomalies and threshold breaches

### Security & Compliance

- **Authentication**: Dual-level authentication for management and API access
- **Rate Limiting**: Configurable rate limits per key, user, or endpoint
- **Access Control**: Fine-grained permissions and access policies
- **Data Privacy**: No request content logging, ensuring data privacy compliance

## Architecture

### Distributed Deployment

- **Master-Slave Architecture**: Scalable deployment with automatic failover
- **Horizontal Scaling**: Add instances dynamically based on load requirements
- **State Synchronization**: Consistent configuration and state across instances
- **Zero-Downtime Updates**: Rolling updates without service interruption

### Performance Optimization

- **Connection Pooling**: Efficient connection reuse for upstream services
- **Streaming Support**: Zero-copy streaming for large responses
- **Caching**: Intelligent response caching where appropriate
- **Async Processing**: Non-blocking request handling for maximum throughput

## Related Links

- **Official Website**: [https://www.gpt-load.com](https://www.gpt-load.com)
- **GitHub Repository**: [https://github.com/tbphp/gpt-load](https://github.com/tbphp/gpt-load)
- **Official Documentation**: [https://www.gpt-load.com/docs](https://www.gpt-load.com/docs)
- **API Reference**: [https://www.gpt-load.com/docs/api](https://www.gpt-load.com/docs/api)

---
For detailed configuration and usage instructions, please refer to [GPT-Load Official Documentation](https://www.gpt-load.com/docs).
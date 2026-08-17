<h1 align="center">ChatGPT Adapter</h1>

<div align="center">
  <img src="logo.png" alt="ChatGPT Adapter Logo" width="120" height="120">
</div>

<div align="center">
  <strong>Multiple AI Chat Interfaces Adapted to OpenAI Standard API</strong>
</div>

<br>

## 📝 Introduction

ChatGPT Adapter is an open-source project that adapts multiple AI chat reverse interfaces to the OpenAI API standard interface server. This service integrates chat interfaces from Coze, Bing Copilot, Cursor, Windsurf, Deepseek, You.com, Grok, and more, making them conform to the OpenAI API standard for easy and unified developer access.

![](https://img.shields.io/badge/Copyright-arch3rPro-ff9800?style=flat&logo=github&logoColor=white)


## ✨ Core Features

- 🚀 **High-speed Streaming Output** - Real-time streaming responses for smooth conversation experience
- 💬 **Multi-turn Conversation Support** - Complete context memory and multi-turn dialogue capabilities
- 🔌 **OpenAI API Compatible** - Fully compatible with OpenAI API format, seamless replacement
- 🎯 **Multiple Model Integration** - Support for 10+ mainstream AI services
- 🛡️ **Security Authentication** - API key authentication and IP whitelist support
- ⚡ **High-performance Caching** - Built-in caching mechanism for improved response speed
- 📊 **Detailed Logging** - Complete request logs and error tracking

## 🚀 Supported AI Services

| Service | Supported Models | Status | Notes |
|---------|------------------|--------|-------|
| **Coze International** | Claude-3.5-Sonnet, GPT-4o, etc. | ✅ Stable | Supports WebSDK and Bot ID methods |
| **Bing Copilot** | GPT-4 Turbo | 🔧 In Development | Requires valid Bing Cookie |
| **Cursor Editor** | Claude-3.5-Sonnet, GPT-4o, etc. | ✅ Stable | Supports multiple programming models |
| **Windsurf Editor** | Claude-3.5-Sonnet, GPT-4o, etc. | ✅ Stable | AI programming assistant by Codeium |
| **Deepseek** | Deepseek-Chat, Deepseek-Reasoner | ✅ Stable | Excellent domestic AI model |
| **You.com** | GPT-4, Claude-3.5, etc. | ✅ Stable | Supports multiple mainstream models |
| **Grok** | Grok-2, Grok-3 | ✅ Stable | AI assistant from X platform |
| **LMSYS Arena** | Various open-source models | ✅ Stable | Academic research platform |
| **Qodo AI** | Programming-specific models | ✅ Stable | Formerly Codium, focused on code generation |
| **Huggingface** | Stable Diffusion, etc. | ✅ Stable | Mainly for image generation |

## 🔧 1Panel Installation Guide

### 1. Application Installation

1. Search for "ChatGPT Adapter" in the 1Panel App Store
2. Click install and wait for Docker image download
3. Configure application parameters (port, storage path, etc.)
4. Start the application

### 2. Configuration File Setup

After installation, create a configuration file. Navigate to the application directory in 1Panel file manager:

```
/opt/1panel/apps/chatgpt-adapter/chatgpt-adapter/latest/
```

Create or edit the `config.yaml` file:

```yaml
# Basic service configuration
port: 8080
host: "0.0.0.0"
debug: false
timeout: 300
cors: true

# Coze configuration example (recommended)
coze:
  websdk:
    model: claude-35-sonnet-200k
    system: "You are a helpful AI assistant"
    bot: custom-assistant
    accounts:
      - email: "your_email@gmail.com"
        password: "your_password"
        validate: "your_email@gmail.com"

# Deepseek configuration example
deepseek:
  cookie: 'your_deepseek_cookie_here'

# For more configurations, refer to config.yaml.example file
```

### 3. Authentication Information

#### Coze Configuration
- Visit [coze.com](https://www.coze.com) to register an account
- Register with Gmail (only email verification login supported)
- Fill in email and password in the configuration file

#### Deepseek Configuration
- Visit [deepseek.com](https://www.deepseek.com) and log in
- Press F12 to open developer tools, check network requests
- Copy Cookie value to configuration file

#### Other Service Configurations
For detailed Cookie acquisition methods, refer to: [Official Configuration Documentation](https://bincooo.github.io/chatgpt-adapter)

### 4. Restart Application

After configuration, restart the ChatGPT Adapter application in 1Panel to apply the settings.

## 🌐 API Usage

### Basic Call

```bash
curl -X POST http://your-server:8080/v1/chat/completions \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer your_api_key" \
  -d '{
    "model": "coze/websdk",
    "messages": [
      {
        "role": "user",
        "content": "Hello, please introduce yourself"
      }
    ],
    "stream": true
  }'
```

### Supported Model List

```bash
# Get available model list
curl http://your-server:8080/v1/models
```

### Common Model Identifiers

- `coze/websdk` - Coze WebSDK mode
- `deepseek-chat` - Deepseek chat model
- `cursor/claude-3-5-sonnet-20241022` - Cursor Claude model
- `windsurf/claude-3-5-sonnet` - Windsurf Claude model
- `you/gpt_4o` - You.com GPT-4o model
- `grok-2` - Grok second generation model

## 🔒 Security Configuration

### API Key Authentication

```yaml
auth:
  keys:
    - "sk-your-custom-api-key-here"
    - "sk-another-api-key-here"
```

### IP Whitelist

```yaml
auth:
  whitelist:
    - "127.0.0.1"
    - "192.168.1.0/24"
    - "your-server-ip"
```

### Rate Limiting

```yaml
rate_limit:
  requests_per_minute: 60
  requests_per_hour: 1000
```

## 📊 Monitoring and Logging

### Log Configuration

```yaml
log:
  level: "info"
  file: "./logs/adapter.log"
  max_size: 100
  max_backups: 5
  max_age: 30
```

### Health Check

```bash
# Check service status
curl http://your-server:8080/health

# View service information
curl http://your-server:8080/v1/models
```

## 🛠️ Troubleshooting

### Common Issues

1. **Service Won't Start**
   - Check if port is occupied
   - Verify configuration file format
   - Check Docker container logs

2. **Model Call Failure**
   - Verify Cookie validity
   - Check network connection
   - Confirm model identifier is correct

3. **Authentication Failure**
   - Check API key configuration
   - Verify IP is in whitelist
   - Confirm request header format

### Log Viewing

View application logs in 1Panel:
```bash
# View real-time logs
docker logs -f chatgpt-adapter

# View error logs
docker logs chatgpt-adapter 2>&1 | grep ERROR
```

## 📚 Advanced Configuration

### Proxy Settings

```yaml
# HTTP proxy
proxy: "http://127.0.0.1:7890"

# SOCKS5 proxy
proxy: "socks5://127.0.0.1:1080"
```

### Cache Configuration

```yaml
cache:
  type: "memory"
  ttl: 3600
  # Redis cache
  # redis:
  #   addr: "localhost:6379"
  #   password: ""
  #   db: 0
```

### Custom Models

```yaml
# Add custom model mapping
models:
  custom-gpt4:
    type: "coze"
    model: "coze/your-bot-id-xxxxx-1000-w"
```

## 🔗 Related Links

- **Project Homepage**: [GitHub Repository](https://github.com/bincooo/chatgpt-adapter)
- **Official Documentation**: [Configuration Documentation](https://bincooo.github.io/chatgpt-adapter)
- **Issue Reporting**: [Issues Page](https://github.com/bincooo/chatgpt-adapter/issues)
- **Changelog**: [Release Page](https://github.com/bincooo/chatgpt-adapter/releases)

## 📄 License

This project is open-sourced under the MIT License. For details, see the [LICENSE](https://github.com/bincooo/chatgpt-adapter/blob/main/LICENSE) file.

## 🤝 Contributing

Issues and Pull Requests are welcome to help improve the project!

---

<div align="center">
  <strong>If this project helps you, please give it a ⭐️ for support!</strong>
</div>

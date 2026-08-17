<h1 align="center">ChatGPT Adapter</h1>
<div align="center">
  <strong>多款AI聊天接口适配到OpenAI标准接口</strong>
</div>

<br>

## 📝 简介

ChatGPT Adapter是一个开源项目，将多款AI聊天逆向接口适配到OpenAI API标准接口服务端。该服务集成了Coze、Bing Copilot、Cursor、Windsurf、Deepseek、You.com、Grok等多款AI的聊天接口，使其符合OpenAI API标准，方便开发者统一调用。

![](https://img.shields.io/badge/Copyright-arch3rPro-ff9800?style=flat&logo=github&logoColor=white)


## ✨ 核心特性

- 🚀 **高速流式输出** - 支持实时流式响应，提供流畅的对话体验
- 💬 **多轮对话支持** - 完整的上下文记忆和多轮对话能力
- 🔌 **OpenAI API兼容** - 完全兼容OpenAI API格式，无缝替换
- 🎯 **多模型接入** - 支持10+种主流AI服务接入
- 🛡️ **安全认证** - 支持API密钥认证和IP白名单
- ⚡ **高性能缓存** - 内置缓存机制，提升响应速度
- 📊 **详细日志** - 完整的请求日志和错误追踪

## 🚀 支持的AI服务

| 服务名称 | 支持模型 | 状态 | 说明 |
|---------|---------|------|------|
| **Coze国际版** | Claude-3.5-Sonnet, GPT-4o等 | ✅ 稳定 | 支持WebSDK和Bot ID两种方式 |
| **Bing Copilot** | GPT-4 Turbo | 🔧 开发中 | 需要有效的Bing Cookie |
| **Cursor Editor** | Claude-3.5-Sonnet, GPT-4o等 | ✅ 稳定 | 支持多种编程模型 |
| **Windsurf Editor** | Claude-3.5-Sonnet, GPT-4o等 | ✅ 稳定 | Codeium提供的AI编程助手 |
| **Deepseek** | Deepseek-Chat, Deepseek-Reasoner | ✅ 稳定 | 国产优秀AI模型 |
| **You.com** | GPT-4, Claude-3.5等 | ✅ 稳定 | 支持多种主流模型 |
| **Grok** | Grok-2, Grok-3 | ✅ 稳定 | X平台的AI助手 |
| **LMSYS Arena** | 多种开源模型 | ✅ 稳定 | 学术研究平台 |
| **Qodo AI** | 编程专用模型 | ✅ 稳定 | 原Codium，专注代码生成 |
| **Huggingface** | Stable Diffusion等 | ✅ 稳定 | 主要用于图像生成 |

## 🔧 1Panel安装使用

### 1. 应用安装

1. 在1Panel应用商店中搜索"ChatGPT Adapter"
2. 点击安装，等待Docker镜像拉取完成
3. 配置应用参数（端口、存储路径等）
4. 启动应用

### 2. 配置文件设置

安装完成后，需要创建配置文件。在1Panel文件管理中进入应用目录：

```
/opt/1panel/apps/chatgpt-adapter/chatgpt-adapter/latest/
```

创建或编辑`config.yaml`文件：

```yaml
# 基础服务配置
port: 8080
host: "0.0.0.0"
debug: false
timeout: 300
cors: true

# Coze配置示例（推荐）
coze:
  websdk:
    model: claude-35-sonnet-200k
    system: "你是一个有用的AI助手"
    bot: custom-assistant
    accounts:
      - email: "your_email@gmail.com"
        password: "your_password"
        validate: "your_email@gmail.com"

# Deepseek配置示例
deepseek:
  cookie: 'your_deepseek_cookie_here'

# 更多配置请参考config.yaml.example文件
```

### 3. 获取认证信息

#### Coze配置
- 访问 [coze.com](https://www.coze.com) 注册账号
- 使用Gmail邮箱注册（仅支持邮箱验证登录）
- 将邮箱和密码填入配置文件

#### Deepseek配置（详细步骤）

**重要提示：Deepseek需要有效的cookie才能正常工作，请按以下步骤获取：**

1. **访问Deepseek官网**
   - 打开浏览器访问 [https://chat.deepseek.com/](https://chat.deepseek.com/)
   - 使用邮箱或手机号注册/登录账号

2. **获取Cookie（关键步骤）**
   - 登录成功后，按F12打开浏览器开发者工具
   - 切换到"Network"（网络）标签页
   - 在聊天界面发送一条测试消息（如"你好"）
   - 在网络请求列表中找到任意一个请求（通常是chat相关的请求）
   - 点击该请求，在右侧面板找到"Request Headers"（请求头）
   - 找到"Cookie"字段，复制完整的cookie值

3. **配置文件设置**
   ```yaml
   deepseek:
     cookie: "这里粘贴从浏览器复制的完整cookie字符串"
     userAgent: 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.3 Safari/605.1.15'
   ```

4. **注意事项**
   - Cookie通常很长，包含多个键值对，请确保复制完整
   - Cookie有时效性，失效后需要重新获取
   - 如果仍然出现认证失败，请确认账号状态正常且有使用权限

**示例Cookie格式：**
```
intercom-device-id-gxxx=...; _ga=...; _gid=...; session_token=...; user_token=...
```

#### 其他服务配置
详细的Cookie获取方法请参考：[官方配置文档](https://bincooo.github.io/chatgpt-adapter)

### 4. 重启应用

配置完成后，在1Panel中重启ChatGPT Adapter应用使配置生效。

## 🌐 API使用方法

### 基础调用

```bash
curl -X POST http://your-server:8080/v1/chat/completions \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer your_api_key" \
  -d '{
    "model": "coze/websdk",
    "messages": [
      {
        "role": "user",
        "content": "你好，请介绍一下自己"
      }
    ],
    "stream": true
  }'
```

### 支持的模型列表

```bash
# 获取可用模型列表
curl http://your-server:8080/v1/models
```

### 常用模型标识符

- `coze/websdk` - Coze WebSDK模式
- `deepseek-chat` - Deepseek聊天模型
- `cursor/claude-3-5-sonnet-20241022` - Cursor Claude模型
- `windsurf/claude-3-5-sonnet` - Windsurf Claude模型
- `you/gpt_4o` - You.com GPT-4o模型
- `grok-2` - Grok第二代模型

## 🔒 安全配置

### API密钥认证

```yaml
auth:
  keys:
    - "sk-your-custom-api-key-here"
    - "sk-another-api-key-here"
```

### IP白名单

```yaml
auth:
  whitelist:
    - "127.0.0.1"
    - "192.168.1.0/24"
    - "your-server-ip"
```

### 限流配置

```yaml
rate_limit:
  requests_per_minute: 60
  requests_per_hour: 1000
```

## 📊 监控与日志

### 日志配置

```yaml
log:
  level: "info"
  file: "./logs/adapter.log"
  max_size: 100
  max_backups: 5
  max_age: 30
```

### 健康检查

```bash
# 检查服务状态
curl http://your-server:8080/health

# 查看服务信息
curl http://your-server:8080/v1/models
```

## 🛠️ 故障排除

### 常见问题

1. **服务无法启动**
   - 检查端口是否被占用
   - 确认配置文件格式正确
   - 查看Docker容器日志

2. **模型调用失败**
   - 验证Cookie是否有效
   - 检查网络连接
   - 确认模型标识符正确

3. **认证失败**
   - 检查API密钥配置
   - 验证IP是否在白名单中
   - 确认请求头格式正确

### 日志查看

在1Panel中查看应用日志：
```bash
# 查看实时日志
docker logs -f chatgpt-adapter

# 查看错误日志
docker logs chatgpt-adapter 2>&1 | grep ERROR
```

## 📚 进阶配置

### 代理设置

```yaml
# HTTP代理
proxy: "http://127.0.0.1:7890"

# SOCKS5代理
proxy: "socks5://127.0.0.1:1080"
```

### 缓存配置

```yaml
cache:
  type: "memory"
  ttl: 3600
  # Redis缓存
  # redis:
  #   addr: "localhost:6379"
  #   password: ""
  #   db: 0
```

### 自定义模型

```yaml
# 添加自定义模型映射
models:
  custom-gpt4:
    type: "coze"
    model: "coze/your-bot-id-xxxxx-1000-w"
```

## 🔗 相关链接

- **项目主页**: [GitHub仓库](https://github.com/bincooo/chatgpt-adapter)
- **官方文档**: [配置文档](https://bincooo.github.io/chatgpt-adapter)
- **问题反馈**: [Issues页面](https://github.com/bincooo/chatgpt-adapter/issues)
- **更新日志**: [Release页面](https://github.com/bincooo/chatgpt-adapter/releases)

## 📄 许可证

本项目基于MIT许可证开源，详情请查看[LICENSE](https://github.com/bincooo/chatgpt-adapter/blob/main/LICENSE)文件。

## 🤝 贡献

欢迎提交Issue和Pull Request来帮助改进项目！

---

<div align="center">
  <strong>如果这个项目对您有帮助，请给个⭐️支持一下！</strong>
</div>

# New-API

🍥新一代大模型网关与AI资产管理系统

> AI模型接口管理与分发系统，支持将多种大模型转为统一格式调用，支持OpenAI、Claude等格式，可供个人或者企业内部管理与分发渠道使用，本项目基于One API二次开发

![](https://cdn.jsdelivr.net/gh/xiaoY233/PicList@main/public/assets/New-API-Homepage.png)

![](https://cdn.jsdelivr.net/gh/xiaoY233/PicList@main/public/assets/New-API-DashBoard.png)

![](https://img.shields.io/badge/Copyright-arch3rPro-ff9800?style=flat&logo=github&logoColor=white)

## 📝 项目说明

> [!NOTE]  
> 本项目为开源项目，在[One API](https://github.com/songquanpeng/one-api)的基础上进行二次开发

> [!IMPORTANT]  
> - 本项目仅供个人学习使用，不保证稳定性，且不提供任何技术支持。
> - 使用者必须在遵循 OpenAI 的[使用条款](https://openai.com/policies/terms-of-use)以及**法律法规**的情况下使用，不得用于非法用途。
> - 根据[《生成式人工智能服务管理暂行办法》](http://www.cac.gov.cn/2023-07/13/c_1690898327029107.htm)的要求，请勿对中国地区公众提供一切未经备案的生成式人工智能服务。

## 📚 文档

详细文档请访问我们的官方Wiki：[https://docs.newapi.pro/](https://docs.newapi.pro/)

也可访问AI生成的DeepWiki:
[![Ask DeepWiki](https://deepwiki.com/badge.svg)](https://deepwiki.com/QuantumNous/new-api)

## ✨ 主要特性

New API提供了丰富的功能，详细特性请参考[特性说明](https://docs.newapi.pro/wiki/features-introduction)：

1. 🎨 全新的UI界面
2. 🌍 多语言支持
3. 💰 支持在线充值功能（易支付）
4. 🔍 支持用key查询使用额度（配合[neko-api-key-tool](https://github.com/Calcium-Ion/neko-api-key-tool)）
5. 🔄 兼容原版One API的数据库
6. 💵 支持模型按次数收费
7. ⚖️ 支持渠道加权随机
8. 📈 数据看板（控制台）
9. 🔒 令牌分组、模型限制
10. 🤖 支持更多授权登陆方式（LinuxDO,Telegram、OIDC）
11. 🔄 支持Rerank模型（Cohere和Jina），[接口文档](https://docs.newapi.pro/api/jinaai-rerank)
12. ⚡ 支持OpenAI Realtime API（包括Azure渠道），[接口文档](https://docs.newapi.pro/api/openai-realtime)
13. ⚡ 支持Claude Messages 格式，[接口文档](https://docs.newapi.pro/api/anthropic-chat)
14. 支持使用路由/chat2link进入聊天界面
15. 🧠 支持通过模型名称后缀设置 reasoning effort：
    1. OpenAI o系列模型
        - 添加后缀 `-high` 设置为 high reasoning effort (例如: `o3-mini-high`)
        - 添加后缀 `-medium` 设置为 medium reasoning effort (例如: `o3-mini-medium`)
        - 添加后缀 `-low` 设置为 low reasoning effort (例如: `o3-mini-low`)
    2. Claude 思考模型
        - 添加后缀 `-thinking` 启用思考模式 (例如: `claude-3-7-sonnet-20250219-thinking`)
16. 🔄 思考转内容功能
17. 🔄 针对用户的模型限流功能
18. 💰 缓存计费支持，开启后可以在缓存命中时按照设定的比例计费：
    1. 在 `系统设置-运营设置` 中设置 `提示缓存倍率` 选项
    2. 在渠道中设置 `提示缓存倍率`，范围 0-1，例如设置为 0.5 表示缓存命中时按照 50% 计费
    3. 支持的渠道：
        - [x] OpenAI
        - [x] Azure
        - [x] DeepSeek
        - [x] Claude

## 模型支持

此版本支持多种模型，详情请参考[接口文档-中继接口](https://docs.newapi.pro/api)：

1. 第三方模型 **gpts** （gpt-4-gizmo-*）
2. 第三方渠道[Midjourney-Proxy(Plus)](https://github.com/novicezk/midjourney-proxy)接口，[接口文档](https://docs.newapi.pro/api/midjourney-proxy-image)
3. 第三方渠道[Suno API](https://github.com/Suno-API/Suno-API)接口，[接口文档](https://docs.newapi.pro/api/suno-music)
4. 自定义渠道，支持填入完整调用地址
5. Rerank模型（[Cohere](https://cohere.ai/)和[Jina](https://jina.ai/)），[接口文档](https://docs.newapi.pro/api/jinaai-rerank)
6. Claude Messages 格式，[接口文档](https://docs.newapi.pro/api/anthropic-chat)
7. Dify，当前仅支持chatflow

## 环境变量配置

详细配置说明请参考[安装指南-环境变量配置](https://docs.newapi.pro/installation/environment-variables)：

- `GENERATE_DEFAULT_TOKEN`：是否为新注册用户生成初始令牌，默认为 `false`
- `STREAMING_TIMEOUT`：流式回复超时时间，默认120秒
- `DIFY_DEBUG`：Dify渠道是否输出工作流和节点信息，默认 `true`
- `FORCE_STREAM_OPTION`：是否覆盖客户端stream_options参数，默认 `true`
- `GET_MEDIA_TOKEN`：是否统计图片token，默认 `true`
- `GET_MEDIA_TOKEN_NOT_STREAM`：非流情况下是否统计图片token，默认 `true`
- `UPDATE_TASK`：是否更新异步任务（Midjourney、Suno），默认 `true`
- `COHERE_SAFETY_SETTING`：Cohere模型安全设置，可选值为 `NONE`, `CONTEXTUAL`, `STRICT`，默认 `NONE`
- `GEMINI_VISION_MAX_IMAGE_NUM`：Gemini模型最大图片数量，默认 `16`
- `MAX_FILE_DOWNLOAD_MB`: 最大文件下载大小，单位MB，默认 `20`
- `CRYPTO_SECRET`：加密密钥，用于加密数据库内容
- `AZURE_DEFAULT_API_VERSION`：Azure渠道默认API版本，默认 `2025-04-01-preview`
- `NOTIFICATION_LIMIT_DURATION_MINUTE`：通知限制持续时间，默认 `10`分钟
- `NOTIFY_LIMIT_COUNT`：用户通知在指定持续时间内的最大数量，默认 `2`
- `ERROR_LOG_ENABLED=true`: 是否记录并显示错误日志，默认`false`
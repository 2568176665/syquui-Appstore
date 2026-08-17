# New API

🍥 Next-Generation Large Model Gateway and AI Asset Management System

> The next-generation LLM gateway and AI asset management system supports multiple languages.

![](https://cdn.jsdelivr.net/gh/xiaoY233/PicList@main/public/assets/New-API-Homepage.png)

![](https://cdn.jsdelivr.net/gh/xiaoY233/PicList@main/public/assets/New-API-DashBoard.png)

![](https://img.shields.io/badge/Copyright-arch3rPro-ff9800?style=flat&logo=github&logoColor=white)

## 📝 Project Description

> [!NOTE]  
> This is an open-source project developed based on [One API](https://github.com/songquanpeng/one-api)

> [!IMPORTANT]  
> - This project is for personal learning purposes only, with no guarantee of stability or technical support.
> - Users must comply with OpenAI's [Terms of Use](https://openai.com/policies/terms-of-use) and **applicable laws and regulations**, and must not use it for illegal purposes.
> - According to the [《Interim Measures for the Management of Generative Artificial Intelligence Services》](http://www.cac.gov.cn/2023-07/13/c_1690898327029107.htm), please do not provide any unregistered generative AI services to the public in China.

## 📚 Documentation

For detailed documentation, please visit our official Wiki: [https://docs.newapi.pro/](https://docs.newapi.pro/)

You can also access the AI-generated DeepWiki:
[![Ask DeepWiki](https://deepwiki.com/badge.svg)](https://deepwiki.com/QuantumNous/new-api)

## ✨ Key Features

New API offers a wide range of features, please refer to [Features Introduction](https://docs.newapi.pro/wiki/features-introduction) for details:

1. 🎨 Brand new UI interface
2. 🌍 Multi-language support
3. 💰 Online recharge functionality (YiPay)
4. 🔍 Support for querying usage quotas with keys (works with [neko-api-key-tool](https://github.com/Calcium-Ion/neko-api-key-tool))
5. 🔄 Compatible with the original One API database
6. 💵 Support for pay-per-use model pricing
7. ⚖️ Support for weighted random channel selection
8. 📈 Data dashboard (console)
9. 🔒 Token grouping and model restrictions
10. 🤖 Support for more authorization login methods (LinuxDO, Telegram, OIDC)
11. 🔄 Support for Rerank models (Cohere and Jina), [API Documentation](https://docs.newapi.pro/api/jinaai-rerank)
12. ⚡ Support for OpenAI Realtime API (including Azure channels), [API Documentation](https://docs.newapi.pro/api/openai-realtime)
13. ⚡ Support for Claude Messages format, [API Documentation](https://docs.newapi.pro/api/anthropic-chat)
14. Support for entering chat interface via /chat2link route
15. 🧠 Support for setting reasoning effort through model name suffixes:
    1. OpenAI o-series models
        - Add `-high` suffix for high reasoning effort (e.g.: `o3-mini-high`)
        - Add `-medium` suffix for medium reasoning effort (e.g.: `o3-mini-medium`)
        - Add `-low` suffix for low reasoning effort (e.g.: `o3-mini-low`)
    2. Claude thinking models
        - Add `-thinking` suffix to enable thinking mode (e.g.: `claude-3-7-sonnet-20250219-thinking`)
16. 🔄 Thinking-to-content functionality
17. 🔄 Model rate limiting for users
18. 💰 Cache billing support, which allows billing at a set ratio when cache is hit:
    1. Set the `Prompt Cache Ratio` option in `System Settings-Operation Settings`
    2. Set `Prompt Cache Ratio` in the channel, range 0-1, e.g., setting to 0.5 means billing at 50% when cache is hit
    3. Supported channels:
        - [x] OpenAI
        - [x] Azure
        - [x] DeepSeek
        - [x] Claude

## Model Support

This version supports multiple models, please refer to [API Documentation-Relay Interface](https://docs.newapi.pro/api) for details:

1. Third-party models **gpts** (gpt-4-gizmo-*)
2. Third-party channel [Midjourney-Proxy(Plus)](https://github.com/novicezk/midjourney-proxy) interface, [API Documentation](https://docs.newapi.pro/api/midjourney-proxy-image)
3. Third-party channel [Suno API](https://github.com/Suno-API/Suno-API) interface, [API Documentation](https://docs.newapi.pro/api/suno-music)
4. Custom channels, supporting full call address input
5. Rerank models ([Cohere](https://cohere.ai/) and [Jina](https://jina.ai/)), [API Documentation](https://docs.newapi.pro/api/jinaai-rerank)
6. Claude Messages format, [API Documentation](https://docs.newapi.pro/api/anthropic-chat)
7. Dify, currently only supports chatflow

## Environment Variable Configuration

For detailed configuration instructions, please refer to [Installation Guide-Environment Variables Configuration](https://docs.newapi.pro/installation/environment-variables):

- `GENERATE_DEFAULT_TOKEN`: Whether to generate initial tokens for newly registered users, default is `false`
- `STREAMING_TIMEOUT`: Streaming response timeout, default is 120 seconds
- `DIFY_DEBUG`: Whether to output workflow and node information for Dify channels, default is `true`
- `FORCE_STREAM_OPTION`: Whether to override client stream_options parameter, default is `true`
- `GET_MEDIA_TOKEN`: Whether to count image tokens, default is `true`
- `GET_MEDIA_TOKEN_NOT_STREAM`: Whether to count image tokens in non-streaming cases, default is `true`
- `UPDATE_TASK`: Whether to update asynchronous tasks (Midjourney, Suno), default is `true`
- `COHERE_SAFETY_SETTING`: Cohere model safety settings, options are `NONE`, `CONTEXTUAL`, `STRICT`, default is `NONE`
- `GEMINI_VISION_MAX_IMAGE_NUM`: Maximum number of images for Gemini models, default is `16`
- `MAX_FILE_DOWNLOAD_MB`: Maximum file download size in MB, default is `20`
- `CRYPTO_SECRET`: Encryption key used for encrypting database content
- `AZURE_DEFAULT_API_VERSION`: Azure channel default API version, default is `2025-04-01-preview`
- `NOTIFICATION_LIMIT_DURATION_MINUTE`: Notification limit duration, default is `10` minutes
- `NOTIFY_LIMIT_COUNT`: Maximum number of user notifications within the specified duration, default is `2`
- `ERROR_LOG_ENABLED=true`: Whether to record and display error logs, default is `false`

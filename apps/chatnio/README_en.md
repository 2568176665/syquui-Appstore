# [Chat Nio](https://chatnio.net)

Chat Nio is a comprehensive AI service management platform that serves as a bridge between AI capabilities and real-world applications. It provides a unified interface for managing multiple AI models, handling complex routing logic, and delivering enterprise-grade features for AI-powered applications.

![](https://cdn.jsdelivr.net/gh/xiaoY233/PicList@main/public/assets/ChatNio.png)

![](https://img.shields.io/badge/Copyright-arch3rPro-ff9800?style=flat&logo=github&logoColor=white)

### 📋 Usage Instructions

#### Default Account Information
- **Administrator Account**: `root`
- **Default Password**: `chatnio123456`

### ✨ Core Features

1. 🤖️ **Rich Model Support**: Multi-model service provider support (OpenAI / Anthropic / Gemini / Midjourney and over 10 format-compatible & private LLM support)
2. 🤯 **Beautiful UI Design**: UI compatible with PC / Pad / Mobile, following [Shadcn UI](https://ui.shadcn.com) & [Tremor Charts](https://blocks.tremor.so) design specifications, rich and beautiful interface design and backend dashboard
3. 🎃 **Complete Markdown Support**: Supports **LaTeX formulas** / **Mermaid mind maps** / table rendering / code highlighting / chart drawing / progress bars and advanced Markdown syntax support
4. 👀 **Multi-theme Support**: Supports multiple theme switching, including **bright mode** for light themes and **dark mode** for dark themes. 👉 [Custom Color Scheme](https://github.com/Deeptrain-Community/chatnio/blob/main/app/src/assets/globals.less)
5. 📚 **Internationalization Support**: Supports internationalization with multi-language switching 🇨🇳 🇺🇸 🇯🇵 🇷🇺 👉 Welcome to contribute translations [Pull Request](https://github.com/Deeptrain-Community/chatnio/pulls) 
6. 🎨 **Text-to-Image Support**: Supports multiple text-to-image models: **OpenAI DALL-E**✅ & **Midjourney** (supports **U/V/R** operations)✅ & Stable Diffusion✅ etc.
7. 📡 **Powerful Conversation Sync**: **Zero-cost cross-device conversation synchronization for users**, supports **conversation sharing** (supports link sharing & save as image & share management), **no need for WebDav / WebRTC dependencies and complex learning costs**
8. 🎈 **Model Marketplace & Preset System**: Supports customizable model marketplace in the backend, providing model introductions, tags and other parameters. Site admins can customize model descriptions according to their needs. Also supports preset system, including **custom presets** and **cloud synchronization** features.
9. 📖 **Rich File Parsing**: **Out-of-the-box**, supports file parsing for **all models** (PDF / Docx / Pptx / Excel / image formats), **supports more cloud image storage solutions** (S3 / R2 / MinIO etc.), **supports OCR image recognition** 👉 See project details [Chat Nio Blob Service](https://github.com/Deeptrain-Community/chatnio-blob-service) (supports Vercel / Docker one-click deployment)
10. 🌏 **Universal Model Web Search**: Based on [SearXNG](https://github.com/searxng/searxng) open source engine, supports Google / Bing / DuckDuckGo / Yahoo / WikiPedia / Arxiv / Qwant and rich search engines, supports safe search mode, content truncation, image proxy, search availability testing and other features.
11. 💕 **Progressive Web App (PWA)**: Supports PWA app & desktop client (desktop client based on [Tauri](https://github.com/tauri-apps/tauri))
12. 🤩 **Complete Backend Management**: Supports beautiful and rich dashboard, announcement & notification management, user management, subscription management, gift code & redemption code management, pricing settings, subscription settings, custom model marketplace, custom site name & logo, SMTP mail settings and other features
13. 🤑 **Multiple Billing Methods**: Supports 💴 **subscription-based** and 💴 **elastic billing** two billing methods. Elastic billing supports usage-based billing / token billing / free billing / anonymous calling and **minimum request points** detection and other powerful features
14. 🎉 **Innovative Model Caching**: Supports enabling model caching: under the same request parameter hash, if previously requested, cached results will be returned directly (cache hits will not be billed), reducing request frequency. Customizable caching models, cache duration, multiple cache result counts and advanced cache settings
15. 🥪 **Additional Features** (discontinued): 🍎 **AI Project Generator** / 📂 **Batch Article Generation** / 🥪 **AI Card Feature** (deprecated)
16. 😎 **Excellent Channel Management**: Self-developed excellent channel algorithms, supports⚡ **multi-channel management**, supports🥳**priority** setting for channel call order, supports🥳**weight** setting for load balancing distribution probability at same priority level, supports🥳**user grouping**, 🥳**automatic failure retry**, 🥳**model redirection**, 🥳**built-in upstream hiding**, 🥳**channel status management** and other powerful **enterprise-grade features**
17. ⭐ **OpenAI API Distribution & Relay System**: Supports calling various large models in **OpenAI API** standard format, integrates powerful channel management features, deploy one site to simultaneously develop B2B and B2C businesses💖
18. 👌 **Quick Upstream Sync**: Channel settings, model marketplace, pricing settings and other configurations can quickly sync upstream sites, modify your own site configuration based on this, quickly build your own site, save time and effort, one-click sync, quick launch
19. 👋 **SEO Optimization**: Supports SEO optimization, supports custom site name, site logo and other SEO optimization settings to make search engines crawl faster, making your site stand out👋
20. 🎫 **Multiple Redemption Code Systems**: Supports multiple redemption code systems, supports gift codes and redemption codes, supports batch generation. Gift codes are suitable for promotional distribution, redemption codes are suitable for card sales. One user can only redeem one code per gift code type, reducing multiple redemptions by one user in promotions😀
21. 🥰 **Commercial-Friendly License**: Uses **Apache-2.0** open source license, commercial secondary development & distribution friendly (please also comply with Apache-2.0 license regulations, do not use for illegal purposes)

### 🔨 Supported Models
1. OpenAI & Azure OpenAI *(✅ Vision ✅ Function Calling)*
2. Anthropic Claude *(✅ Vision ✅ Function Calling)*
3. Google Gemini & PaLM2 *(✅ Vision)*
4. Midjourney *(✅ Mode Toggling ✅ U/V/R Actions)*
5. iFlytek Spark SparkDesk *(✅ Vision ✅ Function Calling)*
6. Zhipu ChatGLM *(✅ Vision)*
7. Tongyi Qwen
8. Tencent Hunyuan
9. Baichuan AI
10. Moonshot AI (👉 OpenAI)
11. DeepSeek AI (👉 OpenAI)
12. ByteDance Skylark *(✅ Function Calling)*
13. Groq Cloud AI
14. OpenRouter (👉 OpenAI)
15. 360 GPT
16. LocalAI / Ollama (👉 OpenAI)

### 👻 OpenAI Compatible API Relay
   - [x] Chat Completions _(/v1/chat/completions)_
   - [x] Image Generation _(/v1/images)_
   - [x] Model List _(/v1/models)_
   - [x] Dashboard Billing _(/v1/billing)_

### Quick Start
1. After successful application deployment, log in using the default account
2. Configure AI provider channels in the admin panel
3. Set model priorities and load balancing strategies
4. Start using the unified AI services

#### Configuration Recommendations
- Recommend changing the default password immediately after first login
- Configure multiple AI providers according to actual needs to ensure service stability
- Set reasonable rate limits and quota management
- Enable monitoring and logging for troubleshooting

### 🔗 Related Links
- [Official Website](https://chatnio.net)
- [Documentation](https://docs.chatnio.net)
- [API Documentation](https://docs.chatnio.net/developers/sdk)
- [GitHub Repository](https://github.com/Deeptrain-Community/chatnio)

## 🛠️ Advanced Features

### Infrastructure & Deployment
- **High Availability Setup**: Multi-region deployments with automatic failover
- **Load Balancing**: Intelligent traffic distribution across multiple instances
- **Disaster Recovery**: Comprehensive backup and recovery strategies
- **Zero-Downtime Updates**: Rolling deployments and blue-green strategies
- **Health Monitoring**: Proactive system health checks and alerting

### Integration & APIs
- **API Integration**: Comprehensive REST and GraphQL APIs
- **Webhook Support**: Real-time event notifications and integrations
- **SSO Integration**: Single Sign-On with enterprise identity providers
- **Third-Party Connectors**: Pre-built integrations with popular platforms
- **Custom Middleware**: Develop custom integration layers

### AI & Model Management
- **Custom Models**: Private model integration and deployment
- **Model Fine-tuning**: Custom model training and optimization
- **A/B Testing**: Intelligent model performance comparison
- **AI Workflow Automation**: Complex AI-driven business process automation
- **Performance Analytics**: Detailed model performance insights

## 📊 Key Benefits

### For Developers
- **Simplified Integration**: Single API for multiple AI providers
- **Reduced Complexity**: No need to manage multiple provider SDKs
- **Cost Efficiency**: Automatic routing to cost-effective providers
- **Rapid Prototyping**: Quick model testing and comparison

### For Businesses
- **Operational Excellence**: Enterprise-grade reliability and monitoring
- **Cost Control**: Transparent pricing and usage analytics
- **Scalability**: Handle growing demand with intelligent load balancing
- **Risk Mitigation**: Provider diversification reduces dependency

### For Enterprises
- **Compliance Ready**: Built-in security and compliance features
- **Custom Solutions**: Tailored deployments for specific requirements
- **Professional Support**: Dedicated support and professional services
- **Strategic Advantage**: Stay competitive with cutting-edge AI capabilities

## 🔗 Related Links
- [Official Website](https://chatnio.net)
- [Documentation](https://docs.chatnio.net)
- [API Documentation](https://docs.chatnio.net/developers/sdk)
- [GitHub Repository](https://github.com/Deeptrain-Community/chatnio)
- [Community Support](http://qm.qq.com/cgi-bin/qm/qr?_wv=1027&k=1mv1Y8SyxnQVvQCoqhmIgVTbwQmkNmvQ&authKey=5KUA9nJPR29nQwjbsYNknN2Fj6cKePkRes%2B1QZy84Dr4GHYVzcvb0yklxiMMNVJN&noverify=0&group_code=749482576)

## 📄 License

This project is licensed under the appropriate open source license. Please refer to the main repository for detailed license information.

---

*Chat Nio - Empowering Your Team to Accelerate Growth through AI*
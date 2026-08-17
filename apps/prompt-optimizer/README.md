# Prompt Optimizer (提示词优化器) 🚀

## 📖 项目简介
Prompt Optimizer 是一款强大的 AI 提示词优化工具，旨在帮助用户轻松编写、优化和测试高质量的提示词。它支持多种主流的大语言模型，并提供直观的可视化界面，让提示词工程变得简单高效。

![](https://cdn.jsdelivr.net/gh/xiaoY233/PicList@main/public/assets/prompt-optimizer.png)

![](https://img.shields.io/badge/Copyright-arch3rPro-ff9800?style=flat&logo=github&logoColor=white)

## ✨ 核心特性
- **智能优化**：一键优化提示词，支持多轮迭代改进，提升AI回复准确度。
- **双模式优化**：支持系统提示词优化和用户提示词优化，满足不同使用场景。
- **对比测试**：支持原始提示词和优化后提示词的实时对比，直观展示优化效果。
- **多模型集成**：支持 OpenAI、Gemini、DeepSeek、智谱 AI、SiliconFlow 等主流 AI 模型，并支持自定义 API。
- **安全架构**：纯客户端处理，数据直接与 AI 服务商交互，不经过中间服务器。
- **访问控制**：支持密码保护功能，保障部署安全。

## ⚙️ API密钥配置
### 方式一：通过界面配置（推荐）
1. 点击界面右上角的"⚙️设置"按钮
2. 选择"模型管理"选项卡
3. 点击需要配置的模型（如OpenAI、Gemini、DeepSeek等）
4. 在弹出的配置框中输入对应的API密钥
5. 点击"保存"即可

支持的模型：OpenAI、Gemini、DeepSeek、Zhipu智谱、SiliconFlow、自定义API（OpenAI兼容接口）

### 方式二：通过环境变量配置
你可以在安装应用时，在表单中直接填写常用的 API 密钥。支持的环境变量如下：
- `VITE_OPENAI_API_KEY`
- `VITE_GEMINI_API_KEY`
- `VITE_DEEPSEEK_API_KEY`
- `VITE_SILICONFLOW_API_KEY`
- `VITE_CUSTOM_API_KEY`
- `VITE_CUSTOM_API_BASE_URL`
- `VITE_CUSTOM_API_MODEL`

## 常见问题 FAQ
- **Q: 为什么配置好 API 密钥后仍然无法连接？**
  A: 大多数情况是由网络或跨域问题（CORS）导致的。如果你的模型服务部署在本地（如 Ollama），请确保正确配置了跨域策略。对于云服务商，如果遇到连接问题，可以尝试在模型设置中开启 Vercel 代理（如果可用）。
- **Q: 如何修改访问密码？**
  A: 你需要重新配置应用，在安装时设置新的密码。

## 相关链接
- 官网: [https://prompt.always200.com/](https://prompt.always200.com/)
- GitHub: [https://github.com/linshenkx/prompt-optimizer](https://github.com/linshenkx/prompt-optimizer)
- 文档: [https://github.com/linshenkx/prompt-optimizer/blob/develop/docs/index.md](https://github.com/linshenkx/prompt-optimizer/blob/develop/docs/index.md)


# Raycast AI OpenRouter 代理

这个项目提供了一个代理服务器，允许Raycast AI使用任何OpenAI兼容的API（如OpenAI、Gemini、OpenRouter等）。这为Raycast AI带来了"自带密钥"(BYOK)功能，意味着你可以使用自己的API密钥和所选提供商的模型。默认情况下，代理配置为使用OpenRouter。

![](https://cdn.jsdelivr.net/gh/xiaoY233/PicList@main/public/assets/Raycast-AI-Openrouter-Proxy.png)

![](https://img.shields.io/badge/Copyright-arch3rPro-ff9800?style=flat&logo=github&logoColor=white)

**无需Raycast Pro订阅！** 🎉

这个代理允许在Raycast内使用自定义模型，包括**AI聊天**、**AI命令**、**快速AI**和**AI预设**，让你在Raycast的原生AI体验中拥有自定义模型和自己API密钥的灵活性。

## 功能

该代理旨在提供在Raycast中使用自定义模型的无缝体验。以下是支持和不支持的功能：

### 支持：

- 🧠 **任何模型**：访问OpenAI兼容提供商提供的各种模型。默认使用OpenRouter。
- 👀 **视觉支持**：使用能够处理图像的模型。
- 🛠️ **AI扩展和MCP**：使用你喜欢的AI扩展和MCP服务器。
- 📝 **系统指令**：提供系统级提示以指导模型行为。
- 📎 **附件**：附加与官方模型相同的所有内容。
- 🔨 **并行工具使用**：同时进行多个工具调用。
- ⚡ **流式传输**：实时获取模型响应。
- 🔤 **聊天标题生成**：自动生成聊天标题。
- 🛑 **流取消**：停止模型的持续响应。

### 部分支持：

- 💭 **显示思考过程**：查看模型的思考过程。
  - 并非所有提供商都支持此功能，因为OpenAI API规范没有为其定义标准。例如，使用OpenRouter时，支持的模型默认始终显示思考过程。其他提供商可能默认不发送，需要通过模型配置中的`extra`字段进行额外设置。

### 不支持：

- 🌐 **远程工具**：某些AI扩展被归类为"远程工具"，不受支持。这些包括网络搜索和图像生成，以及其他一些工具。如果你想要类似的工具，可以使用MCP服务器替代。

## 要求

- Docker
- 你选择的提供商的API密钥（例如OpenRouter）

## 模型配置

代理的行为主要通过项目根目录中的`models.json`文件配置。此文件定义了Raycast可用的模型及其特定设置。每个JSON数组条目代表一个模型，可以包括以下属性：

- `name`：模型名称，将在Raycast中显示。
- `id`：提供商期望格式的模型ID。
- `contextLength`：模型支持的最大上下文长度（以token为单位）。仅影响Raycast的UI，不影响模型本身。
- `capabilities`：表示模型功能的字符串数组。
  - `"vision"`：模型可以处理图像。
  - `"tools"`：模型支持AI扩展和MCP（工具调用）。
- `temperature`：（可选）控制模型的创造性。值在0到2之间。
- `topP`：（可选）另一个控制输出随机性的参数，值在0到1之间。
- `max_tokens`：（可选）模型在单个响应中允许生成的最大token数。
- `extra`：（可选）用于高级、特定于提供商的配置的对象。这些选项直接传递给提供商的API。

### 默认配置

默认models.json中已配置OpenRouter6个模型，其中前四个为免费模型，后两个为收费模型，可根据需求自行修改models.json配置。Openrouter官方模型查询:

[https://openrouter.ai/models](https://openrouter.ai/models)

- Moonshotai Kimi-K2
- DeepSeek V3
- Qwen3 Coder
- DeepSeek-R1-0528
- Gemini 2.5 Flash Thinking
- Claude Sonnet 4

修改models.json后，请重新启动应用或容器。


## 使用方法

1. 在1Panel中安装应用后，配置以下参数：
   - 代理服务器端口：默认为11435，可根据需要更改
   - API密钥：你的API提供商密钥
   - API基础URL：默认为OpenRouter的API端点，可更改为其他OpenAI兼容的API端点

2. 在Raycast设置中，进入AI > Ollama Host并将主机设置为`localhost:11435`（或你配置的端口）。

3. 现在你可以在Raycast中使用自定义模型，享受无需Pro订阅的AI功能！

## 常见问题

### 这与官方Raycast BYOK功能相比如何？

Raycast在v1.100.0中发布了内置的BYOK功能。官方实现与此代理有几点不同：

- 它只支持Anthropic、Google和OpenAI。此代理支持任何OpenAI兼容的提供商。
- 所有消息都通过Raycast的服务器传输。
- 你的API密钥会发送到Raycast的服务器。
- 你对模型及其配置的控制较少。

### 是否需要Raycast Pro订阅才能使用？

不需要，此代理的主要优势之一是无需Raycast Pro订阅即可在Raycast中使用自定义模型。

### 我是否需要安装Ollama？

不需要，你不需要安装Ollama。
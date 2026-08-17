# GPT4Free

GPT4Free是一个开源项目，提供免费的GPT-4和其他大语言模型API接口。它支持多种模型，如GPT-4、Claude、Gemini等，让用户可以免费访问这些强大的AI模型。

![](https://cdn.jsdelivr.net/gh/xiaoY233/PicList@main/public/assets/gpt4free.png)

![](https://cdn.jsdelivr.net/gh/xiaoY233/PicList@main/public/assets/GPT4Free-Model.png)

![](https://img.shields.io/badge/Copyright-arch3rPro-ff9800?style=flat&logo=github&logoColor=white)

## 功能特点

- 支持多种大语言模型，包括GPT-4、Claude、Gemini等
- 提供类似OpenAI的API接口
- 支持文本生成和图像生成
- 内置Web界面，方便用户直接使用
- 支持本地推理和远程API调用

## 版本区别

- latest：最新稳定版
- version：当前最新版本号
- version-slim：当前最新精简版（不包含远程桌面进行模型配置）

## 使用方法

安装完成后，可以通过以下方式访问GPT4Free：

1. Web界面：访问 `http://您的IP:8080/chat/` 使用内置的聊天界面
2. API接口：使用 `http://您的IP:1337/v1` 作为API基础URL

## 环境变量

- `OLLAMA_HOST`: Ollama服务器地址，默认为host.docker.internal

## 端口说明

- 8080: Web界面（也可用于API接口）
- 1337: API接口
- 7900: 远程桌面（用于提供者登录）

## 更多信息

- 官方网站：[g4f.dev](https://g4f.dev/)
- GitHub仓库：[github.com/xtekky/gpt4free](https://github.com/xtekky/gpt4free)
- 文档：[g4f.dev/docs](https://github.com/gpt4free/g4f.dev/blob/main/docs)
# MiroFish

群体智能预测引擎：把一份文档、新闻或事件描述抽取成本体与人物画像，再在模拟出来的社交网络里让成百上千个智能体按各自性格互动，观察话题如何扩散，最后生成带证据的预测报告。

- 项目主页：<https://github.com/666ghj/MiroFish>
- 中文说明：<https://github.com/666ghj/MiroFish/blob/main/README-ZH.md>

## 安装前必须准备

MiroFish 的后端在启动时会校验配置，缺少下面两项会直接退出，容器无法启动：

| 配置 | 说明 |
| --- | --- |
| 大模型 API 密钥 | 任意 OpenAI 兼容接口的密钥。默认地址与模型为阿里百炼的 `qwen-plus`，可改成任意兼容服务 |
| Zep Cloud 密钥 | 记忆图谱使用 [Zep Cloud](https://app.getzep.com/)，每月免费额度即可支撑简单使用。MiroFish 只支持 Zep Cloud，不支持自建 Zep（`ZEP_API_URL` 会被判为配置错误） |

## 访问

安装完成后打开 `http://<服务器 IP>:3000`。

后端 Flask 监听容器内的 5001 端口，前端开发服务器把 `/api` 反向代理到它，因此**只需要暴露 3000**；直接调用接口时走 `http://<服务器 IP>:3000/api/...` 即可，无需额外开放 5001。

## 数据

- 上传的文档与模拟结果保存在 `./data/uploads`（容器内 `/app/backend/uploads`），包括 `uploads/simulations` 下的模拟数据。
- 该目录是唯一的持久化状态，升级或更换版本都会保留。

## 注意

- **消耗较大。** 一次模拟会进行多轮多智能体的模型调用，建议先用 40 轮以内的模拟试跑，确认成本后再放大。
- 容器以 `npm run dev` 同时拉起前后端，这是上游镜像的既定形态；它不是生产级静态站点，首次启动需要 1 分钟左右，健康检查的 `start_period` 已放宽到 90 秒。
- 需要「加速模型」时，可在 Compose 里追加 `LLM_BOOST_API_KEY`、`LLM_BOOST_BASE_URL`、`LLM_BOOST_MODEL_NAME` 三个环境变量。**不使用就不要写**：上游要求这三项要么齐全要么完全不出现。
- 上传文件上限 50 MB，支持 `pdf`、`md`、`txt`、`markdown`。

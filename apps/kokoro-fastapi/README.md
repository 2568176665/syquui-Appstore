# Kokoro-FastAPI

把 [Kokoro-82M](https://huggingface.co/hexgrad/Kokoro-82M) 语音模型封装成 OpenAI 兼容的语音合成服务。任何 OpenAI SDK 客户端都能直接调用，附带可试听的网页播放器。

- 项目主页：<https://github.com/remsky/Kokoro-FastAPI>
- 配置说明：<https://github.com/remsky/Kokoro-FastAPI/blob/master/docs/configuration.md>

## 入口

| 路径 | 说明 |
| --- | --- |
| `/v1/audio/speech` | OpenAI 兼容的语音合成接口 |
| `/v1/audio/voices` | 可用音色列表 |
| `/web` | 网页播放器，可直接试听与调参 |
| `/docs` | OpenAPI 文档 |
| `/health` | 健康检查 |

## 调用示例

```python
from openai import OpenAI

client = OpenAI(base_url="http://<服务器 IP>:8880/v1", api_key="not-needed")
response = client.audio.speech.create(
    model="kokoro",
    voice="af_heart",
    input="Hello from Kokoro.",
    response_format="mp3",
)
response.stream_to_file("output.mp3")
```

也可以用 curl：

```bash
curl -X POST http://<服务器 IP>:8880/v1/audio/speech \
  -H 'Content-Type: application/json' \
  -d '{"model":"kokoro","input":"你好，世界","voice":"zf_xiaobei","response_format":"mp3"}' \
  --output output.mp3
```

## 版本选择

安装对话框里的版本决定用哪个镜像：

| 版本目录 | 镜像 | 说明 |
| --- | --- | --- |
| `0.10.0` | `ghcr.io/remsky/kokoro-fastapi-cpu:v0.10.0` | CPU 版本，任意服务器都能跑 |
| `0.10.0-gpu` | `ghcr.io/remsky/kokoro-fastapi-gpu:v0.10.0-cu126` | GPU 版本，需要宿主机装好 NVIDIA 驱动与 NVIDIA Container Toolkit |
| `latest` | `ghcr.io/remsky/kokoro-fastapi-cpu:latest` | 跟随上游最新发布的 CPU 版本 |

GPU 版本通过 `deploy.resources.reservations.devices` 申请 GPU。宿主机没有装 NVIDIA Container Toolkit 时容器会直接启动失败，此时请改用 CPU 版本。

## 数据与持久化

模型权重已经烘焙进镜像（`/app/api/src/models`），本应用不需要挂载任何数据目录，重装或升级不会丢失配置以外的状态。唯一会写盘的是 `return_download_link` 产生的临时音频，位于容器内 `api/temp_files`，随容器重建清理，并按 `MAX_TEMP_DIR_SIZE_MB`（默认 2048）自动裁剪。

## 注意

- **接口默认无鉴权。** 需要保护时可以追加环境变量 `API_KEYS`（JSON 数组，例如 `API_KEYS: '["my-key"]'`），之后 API 与 WebSocket 路由都需要携带该密钥，但网页播放器本身不带密钥，会因此返回 401。
- **WebSocket 路由需要反向代理放行 Upgrade。** 若要让 ElevenLabs / Cartesia 兼容的实时语音接口在 1Panel 反向代理后可用，请在网站配置里启用 WebSocket 支持；只走 `/v1/audio/speech` 的普通调用不需要。
- 单进程推理，`WEB_CONCURRENCY` 默认 1；提高并发会按进程数各加载一份模型，内存占用相应翻倍。
- CPU 版本首次请求会慢一些，`start_period` 已放宽到 60 秒；如果宿主机较慢，健康检查可能需要更长时间才转为 healthy。

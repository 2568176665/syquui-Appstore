# Kokoro-FastAPI

The [Kokoro-82M](https://huggingface.co/hexgrad/Kokoro-82M) speech model behind an OpenAI-compatible text-to-speech API. Any OpenAI SDK client can call it, and a browser player is included for quick listening.

- Project: <https://github.com/remsky/Kokoro-FastAPI>
- Configuration reference: <https://github.com/remsky/Kokoro-FastAPI/blob/master/docs/configuration.md>

## Endpoints

| Path | Purpose |
| --- | --- |
| `/v1/audio/speech` | OpenAI-compatible speech synthesis |
| `/v1/audio/voices` | Available voices |
| `/web` | Browser player for listening and tuning |
| `/docs` | OpenAPI documentation |
| `/health` | Health check |

## Usage

```python
from openai import OpenAI

client = OpenAI(base_url="http://<server-ip>:8880/v1", api_key="not-needed")
response = client.audio.speech.create(
    model="kokoro",
    voice="af_heart",
    input="Hello from Kokoro.",
    response_format="mp3",
)
response.stream_to_file("output.mp3")
```

Or with curl:

```bash
curl -X POST http://<server-ip>:8880/v1/audio/speech \
  -H 'Content-Type: application/json' \
  -d '{"model":"kokoro","input":"Hello world","voice":"af_heart","response_format":"mp3"}' \
  --output output.mp3
```

## Choosing a version

The version picked in the install dialog decides which image runs:

| Version directory | Image | Notes |
| --- | --- | --- |
| `0.10.0` | `ghcr.io/remsky/kokoro-fastapi-cpu:v0.10.0` | CPU build, runs on any server |
| `0.10.0-gpu` | `ghcr.io/remsky/kokoro-fastapi-gpu:v0.10.0-cu126` | GPU build, needs an NVIDIA driver and the NVIDIA Container Toolkit on the host |
| `latest` | `ghcr.io/remsky/kokoro-fastapi-cpu:latest` | CPU build following the newest upstream release |

The GPU build requests a device through `deploy.resources.reservations.devices`. Without the NVIDIA Container Toolkit installed the container fails to start; use the CPU build in that case.

## Data

The model weights are baked into the image (`/app/api/src/models`), so this package mounts no data directory and an upgrade keeps everything outside the container untouched. The only writes are the temporary audio files behind `return_download_link`, kept in `api/temp_files` inside the container, pruned by `MAX_TEMP_DIR_SIZE_MB` (2048 by default) and discarded when the container is recreated.

## Notes

- **The API is unauthenticated by default.** To protect it, add the `API_KEYS` environment variable (a JSON array, e.g. `API_KEYS: '["my-key"]'`). The API and the WebSocket routes then require that key, but the bundled browser player sends none and will get 401.
- **WebSocket routes need upgrade support in the reverse proxy.** For the ElevenLabs / Cartesia compatible realtime routes to work behind a 1Panel reverse proxy, enable WebSocket support in the site configuration. Plain `/v1/audio/speech` calls do not need it.
- Inference is synchronous with `WEB_CONCURRENCY` at 1. Raising it loads one model copy per worker, multiplying memory use.
- The CPU build is slow on the first request; `start_period` is set to 60 seconds. On a slow host the health check may need longer to turn healthy.

# PanSou Cloud Drive Search API

PanSou is a high-performance cloud drive resource search API service that supports Telegram channel and plugin searches. The system is designed with performance and scalability at its core, supporting concurrent searches, intelligent result sorting, and cloud drive type categorization.

![](https://cdn.jsdelivr.net/gh/xiaoY233/PicList@main/public/assets/PanSou.png)

![](https://img.shields.io/badge/Copyright-arch3rPro-ff9800?style=flat&logo=github&logoColor=white)

## Features

- **High-Performance Search**: Concurrent execution of multiple Telegram channels and asynchronous plugin searches, significantly improving search speed; worker pool design for efficient concurrent task management
- **Cloud Drive Type Classification**: Automatic recognition of various cloud drive links, categorized display by type
- **Intelligent Sorting**: Multi-dimensional comprehensive sorting algorithm based on plugin level, time freshness, and priority keywords
- **Async Plugin System**: Support for extending search sources through plugins, supporting "quick response, continuous processing" async search mode, solving the problem of long response times from certain search sources
- **Two-Level Cache**: Sharded memory + sharded disk cache mechanism, greatly improving repeated query speed and concurrent performance

## Supported Cloud Drive Types

Baidu Netdisk (`baidu`), Aliyun Drive (`aliyun`), Quark Drive (`quark`), Tianyi Cloud (`tianyi`), UC Drive (`uc`), Mobile Cloud (`mobile`), 115 Drive (`115`), PikPak (`pikpak`), Xunlei Drive (`xunlei`), 123 Drive (`123`), Magnet Links (`magnet`), eDonkey Links (`ed2k`), Others (`others`)

## MCP Service

### Feature Introduction

PanSou MCP Service is a tool service based on [Model Context Protocol (MCP)](https://modelcontextprotocol.io) that encapsulates PanSou cloud drive search API functionality as tools that can be directly called in MCP-supporting clients (such as Claude Desktop).

Through PanSou MCP Service, you can directly search for cloud drive resources in AI assistants like Claude, greatly improving the convenience of obtaining cloud drive resources.

### Core Functions

1. **Search Cloud Drive Resources (`search_netdisk`)**:
   - Support searching cloud drive resources by keywords
   - Can specify search sources: Telegram channels, plugins, or both combined
   - Can filter results to show only specific types of cloud drive links (such as Baidu Netdisk, Aliyun Drive, Quark Drive, etc.)
   - Support forced cache refresh to get latest data
   - Support passing extension parameters to backend plugins
   - Results can be displayed with detailed information or grouped by cloud drive type

2. **Check Service Health (`check_service_health`)**:
   - Check if the connected PanSou backend service is running normally
   - Get backend service configuration information, such as available Telegram channel lists and plugin lists

3. **Start Backend Service (`start_backend`)**:
   - Automatically start local PanSou Go backend service (if not already running)
   - Wait for service to fully start and become available before processing other requests

4. **Get Static Resource Information (`pansou://` URI scheme)**:
   - Provide static information resources such as available plugin lists, available channel lists, and supported cloud drive type lists

## 📚 API Documentation

### Search API

- Endpoint: `/api/search`
- Method: `POST` / `GET`
- Parameters:
  - `kw`: Search keywords
  - `channels`: Search channels
  - `cloud_types`: Cloud drive type filtering
  - More details in [Project Documentation](https://github.com/fish2018/pansou)

### Health Check API

- Endpoint: `/api/health`
- Method: `GET`

## 🔗 Project Links

- GitHub: https://github.com/fish2018/pansou
- Documentation: https://github.com/fish2018/pansou
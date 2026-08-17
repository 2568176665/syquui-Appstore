# Qdrant

Qdrant 是一个面向 AI 应用的开源向量数据库和向量相似性搜索引擎，适用于语义搜索、推荐系统和 RAG 应用。

## 使用说明

- HTTP API 和 Web UI：`http://服务器地址:HTTP端口`
- Web UI：`http://服务器地址:HTTP端口/dashboard`
- gRPC API：`服务器地址:gRPC端口`
- 数据持久化目录：`./data`
- 安装时会自动生成 `QDRANT_API_KEY`。调用 API 或客户端时，请通过 `api-key` 请求头或客户端配置传入该密钥。

Qdrant 默认通过 HTTP 提供服务。若要将服务暴露到公网，请先使用 1Panel 反向代理配置 HTTPS，避免 API key 在明文连接中传输。
gRPC 端口默认应仅用于可信内网；如果需要对公网提供 gRPC，请使用支持 gRPC 的 TLS 反向代理，或按 Qdrant 官方文档配置 TLS。仅配置普通 HTTP 反向代理不能保护 gRPC 端口。

## 相关链接

- [官方网站](https://qdrant.tech/)
- [GitHub 项目](https://github.com/qdrant/qdrant)
- [官方文档](https://qdrant.tech/documentation/)

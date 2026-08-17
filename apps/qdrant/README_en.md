# Qdrant

Qdrant is an open-source vector database and similarity search engine for AI applications, semantic search, recommendation systems, and RAG workloads.

## Usage

- HTTP API and Web UI: `http://server-address:HTTP-port`
- Web UI: `http://server-address:HTTP-port/dashboard`
- gRPC API: `server-address:gRPC-port`
- Persistent data directory: `./data`
- `QDRANT_API_KEY` is generated during installation. Pass it through the `api-key` request header or your client configuration when accessing the API.

Qdrant is exposed over HTTP by default. If the service is made public, configure an HTTPS reverse proxy in 1Panel first so the API key is not sent over an unencrypted connection.
The gRPC port should be limited to a trusted private network by default. If gRPC must be public, use a gRPC-capable TLS reverse proxy or configure TLS in Qdrant according to the official documentation; a regular HTTP reverse proxy does not secure the gRPC port.

## Links

- [Official Website](https://qdrant.tech/)
- [GitHub Project](https://github.com/qdrant/qdrant)
- [Official Documentation](https://qdrant.tech/documentation/)

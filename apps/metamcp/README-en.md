# MetaMCP

**MetaMCP** is an MCP proxy that allows you to dynamically aggregate MCP servers into a unified MCP server and apply middleware. MetaMCP itself is also an MCP server, so it can easily connect to **any** MCP client.

![](https://cdn.jsdelivr.net/gh/xiaoY233/PicList@main/public/assets/MetaMCP.png)

![](https://img.shields.io/badge/Copyright-arch3rPro-ff9800?style=flat&logo=github&logoColor=white)


## Key Features

- 🏷️ **Group MCP servers into namespaces**, host them as meta-MCP, and assign public endpoints (SSE or Streamable HTTP) with authentication. Switch endpoint namespaces with one click.
- 🎯 **Choose only the tools you need when mixing MCP servers**. Apply other pluggable middleware such as observability, security, etc.
- 🔍 **Enhanced MCP inspector** that supports saving server configurations and checking if MetaMCP endpoints are available locally.
- 🔍 **Elasticsearch for MCP tool selection**.

## Core Concepts

### MCP Server
MCP server configuration that tells MetaMCP how to start an MCP server.

### MetaMCP Namespace
- Group one or more MCP servers into a namespace
- Support enabling/disabling MCP servers at server or tool level
- Apply middleware to process MCP requests and responses at the namespace level

### MetaMCP Endpoint
- Create endpoints and assign namespaces to them
- Multiple MCP servers within a namespace will be aggregated and output as a MetaMCP endpoint
- Optional API Key authentication or MCP Spec 2025-06-18 standard OAuth
- Exposed via SSE or Streamable HTTP transport protocols and OpenAPI endpoints

### Middleware
- Intercept and transform MCP requests and responses at the namespace level
- Built-in example: "Filter inactive tools" - optimize tool context for LLMs

## Use Cases

- As infrastructure, hosting dynamically composed MCP servers through a unified endpoint
- Choose only the tools you need when mixing MCP servers
- Enhanced MCP inspector with support for saving server configurations
- Search engine for MCP tool selection

## More Information

For more details, visit the official documentation: https://docs.metamcp.com
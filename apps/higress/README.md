# Higress

Higress 是阿里巴巴开源的下一代云原生网关，实现了流量网关、微服务网关、安全网关三合一的高集成能力，深度集成 Dubbo、Nacos、Sentinel 等微服务技术栈，能够帮助用户大幅降低网关的部署和运维成本。

![](https://cdn.jsdelivr.net/gh/xiaoY233/PicList@main/public/assets/Higress.png)

![](https://img.shields.io/badge/Copyright-arch3rPro-ff9800?style=flat&logo=github&logoColor=white)

## 简介

Higress 是基于 Istio 和 Envoy 构建的下一代云原生网关，具有以下特点：

- **高性能**：基于 Envoy 构建，提供高性能的数据面能力
- **可扩展**：支持 Wasm、Lua 脚本扩展
- **多协议**：支持 HTTP、HTTPS、HTTP2、gRPC、Dubbo 等多种协议
- **服务发现**：支持 Kubernetes、Nacos、Consul、Eureka 等多种服务发现机制
- **安全防护**：内置 WAF、限流、熔断等安全防护能力

## 使用方法

### 访问管理控制台

安装完成后，可以通过以下地址访问 Higress 的管理控制台：

```
http://your-server-ip:8001/higress-console
```

### 配置网关

1. 登录管理控制台
2. 创建路由规则
3. 配置服务发现
4. 设置安全策略

## 端口说明

- **8080**: HTTP 端口，用于处理 HTTP 请求
- **8443**: HTTPS 端口，用于处理 HTTPS 请求
- **8001**: 管理控制台端口，用于访问 Higress 控制台

## 更多信息

- [官方文档](https://higress.io/zh-cn/docs/overview/what-is-higress)
- [GitHub 仓库](https://github.com/alibaba/higress)
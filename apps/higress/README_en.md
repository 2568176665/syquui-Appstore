# Higress

Higress is Alibaba's next-generation cloud-native gateway that integrates traffic gateway, microservice gateway, and security gateway capabilities. It deeply integrates with microservice technology stacks such as Dubbo, Nacos, and Sentinel, helping users significantly reduce gateway deployment and maintenance costs.

![](https://cdn.jsdelivr.net/gh/xiaoY233/PicList@main/public/assets/Higress.png)

![](https://img.shields.io/badge/Copyright-arch3rPro-ff9800?style=flat&logo=github&logoColor=white)

## Introduction

Higress is built on Istio and Envoy, offering the following features:

- **High Performance**: Built on Envoy, providing high-performance data plane capabilities
- **Extensibility**: Support for Wasm and Lua script extensions
- **Multi-protocol**: Support for HTTP, HTTPS, HTTP2, gRPC, Dubbo, and other protocols
- **Service Discovery**: Support for Kubernetes, Nacos, Consul, Eureka, and other service discovery mechanisms
- **Security Protection**: Built-in WAF, rate limiting, circuit breaking, and other security protection capabilities

## Usage

### Accessing the Management Console

After installation, you can access the Higress management console at:

```
http://your-server-ip:8001/higress-console
```

### Configuring the Gateway

1. Log in to the management console
2. Create routing rules
3. Configure service discovery
4. Set security policies

## Port Information

- **8080**: HTTP port for handling HTTP requests
- **8443**: HTTPS port for handling HTTPS requests
- **8001**: Management console port for accessing the Higress console

## More Information

- [Official Documentation](https://higress.io/en-us/docs/overview/what-is-higress)
- [GitHub Repository](https://github.com/alibaba/higress)
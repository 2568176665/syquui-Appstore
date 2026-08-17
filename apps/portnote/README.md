<div align="center">
    <h1><b>PortNote</b></h1>
    <p>
        轻量级服务器端口管理与可视化工具
        <br />
        <a href="https://github.com/crocofied/PortNote"><strong>GitHub</strong></a>
    </p>
</div>
<br />

> [!提示]
> PortNote 是一款轻量级服务器端口管理与可视化工具，适合资产与端口信息管理，支持多平台部署。

## 主要功能
- 端口信息可视化管理
- 支持多服务器、多端口批量管理
- 端口用途、负责人、备注等信息记录
- 支持端口状态标记（如已用、空闲、保留等）
- 支持导入导出（JSON、Excel）
- 支持 Docker 一键部署
- 支持自定义字段
- 支持多用户协作

## 快速开始
### Docker 部署
```bash
docker run -d \
  -p 8080:8080 \
  -v $PWD/data:/app/data \
  --name portnote \
  crocofied/portnote:latest
```
- 默认访问地址：http://localhost:8080
- 数据将持久化到挂载的 `data` 目录

### 其他部署方式
详见[官方文档](https://github.com/crocofied/PortNote/blob/main/README.md)

## 截图
<p align="center">
<img alt="screenshot" src="https://raw.githubusercontent.com/crocofied/PortNote/main/docs/images/portnote-main.png" width="80%">
</p>

## 常见问题 FAQ
- **Q: 支持哪些平台？**
  A: 支持 Docker、Linux、Windows、MacOS。
- **Q: 如何备份数据？**
  A: 数据默认保存在挂载的 data 目录，直接备份该目录即可。
- **Q: 支持多用户协作吗？**
  A: 支持，可为不同用户分配不同权限。
- **Q: 支持自定义端口字段吗？**
  A: 支持，可在设置中自定义字段。

## 相关链接
- GitHub: https://github.com/crocofied/PortNote
- 官方文档: https://github.com/crocofied/PortNote/blob/main/README.md 
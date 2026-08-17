<div align="center">
    <h1><b>PortNote</b></h1>
    <p>
        Lightweight server port management and visualization tool
        <br />
        <a href="https://github.com/crocofied/PortNote"><strong>GitHub</strong></a>
    </p>
</div>
<br />

> [!NOTE]
> PortNote is a lightweight server port management and visualization tool, suitable for asset and port information management, supporting cross-platform deployment.

## Features
- Visual management of port information
- Batch management for multiple servers and ports
- Record port usage, owner, remarks, etc.
- Mark port status (used, idle, reserved, etc.)
- Import/export (JSON, Excel)
- One-click Docker deployment
- Custom fields supported
- Multi-user collaboration

## Getting Started
### Docker Deployment
```bash
docker run -d \
  -p 8080:8080 \
  -v $PWD/data:/app/data \
  --name portnote \
  crocofied/portnote:latest
```
- Default access: http://localhost:8080
- Data will be persisted in the mounted `data` directory

### Other Deployment Methods
See the [official documentation](https://github.com/crocofied/PortNote/blob/main/README.md) for details.

## Screenshot
<p align="center">
<img alt="screenshot" src="https://raw.githubusercontent.com/crocofied/PortNote/main/docs/images/portnote-main.png" width="80%">
</p>

## FAQ
- **Q: Which platforms are supported?**
  A: Docker, Linux, Windows, MacOS are supported.
- **Q: How to backup data?**
  A: Data is stored in the mounted data directory, just backup this directory.
- **Q: Does it support multi-user collaboration?**
  A: Yes, you can assign different permissions to different users.
- **Q: Can I customize port fields?**
  A: Yes, you can customize fields in the settings.

## Links
- GitHub: https://github.com/crocofied/PortNote
- Documentation: https://github.com/crocofied/PortNote/blob/main/README.md 
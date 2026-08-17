# Playwright

现代 Web 应用自动化测试环境，基于 Microsoft Playwright 构建。支持 Chromium、Firefox 和 WebKit 浏览器，提供完整的端到端测试解决方案。

![](https://cdn.jsdelivr.net/gh/xiaoY233/PicList@main/public/assets/Playwright.png)

![](https://img.shields.io/badge/Copyright-arch3rPro-ff9800?style=flat&logo=github&logoColor=white)

## ✨ 核心特性

- **🚀 快速可靠**：使用 Microsoft 官方 Playwright v1.55.0 镜像
- **🌐 多浏览器支持**：支持 Chromium、Firefox 和 WebKit
- **🎯 精确测试**：Web-first 断言，自动等待和重试
- **📊 丰富报告**：HTML 测试报告，支持跟踪和截图
- **🔧 高度可配置**：灵活的测试配置和环境设置
- **🛡️ 安全稳定**：遵循官方安全最佳实践

## 📋 系统要求

- Docker 环境
- 1Panel 控制面板
- 至少 2GB 可用内存

## 🚀 快速开始

### 1Panel 部署

1. 在 1Panel 应用商店中搜索 "Playwright"
2. 点击安装并配置以下参数：
   - **端口**：Web 服务访问端口（默认：3000）
   - **浏览器类型**：选择默认浏览器引擎
   - **无头模式**：是否启用无头模式运行
   - **视窗尺寸**：浏览器视窗的宽度和高度
   - **用户代理**：自定义浏览器用户代理字符串
   - **用户/组 ID**：容器运行的用户和组标识符

3. 点击确认安装

### 访问服务

安装完成后，您可以通过以下方式访问：

- **管理界面**：`http://your-server-ip:port/`
- **测试报告**：`http://your-server-ip:port/test-results/`
- **测试文件**：`http://your-server-ip:port/tests/`

## ⚙️ 配置说明

### 浏览器类型

- **Chromium**：Google Chrome 内核，推荐选择
- **Firefox**：Mozilla Firefox 引擎
- **WebKit**：Safari 内核，适合移动端测试

### 运行模式

- **有头模式**：显示浏览器界面，适合调试和开发
- **无头模式**：后台运行，适合 CI/CD 和生产环境

### 安全配置

- **用户 ID**：建议使用非 root 用户（默认：1000）
- **组 ID**：对应的用户组（默认：1000）
- 应用自动配置安全沙箱和权限

## 🧪 使用指南

### 创建测试

1. 访问管理界面
2. 点击 "Generate Example Test" 生成示例测试
3. 编辑 `/app/tests/` 目录下的测试文件
4. 使用 TypeScript 或 JavaScript 编写测试

### 示例测试代码

```typescript
import { test, expect } from '@playwright/test';

test('basic test', async ({ page }) => {
  await page.goto('https://playwright.dev/');
  
  // 检查页面标题
  await expect(page).toHaveTitle(/Playwright/);
  
  // 点击链接
  const getStarted = page.getByRole('link', { name: 'Get started' });
  await getStarted.click();
  
  // 验证URL变化
  await expect(page).toHaveURL(/.*intro/);
});
```

### 运行测试

1. 在管理界面点击 "Run All Tests"
2. 或使用命令行：`npx playwright test`
3. 查看生成的 HTML 报告

### 配置文件

应用会自动生成 `playwright.config.ts` 配置文件：

```typescript
export default defineConfig({
  testDir: './tests',
  fullyParallel: true,
  retries: 2,
  reporter: [['html', { outputFolder: './test-results' }]],
  use: {
    trace: 'on-first-retry',
    screenshot: 'only-on-failure',
  },
  projects: [
    { name: 'chromium', use: devices['Desktop Chrome'] },
    { name: 'firefox', use: devices['Desktop Firefox'] },
    { name: 'webkit', use: devices['Desktop Safari'] },
  ],
});
```

## 📁 目录结构

```
/app/
├── tests/              # 测试文件目录
├── test-results/       # 测试报告和结果
├── config/             # 配置文件
├── projects/           # 项目文件
├── playwright.config.ts # Playwright 配置
├── package.json        # Node.js 依赖
└── server.js          # Web 管理界面
```

## 🔧 高级功能

### 并行测试

- 支持多浏览器并行执行
- 自动分配测试工作负载
- CI/CD 环境优化

### 测试跟踪

- 自动生成测试执行跟踪
- 可视化测试步骤和时间线
- 失败时自动截图

### 自定义配置

- 支持自定义 Playwright 配置
- 灵活的项目设置
- 环境变量配置

### 🔄 自定义脚本执行

应用采用了配置文件分离设计，您可以轻松替换和自定义执行脚本：

#### 配置文件位置

所有应用配置文件位于 `config/` 目录：

```
config/
├── package.json          # Node.js 依赖配置
├── playwright.config.ts  # Playwright 测试配置
├── server.js            # Web 管理界面服务器
└── start.sh             # 应用启动脚本
```

#### 替换自定义脚本

1. **替换启动脚本**
   ```bash
   # 编辑启动脚本
   vi config/start.sh
   ```

2. **替换 Web 服务器**
   ```bash
   # 编辑或替换服务器脚本
   vi config/server.js
   ```

3. **添加自定义脚本**
   ```bash
   # 在 config 目录添加自定义脚本
   vi config/my-custom-script.js
   ```

4. **修改启动逻辑**
   
   编辑 `config/start.sh` 来调用您的自定义脚本：
   
   ```bash
   #!/bin/bash
   
   echo "🎭 Setting up Playwright Test Environment..."
   
   # 确保目录存在
   mkdir -p tests test-results
   
   # 安装依赖
   echo "📦 Installing dependencies..."
   npm install
   
   # 安装 Playwright 浏览器
   echo "🌐 Installing Playwright browsers..."
   npx playwright install
   
   # 运行您的自定义脚本
   echo "🔧 Running custom script..."
   node my-custom-script.js
   
   # 启动服务器（可选）
   echo "🚀 Starting Playwright server..."
   node server.js
   ```

#### 应用更改

修改配置文件后，重启容器以应用更改：

```bash
# 在 1Panel 中重启应用
# 或使用 Docker Compose 命令
docker-compose restart playwright
```

#### 自定义脚本示例

创建一个简单的自定义测试脚本 `config/my-test.js`：

```javascript
const { chromium } = require('playwright');

(async () => {
  const browser = await chromium.launch();
  const page = await browser.newPage();
  
  await page.goto('https://example.com');
  console.log('页面标题:', await page.title());
  
  await browser.close();
})();
```

然后在 `start.sh` 中调用：

```bash
# 运行自定义测试
echo "🧪 Running custom test..."
node my-test.js
```

#### 注意事项

- 所有自定义脚本必须放在 `config/` 目录中
- 修改后需要重启容器才能生效
- 保持脚本文件的可执行权限
- 遵循 Playwright 安全最佳实践

## 🐛 故障排除

### 常见问题

1. **容器启动失败**
   - 检查内存是否充足（至少2GB）
   - 确认端口未被占用
   - 查看容器日志

2. **测试运行失败**
   - 检查浏览器配置
   - 验证测试文件语法
   - 确认网络连接

3. **权限问题**
   - 调整用户ID和组ID配置
   - 检查文件系统权限
   - 确认数据卷挂载

### 日志查看

```bash
# 查看容器日志
docker logs playwright

# 实时跟踪日志
docker logs -f playwright
```

## 📚 学习资源

- [Playwright 官方文档](https://playwright.dev/docs/intro)
- [测试最佳实践](https://playwright.dev/docs/best-practices)
- [API 参考](https://playwright.dev/docs/api/class-playwright)
- [示例和模式](https://playwright.dev/docs/test-runners)

## 🔗 相关链接

- [官方网站](https://playwright.dev/)
- [GitHub 仓库](https://github.com/microsoft/playwright)
- [社区讨论](https://github.com/microsoft/playwright/discussions)
- [1Panel 文档](https://1panel.cn/docs/)

## 📄 许可证

本项目遵循 Playwright 的开源许可证。详细信息请参考 [官方仓库](https://github.com/microsoft/playwright)。

## 🤝 贡献

欢迎提交 Issue 和 Pull Request 来帮助改进这个应用配置。
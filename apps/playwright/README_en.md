# Playwright

Modern web application automation testing environment built with Microsoft Playwright. Supports Chromium, Firefox, and WebKit browsers, providing a complete end-to-end testing solution.

![](https://cdn.jsdelivr.net/gh/xiaoY233/PicList@main/public/assets/Playwright.png)

![](https://img.shields.io/badge/Copyright-arch3rPro-ff9800?style=flat&logo=github&logoColor=white)

## ✨ Key Features

- **🚀 Fast and Reliable**: Uses Microsoft official Playwright v1.55.0 image
- **🌐 Multi-Browser Support**: Supports Chromium, Firefox, and WebKit
- **🎯 Precise Testing**: Web-first assertions with auto-waiting and retry
- **📊 Rich Reports**: HTML test reports with tracing and screenshots
- **🔧 Highly Configurable**: Flexible test configuration and environment settings
- **🛡️ Secure and Stable**: Follows official security best practices

## 📋 System Requirements

- Docker environment
- 1Panel control panel
- At least 2GB available memory

## 🚀 Quick Start

### 1Panel Deployment

1. Search for "Playwright" in the 1Panel app store
2. Click install and configure the following parameters:
   - **Port**: Web service access port (default: 3000)
   - **Browser Type**: Choose default browser engine
   - **Headless Mode**: Whether to enable headless mode
   - **Viewport Size**: Browser viewport width and height
   - **User Agent**: Custom browser user agent string
   - **User/Group ID**: Container runtime user and group identifiers

3. Click confirm to install

### Accessing the Service

After installation, you can access via:

- **Management Interface**: `http://your-server-ip:port/`
- **Test Reports**: `http://your-server-ip:port/test-results/`
- **Test Files**: `http://your-server-ip:port/tests/`

## ⚙️ Configuration Guide

### Browser Types

- **Chromium**: Google Chrome kernel, recommended choice
- **Firefox**: Mozilla Firefox engine
- **WebKit**: Safari kernel, suitable for mobile testing

### Running Modes

- **Headed Mode**: Shows browser interface, suitable for debugging and development
- **Headless Mode**: Runs in background, suitable for CI/CD and production environments

### Security Configuration

- **User ID**: Recommended to use non-root user (default: 1000)
- **Group ID**: Corresponding user group (default: 1000)
- Application automatically configures security sandbox and permissions

## 🧪 Usage Guide

### Creating Tests

1. Access the management interface
2. Click "Generate Example Test" to generate sample tests
3. Edit test files in the `/app/tests/` directory
4. Write tests using TypeScript or JavaScript

### Sample Test Code

```typescript
import { test, expect } from '@playwright/test';

test('basic test', async ({ page }) => {
  await page.goto('https://playwright.dev/');
  
  // Check page title
  await expect(page).toHaveTitle(/Playwright/);
  
  // Click link
  const getStarted = page.getByRole('link', { name: 'Get started' });
  await getStarted.click();
  
  // Verify URL change
  await expect(page).toHaveURL(/.*intro/);
});
```

### Running Tests

1. Click "Run All Tests" in the management interface
2. Or use command line: `npx playwright test`
3. View the generated HTML report

### Configuration File

The application automatically generates `playwright.config.ts` configuration file:

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

## 📁 Directory Structure

```
/app/
├── tests/              # Test files directory
├── test-results/       # Test reports and results
├── config/             # Configuration files
├── projects/           # Project files
├── playwright.config.ts # Playwright configuration
├── package.json        # Node.js dependencies
└── server.js          # Web management interface
```

## 🔧 Advanced Features

### Parallel Testing

- Supports multi-browser parallel execution
- Automatic test workload distribution
- CI/CD environment optimization

### Test Tracing

- Automatically generates test execution traces
- Visualizes test steps and timeline
- Automatic screenshots on failure

### Custom Configuration

- Supports custom Playwright configuration
- Flexible project settings
- Environment variable configuration

### 🔄 Custom Script Execution

The application uses a separated configuration file design, allowing you to easily replace and customize execution scripts:

#### Configuration File Location

All application configuration files are located in the `config/` directory:

```
config/
├── package.json          # Node.js dependency configuration
├── playwright.config.ts  # Playwright test configuration
├── server.js            # Web management interface server
└── start.sh             # Application startup script
```

#### Replacing Custom Scripts

1. **Replace Startup Script**
   ```bash
   # Edit startup script
   vi config/start.sh
   ```

2. **Replace Web Server**
   ```bash
   # Edit or replace server script
   vi config/server.js
   ```

3. **Add Custom Scripts**
   ```bash
   # Add custom scripts in config directory
   vi config/my-custom-script.js
   ```

4. **Modify Startup Logic**
   
   Edit `config/start.sh` to call your custom scripts:
   
   ```bash
   #!/bin/bash
   
   echo "🎭 Setting up Playwright Test Environment..."
   
   # Ensure directories exist
   mkdir -p tests test-results
   
   # Install dependencies
   echo "📦 Installing dependencies..."
   npm install
   
   # Install Playwright browsers
   echo "🌐 Installing Playwright browsers..."
   npx playwright install
   
   # Run your custom script
   echo "🔧 Running custom script..."
   node my-custom-script.js
   
   # Start server (optional)
   echo "🚀 Starting Playwright server..."
   node server.js
   ```

#### Applying Changes

After modifying configuration files, restart the container to apply changes:

```bash
# Restart application in 1Panel
# Or use Docker Compose command
docker-compose restart playwright
```

#### Custom Script Example

Create a simple custom test script `config/my-test.js`:

```javascript
const { chromium } = require('playwright');

(async () => {
  const browser = await chromium.launch();
  const page = await browser.newPage();
  
  await page.goto('https://example.com');
  console.log('Page Title:', await page.title());
  
  await browser.close();
})();
```

Then call it in `start.sh`:

```bash
# Run custom test
echo "🧪 Running custom test..."
node my-test.js
```

#### Notes

- All custom scripts must be placed in the `config/` directory
- Container restart is required after modifications
- Maintain executable permissions for script files
- Follow Playwright security best practices

## 🐛 Troubleshooting

### Common Issues

1. **Container Startup Failure**
   - Check if memory is sufficient (at least 2GB)
   - Confirm port is not in use
   - View container logs

2. **Test Execution Failure**
   - Check browser configuration
   - Verify test file syntax
   - Confirm network connection

3. **Permission Issues**
   - Adjust user ID and group ID configuration
   - Check file system permissions
   - Confirm data volume mounting

### Log Viewing

```bash
# View container logs
docker logs playwright

# Follow logs in real-time
docker logs -f playwright
```

## 📚 Learning Resources

- [Playwright Official Documentation](https://playwright.dev/docs/intro)
- [Testing Best Practices](https://playwright.dev/docs/best-practices)
- [API Reference](https://playwright.dev/docs/api/class-playwright)
- [Examples and Patterns](https://playwright.dev/docs/test-runners)

## 🔗 Related Links

- [Official Website](https://playwright.dev/)
- [GitHub Repository](https://github.com/microsoft/playwright)
- [Community Discussions](https://github.com/microsoft/playwright/discussions)
- [1Panel Documentation](https://1panel.cn/docs/)

## 📄 License

This project follows the open source license of Playwright. For details, please refer to the [official repository](https://github.com/microsoft/playwright).

## 🤝 Contributing

Welcome to submit Issues and Pull Requests to help improve this application configuration.
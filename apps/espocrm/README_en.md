# EspoCRM

EspoCRM is a self-hosted, open-source enterprise CRM system that supports contact management, sales pipelines, email integration, automation, and workflows.

## Key Features

- 👤 Full management of accounts, contacts, leads, and opportunities.
- 📈 Visual sales pipelines and custom reports.
- ✉️ Email sending/receiving, templates, and email automation.
- ⚙️ Visual business process and workflow designer.
- 🔑 Granular role and permission control.
- 🌐 Multi-language support.
- 🧩 Rich extension marketplace and open API.

## Links

- Website: https://www.espocrm.com
- Docs: https://docs.espocrm.com
- Source: https://github.com/espocrm/espocrm

## 1Panel Deployment

1. Search for EspoCRM in the 1Panel app store and install.
2. Select an installed MySQL or MariaDB database service, then fill in the database name, database user/password, admin account/password, and site URL.
3. After installation, visit `http://SERVER_IP:PORT` to log in.
4. Data is persisted in the `data`, `custom`, and `client-custom` directories.

> Tip: First install a MySQL or MariaDB service in 1Panel's "Databases" section, then select it from the dropdown when installing EspoCRM. 1Panel auto-creates the database and user.

> Note: Realtime WebSocket push works over the internal container network by default. To expose WebSocket externally, configure additional reverse-proxy forwarding.

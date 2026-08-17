# EspoCRM

EspoCRM is a self-hosted open-source enterprise CRM.

## 1Panel Deployment

1. Install MySQL or MariaDB in 1Panel first.
2. Select the database service when installing EspoCRM. 1Panel supplies the database host/port and creates the configured database/user.
3. WebSocket is disabled by default so the core CRM can start without an invalid Docker-only browser URL.
4. To enable realtime WebSocket, enable the option, expose the WebSocket port, and set a browser-reachable URL such as `wss://crm.example.com/ws` or `ws://server-ip:8005`. For `wss://`, proxy that path to the WebSocket port in 1Panel.
5. Persistent data is stored in `data`, `custom`, and `client-custom`.

## Links

- Website: https://www.espocrm.com
- Docs: https://docs.espocrm.com
- Source: https://github.com/espocrm/espocrm

# Grafana

**Grafana** is an open-source visualization, monitoring, and analytics platform. It aggregates metrics, logs, and traces from dozens of data sources such as Prometheus, Loki, InfluxDB, MySQL, and Zabbix, and presents them through rich dashboards, alerts, and reports.

**✨ Key Features**:

1. **Multi Data Source**: Supports Prometheus, Loki, InfluxDB, MySQL, PostgreSQL, Elasticsearch, Zabbix and dozens of other data sources
2. **Powerful Visualization**: Built-in charts, dashboards and table panels, with custom panels and template variables
3. **Alerting & Notifications**: Rule-based alerting with notifications via DingTalk, email, WeChat, Webhook and more
4. **Flexible Authentication**: Built-in users and teams, with LDAP, OAuth, SAML and other SSO integrations
5. **Plugin Ecosystem**: Extend with more data sources and apps through official and community plugins
6. **Web Interface**: No client installation needed, just open a browser to access

**📖 Usage**:

1. After installation, access the Grafana web interface via the configured port
2. Log in with the administrator username and password set during installation
3. On first login, you can add data sources, create dashboards, or import community dashboard templates

**🔒 Security Notes**:

- The default admin username is `admin`; the password is randomly generated during installation. Please change it afterwards
- It is recommended to configure HTTPS access for Grafana through a 1Panel reverse proxy

# Frappe Insights

Frappe Insights is an open-source business intelligence and analytics platform for connecting data sources, writing SQL queries, building visualizations, and creating interactive dashboards.

## Key Features

- 📊 Interactive BI dashboards and data visualizations.
- 🔎 SQL queries and data exploration.
- 📈 Charts, metric cards, and filters.
- 🧩 Integration with Frappe Framework and the ERPNext ecosystem.
- 👥 Team collaboration and permission management.
- ⚙️ Extensible application architecture built on Frappe.

## Links

- Website: https://frappe.io/insights
- Docs: https://docs.frappe.io/insights
- Source: https://github.com/frappe/insights

## 1Panel Deployment

1. Install MariaDB and Redis services first in 1Panel's "Databases" section.
2. Search for Frappe Insights in the 1Panel app store and install it.
3. Select the installed MariaDB and Redis services, then provide the MariaDB root password, site domain, and administrator password.
4. On first start, the site is created, Insights is installed, and the required configuration is initialized automatically; please wait patiently.
5. Point the site domain to the server and visit `http://SITE_DOMAIN:PORT`.
6. The default administrator account is `Administrator`; the password is the one entered during installation.
7. Data is persisted in the `sites` directory.

> Important: Frappe routes requests by the Host domain. Access the app using the site domain you entered rather than the server IP. When configuring a reverse proxy, preserve the correct Host header and forward traffic to the app port.

> Frappe Insights requires Server Scripts to be enabled; the app enables this configuration during initialization.

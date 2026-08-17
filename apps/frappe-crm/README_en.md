# Frappe CRM

Frappe CRM is an open-source CRM built on the Frappe framework, focused on simple and fast customer relationship and sales pipeline management, extensible into a full ERP ecosystem.

## Key Features

- 👤 Contacts, leads, customers, and deals management.
- 🎯 Visual sales pipeline (kanban) board.
- ✍️ Markdown notes and team collaboration.
- 🔔 Automated notifications and follow-up reminders.
- 📊 Sales analytics and dashboards.
- 🔌 Built on the Frappe framework; can be extended with ERPNext and other apps.

## Links

- Website: https://frappe.io/crm
- Docs: https://docs.frappe.io/crm
- Source: https://github.com/frappe/crm

## 1Panel Deployment

1. Search for Frappe CRM in the 1Panel app store and install.
2. Fill in the site domain, database root password, and administrator password.
3. On first start the site is initialized and the CRM app is installed automatically; please wait patiently.
4. After installation, point your access domain to the server and visit `http://SITE_DOMAIN:PORT`.
5. The default administrator account is `Administrator`; the password is the one you set during installation.
6. Data is persisted in the `sites`, `db-data`, and `redis-data` directories.

> Tip: Frappe routes traffic by site domain, so access it using the site domain you entered (not the server IP). For reverse proxy, forward the `FRAPPE_SITE_NAME` domain to this service port.

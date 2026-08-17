# Chatwoot

Chatwoot is a self-hosted, open-source customer engagement platform offering live chat, a unified multi-channel inbox, ticket management, automation, and team collaboration.

## Key Features

- 💬 Real-time live chat and website widget.
- 📥 Unified cross-channel inbox (email, WeChat, WhatsApp, Facebook, Telegram, etc.).
- 🎫 Ticket management and multi-level assignment.
- 🤖 Automation, bot conversations, and intelligent routing.
- 🏷️ Conversation labels, private notes, and team collaboration.
- 📊 Agent performance and conversation analytics.
- 🔐 Granular role and permission control.
- 🌐 Multi-language support.

## Links

- Website: https://www.chatwoot.com
- Docs: https://www.chatwoot.com/docs
- Source: https://github.com/chatwoot/chatwoot

## 1Panel Deployment

1. Search for Chatwoot in the 1Panel app store and install.
2. Fill in the secret key, database password, Redis password, database name, and frontend URL.
3. After installation, visit `http://SERVER_IP:PORT` to complete initial setup.
4. Data is persisted in the `data` directory.

> Tip: Access Chatwoot via the address you set in `FRONTEND_URL` (a workspace account must be registered on first boot). We recommend enabling HTTPS in your reverse proxy and setting `FORCE_SSL`.

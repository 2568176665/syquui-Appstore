# S-UI

S-UI is a multi-protocol proxy management panel built on SagerNet/Sing-Box. It provides inbound management, subscription services, traffic statistics, routing configuration, and a multilingual interface.

## Usage

- Panel: http://server-address:panel-port/app/
- Subscription service: http://server-address:subscription-port/sub/
- Default username/password: admin / admin
- Persistent data: ./data/db
- Certificate directory: ./data/cert
- Ports 80 and 443 are provided for common proxy inbounds; configure the corresponding inbounds in S-UI before use.

Change the default password immediately after the first login. If a panel or inbound port conflicts with an existing 1Panel service, change the installation port and update the corresponding S-UI inbound configuration together.

The upstream project states that S-UI is intended for personal learning and communication and is not recommended for production use. Follow the laws and service-provider policies applicable to your deployment.

## Links

- GitHub Project: https://github.com/alireza0/s-ui
- Docker Compose Configuration: https://github.com/alireza0/s-ui/blob/main/docker-compose.yml
- API Documentation: https://github.com/alireza0/s-ui/wiki

#!/bin/sh
set -eu

APP_DIR="$(cd "$(dirname "$0")/.." && pwd)"
UPSTREAM_DIR="$APP_DIR/data/upstream"
CONFIG="$UPSTREAM_DIR/config.json"

mkdir -p "$UPSTREAM_DIR/auths" "$UPSTREAM_DIR/data" "$APP_DIR/data"

# 上游只在 config.json 不存在时生成：已安装的实例保留原 api_key 与账号
if [ ! -f "$CONFIG" ]; then
    api_key=$(od -An -N16 -tx1 /dev/urandom | tr -d ' \n')
    umask 077
    cat > "$CONFIG" <<EOF
{
  "listen": ":7863",
  "api_key": "$api_key",
  "auth_dir": "./auths",
  "state_file": "./data/state.json",
  "cooldown": {
    "soft_rate": "600s",
    "soft_rate_max": "2h"
  },
  "schedule": {
    "checkin_hours": [9, 21],
    "travel_hours": [9, 21],
    "activity_hours": [10],
    "keepalive_hours": [22],
    "school_hours": [12],
    "cat_hours": [1],
    "checkin_enabled": true,
    "travel_enabled": true,
    "activity_enabled": true,
    "keepalive_enabled": true,
    "school_enabled": true,
    "cat_enabled": true
  },
  "admin": {
    "enabled": false
  },
  "global": {
    "enabled": true,
    "chat_base": "",
    "billing_base": ""
  },
  "upstream": {
    "timeout_seconds": 120,
    "header_timeout_seconds": 120,
    "idle_timeout_seconds": 300,
    "user_agent": "",
    "client_version": "",
    "cli_version": "",
    "device_token": "",
    "device_token_file": "",
    "client_name": "WorkBuddy",
    "passthrough_ip": false
  },
  "features": {
    "sanitize_blacklist_fingerprints": true,
    "sanitize_extra_features": [],
    "sanitize_extra_rewrites": []
  },
  "prompt": {
    "mode": "passthrough",
    "file": ""
  },
  "upstash": {
    "url": "",
    "token": ""
  },
  "pool": {
    "max_in_flight": 3,
    "max_in_flight_global": 2,
    "breaker_threshold": 3,
    "breaker_cooldown": "30m",
    "breaker_cooldown_max": "6h",
    "degrade_threshold": 5,
    "degrade_cooldown": "10m",
    "degrade_cooldown_max": "2h",
    "idle_weight_per_hour": 0.5,
    "idle_weight_max": 5.0,
    "expiring_soon": "168h",
    "cost_explore_interval": "30m"
  },
  "session_sticky": {
    "enabled": true,
    "ttl": "30m",
    "gc_interval": "5m"
  }
}
EOF
    chmod 644 "$CONFIG"
fi

# 两个容器都以 uid 10001 运行，绑定挂载目录必须同属主，否则上游读不到 config.json
chown -R 10001:10001 "$APP_DIR/data"

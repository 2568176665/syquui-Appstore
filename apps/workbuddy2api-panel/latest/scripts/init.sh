#!/bin/sh
set -eu

APP_DIR="$(cd "$(dirname "$0")/.." && pwd)"
mkdir -p "$APP_DIR/data/auths"
chown -R 10001:10001 "$APP_DIR/data"

#!/bin/sh
set -eu

cd "$(dirname "$0")/.."

mkdir -p ./data/config

# magpie 以 uid 65532 运行，绑定的宿主机目录必须归它所有，否则无法写入 /config。
if [ "$(id -u)" -eq 0 ]; then
    chown -R 65532:65532 ./data/config
fi

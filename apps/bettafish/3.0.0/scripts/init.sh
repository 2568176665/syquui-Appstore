#!/bin/sh
set -eu
cd "$(dirname "$0")/.."

env_file=.env
[ -f "$env_file" ] || : > "$env_file"

read_env() {
    sed -n "s/^$1=//p" "$env_file" | tail -n 1 | sed 's/^"//;s/"$//'
}

set_env() {
    key=$1
    value=$2
    if grep -q "^${key}=" "$env_file"; then
        temporary=$(mktemp)
        awk -v k="$key" -v v="$value" 'index($0, k "=") == 1 { print k "=" v; next } { print }' "$env_file" > "$temporary"
        cat "$temporary" > "$env_file"
        rm -f "$temporary"
    else
        printf '%s=%s\n' "$key" "$value" >> "$env_file"
    fi
}

password=$(read_env DB_PASSWORD)
if [ -z "$password" ]; then
    password=$(od -An -N16 -tx1 /dev/urandom | tr -d ' \n')
    set_env DB_PASSWORD "$password"
fi

[ -n "$(read_env DB_USER)" ] || set_env DB_USER bettafish
[ -n "$(read_env DB_NAME)" ] || set_env DB_NAME bettafish

set_env DB_HOST db
set_env DB_PORT 5432
set_env DB_DIALECT postgresql
set_env DB_CHARSET utf8mb4
set_env HOST 0.0.0.0
set_env PORT 5000

chmod 600 "$env_file"

mkdir -p ./data/db_data ./data/logs ./data/final_reports \
    ./data/insight_engine_streamlit_reports \
    ./data/media_engine_streamlit_reports \
    ./data/query_engine_streamlit_reports

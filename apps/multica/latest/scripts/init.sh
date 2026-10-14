#!/bin/sh
set -eu
umask 077
cd "$(dirname "$0")/.."
mkdir -p ./data
secrets=./data/secrets.env
if [ -f "$secrets" ]; then
    for key in POSTGRES_PASSWORD JWT_SECRET DATABASE_URL; do
        grep -q "^${key}=.\+" "$secrets" || { echo "Invalid secrets.env: missing $key" >&2; exit 1; }
    done
    exit 0
fi

# Preserve credentials from installations created before automatic generation.
read_env() {
    [ -f .env ] || return 0
    sed -n "s/^$1=//p" .env | sed "s/^\"//;s/\"$//;s/^'//;s/'$//"
}
password=$(read_env POSTGRES_PASSWORD)
secret=$(read_env JWT_SECRET)
if [ -f ./data/postgres/PG_VERSION ] && { [ -z "$password" ] || [ -z "$secret" ]; }; then
    echo "Existing credentials are missing; refusing to replace them" >&2
    exit 1
fi
[ -n "$password" ] || password=$(od -An -N24 -tx1 /dev/urandom | tr -d ' \n')
[ -n "$secret" ] || secret=$(od -An -N32 -tx1 /dev/urandom | tr -d ' \n')
[ -n "$password" ] && [ -n "$secret" ] || { echo "Credential generation failed" >&2; exit 1; }
case "$password$secret" in
    *[!A-Za-z0-9_-]*) echo "Credentials contain unsupported characters" >&2; exit 1 ;;
esac
temporary=$(mktemp ./data/secrets.env.XXXXXX)
trap 'rm -f "$temporary"' EXIT HUP INT TERM
printf 'POSTGRES_PASSWORD=%s\nJWT_SECRET=%s\nDATABASE_URL=postgres://multica:%s@postgres:5432/multica?sslmode=disable\n' "$password" "$secret" "$password" > "$temporary"
mv "$temporary" "$secrets"

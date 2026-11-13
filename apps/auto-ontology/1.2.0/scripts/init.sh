#!/bin/sh
set -eu
umask 077

cd "$(dirname "$0")/.."
mkdir -p ./data

secrets=./data/secrets.env

# Both values must survive reinstalls and upgrades: AUTH_SECRET signs sessions,
# POSTGRES_PASSWORD is the password of the database that already exists.
if [ -f "$secrets" ] &&
    grep -q '^POSTGRES_PASSWORD=[0-9a-f]\{32\}$' "$secrets" &&
    grep -q '^AUTH_SECRET=[0-9a-f]\{64\}$' "$secrets"; then
    exit 0
fi

# A database without its password means the file was lost. Generating a new
# password here would leave the existing cluster unreachable.
if [ -f ./data/postgres/PG_VERSION ]; then
    echo "data/secrets.env is missing or does not hold POSTGRES_PASSWORD and AUTH_SECRET," >&2
    echo "but data/postgres already exists." >&2
    echo "Restore both values into data/secrets.env, or remove data/postgres to start over." >&2
    exit 1
fi

# Hex only: the application builds "postgresql://user:password@host" from this
# value without URL-encoding, so reserved characters such as @ : / # would
# break every connection.
password=$(od -An -N16 -tx1 /dev/urandom | tr -d ' \n')
secret=$(od -An -N32 -tx1 /dev/urandom | tr -d ' \n')
[ "${#password}" -eq 32 ] || { echo "POSTGRES_PASSWORD generation failed" >&2; exit 1; }
[ "${#secret}" -eq 64 ] || { echo "AUTH_SECRET generation failed" >&2; exit 1; }

temporary=$(mktemp ./data/secrets.env.XXXXXX)
trap 'rm -f "$temporary"' EXIT HUP INT TERM
printf 'POSTGRES_PASSWORD=%s\nAUTH_SECRET=%s\n' "$password" "$secret" > "$temporary"
chmod 600 "$temporary"
mv "$temporary" "$secrets"

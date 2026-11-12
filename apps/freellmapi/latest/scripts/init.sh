#!/bin/sh
set -eu
umask 077

cd "$(dirname "$0")/.."
mkdir -p ./data

secrets=./data/secrets.env

# Provider keys are encrypted with this key, so it must survive reinstalls and
# upgrades: keep whatever is already there instead of rotating it.
if [ -f "$secrets" ] && grep -q '^ENCRYPTION_KEY=[0-9a-fA-F]\{64\}$' "$secrets"; then
    exit 0
fi

# A database without its key means the key file was lost. Generating a new key
# here would silently orphan every provider key stored inside that database.
if [ -f ./data/freeapi.db ]; then
    echo "data/secrets.env is missing or does not hold a 64-character hex ENCRYPTION_KEY," >&2
    echo "but data/freeapi.db already exists." >&2
    echo "Restore the original ENCRYPTION_KEY into data/secrets.env, or remove data/freeapi.db to start over." >&2
    exit 1
fi

key=$(od -An -N32 -tx1 /dev/urandom | tr -d ' \n')
[ "${#key}" -eq 64 ] || { echo "ENCRYPTION_KEY generation failed" >&2; exit 1; }

temporary=$(mktemp ./data/secrets.env.XXXXXX)
trap 'rm -f "$temporary"' EXIT HUP INT TERM
printf 'ENCRYPTION_KEY=%s\n' "$key" > "$temporary"
# Restrict before the rename so the key is never briefly readable under its
# final name; the rename carries the mode with it.
chmod 600 "$temporary"
mv "$temporary" "$secrets"

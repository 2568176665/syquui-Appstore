#!/bin/sh
set -eu
umask 077

cd "$(dirname "$0")/.."
mkdir -p ./data

secrets=./data/secrets.env

# AUTH_SECRET signs every session. Keep the existing value so reinstalls and
# upgrades never log all users out.
if [ -f "$secrets" ] && grep -q '^AUTH_SECRET=.\{32,\}$' "$secrets"; then
    exit 0
fi

secret=$(od -An -N32 -tx1 /dev/urandom | tr -d ' \n')
[ "${#secret}" -eq 64 ] || { echo "AUTH_SECRET generation failed" >&2; exit 1; }

temporary=$(mktemp ./data/secrets.env.XXXXXX)
trap 'rm -f "$temporary"' EXIT HUP INT TERM
printf 'AUTH_SECRET=%s\n' "$secret" > "$temporary"
chmod 600 "$temporary"
mv "$temporary" "$secrets"

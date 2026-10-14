#!/bin/sh
set -eu
app=$(cd "$(dirname "$0")/.." && pwd)
temporary=$(mktemp -d)
trap 'rm -rf "$temporary"' EXIT HUP INT TERM

for version in 0.6.2 latest; do
    install="$temporary/$version"
    mkdir -p "$install/scripts"
    cp "$app/$version/scripts/"*.sh "$install/scripts/"
    sh "$install/scripts/init.sh"
    secrets="$install/data/secrets.env"
    grep -Eq '^POSTGRES_PASSWORD=[0-9a-f]{48}$' "$secrets"
    grep -Eq '^JWT_SECRET=[0-9a-f]{64}$' "$secrets"
    password=$(sed -n 's/^POSTGRES_PASSWORD=//p' "$secrets")
    grep -Fqx "DATABASE_URL=postgres://multica:$password@postgres:5432/multica?sslmode=disable" "$secrets"
    cp "$secrets" "$install/original"
    sh "$install/scripts/init.sh"
    sh "$install/scripts/upgrade.sh"
    cmp "$secrets" "$install/original"
    if [ "$(uname -s)" = Linux ]; then
        [ "$(stat -c '%a' "$secrets")" = 600 ]
    fi

    legacy="$temporary/$version-legacy"
    mkdir -p "$legacy/scripts" "$legacy/data/postgres"
    cp "$app/$version/scripts/"*.sh "$legacy/scripts/"
    printf 'POSTGRES_PASSWORD="ExistingDatabasePassword123"\nJWT_SECRET="ExistingJwtSecret456"\n' > "$legacy/.env"
    touch "$legacy/data/postgres/PG_VERSION"
    sh "$legacy/scripts/upgrade.sh"
    grep -Fqx 'POSTGRES_PASSWORD=ExistingDatabasePassword123' "$legacy/data/secrets.env"
    grep -Fqx 'JWT_SECRET=ExistingJwtSecret456' "$legacy/data/secrets.env"

    broken="$temporary/$version-broken"
    mkdir -p "$broken/scripts" "$broken/data/postgres"
    cp "$app/$version/scripts/"*.sh "$broken/scripts/"
    touch "$broken/data/postgres/PG_VERSION"
    if sh "$broken/scripts/init.sh" 2>/dev/null; then
        echo 'Unexpected success with an existing database and missing password' >&2
        exit 1
    fi
    [ ! -f "$broken/data/secrets.env" ]
    printf 'POSTGRES_PASSWORD=incomplete\n' > "$broken/data/secrets.env"
    if sh "$broken/scripts/init.sh" 2>/dev/null; then
        echo 'Unexpected success with incomplete credentials' >&2
        exit 1
    fi
done
echo 'PASS: generation, credential reuse, legacy upgrades, incomplete-state protection'

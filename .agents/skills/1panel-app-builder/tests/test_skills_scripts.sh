#!/usr/bin/env bash
set -euo pipefail

SKILL_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT

fail(){ echo "FAIL: $*" >&2; exit 1; }
assert_file(){ [[ -f "$1" ]] || fail "expected file: $1"; }
assert_not_file(){ [[ ! -f "$1" ]] || fail "expected missing file: $1"; }
assert_contains(){ grep -qE -- "$2" "$1" || { cat "$1" >&2; fail "expected '$2' in $1"; }; }
assert_not_contains(){ ! grep -qE -- "$2" "$1" || { cat "$1" >&2; fail "unexpected '$2' in $1"; }; }
run_test(){ echo "== $1 =="; shift; "$@"; }

make_top(){
  local app="$1" key="$2"
  cat > "$app/data.yml" <<YAML
name: Demo
title: Demo
description: Demo
additionalProperties:
  key: $key
  name: Demo
  description:
    en: Demo
    es-es: Demo
    fa: Demo
    ja: Demo
    ms: Demo
    pt-br: Demo
    ru: Demo
    ko: Demo
    zh-hant: Demo
    zh: Demo
    tr: Demo
  architectures: [amd64]
YAML
  touch "$app/README.md" "$app/README_en.md"
}

test_dependencies(){ bash "$SKILL_DIR/scripts/generate-app.sh" --check-deps >/tmp/skill_deps.out; }

test_icon_modes(){
  local cache="$TMP_DIR/cache" out="$TMP_DIR/icon/logo.png"
  mkdir -p "$cache"; printf x > "$cache/demo.png"
  bash "$SKILL_DIR/scripts/download-icon.sh" --mode skip demo "$out" >/tmp/icon_skip.out
  assert_not_file "$out"
  bash "$SKILL_DIR/scripts/download-icon.sh" --mode cache-only --cache-dir "$cache" demo "$out" >/tmp/icon_cache.out
  assert_file "$out"
}

test_generate_pinned_and_preserves_mapping(){
  local compose="$TMP_DIR/one.yml" out="$TMP_DIR/out1"
  cat > "$compose" <<'YAML'
services:
  web:
    image: nginx:1.25.3
    ports:
      - "18080:80"
    environment:
      FOO: bar
      ENABLED: true
    volumes:
      - ./data/html:/usr/share/nginx/html
YAML
  bash "$SKILL_DIR/scripts/generate-app.sh" --app-key demo --name 'Demo: App' --output "$out" --icon-mode skip "$compose" >/tmp/gen1.out
  assert_file "$out/demo/1.25.3/docker-compose.yml"
  assert_not_file "$out/demo/latest/docker-compose.yml"
  assert_contains "$out/demo/1.25.3/docker-compose.yml" 'FOO=bar'
  assert_contains "$out/demo/1.25.3/docker-compose.yml" 'ENABLED=true'
  assert_contains "$out/demo/1.25.3/docker-compose.yml" './data/html:/usr/share/nginx/html'
  assert_not_contains "$out/demo/1.25.3/docker-compose.yml" 'PUID=0'
  python3 - <<PY
import yaml
for f in ['$out/demo/data.yml','$out/demo/1.25.3/data.yml','$out/demo/1.25.3/docker-compose.yml']:
    yaml.safe_load(open(f,encoding='utf-8'))
PY
}

test_generate_no_invented_mount_or_env(){
  local compose="$TMP_DIR/min.yml" out="$TMP_DIR/out2"
  cat > "$compose" <<'YAML'
services:
  web:
    image: nginx:1.25.3
    ports: ["18081:80"]
YAML
  bash "$SKILL_DIR/scripts/generate-app.sh" --app-key minimal --output "$out" --icon-mode skip "$compose" >/tmp/gen2.out
  assert_not_contains "$out/minimal/1.25.3/docker-compose.yml" '^    volumes:'
  assert_not_contains "$out/minimal/1.25.3/docker-compose.yml" '^    environment:'
}

test_source_v_tag_directory_normalized(){
  local compose="$TMP_DIR/v.yml" out="$TMP_DIR/outv"
  cat > "$compose" <<'YAML'
services:
  web:
    image: ghcr.io/example/app:v1.2.3
YAML
  bash "$SKILL_DIR/scripts/generate-app.sh" --app-key vdemo --output "$out" --icon-mode skip "$compose" >/tmp/genv.out
  assert_file "$out/vdemo/1.2.3/docker-compose.yml"
  assert_contains "$out/vdemo/1.2.3/docker-compose.yml" 'image: ghcr.io/example/app:v1.2.3'
}

test_floating_requires_version(){
  local compose="$TMP_DIR/floating.yml" out="$TMP_DIR/outf"
  cat > "$compose" <<'YAML'
services:
  web:
    image: example/app:latest
YAML
  if bash "$SKILL_DIR/scripts/generate-app.sh" --app-key floating --output "$out" --icon-mode skip "$compose" >/tmp/genf.out 2>&1; then fail "floating image should require explicit version"; fi
  assert_contains /tmp/genf.out '显式 --version'
}

test_multiservice_rejected_by_default(){
  local compose="$TMP_DIR/multi.yml" out="$TMP_DIR/outm"
  cat > "$compose" <<'YAML'
services:
  web:
    image: example/web:1.0.0
    depends_on: [db]
  db:
    image: postgres:16
YAML
  if bash "$SKILL_DIR/scripts/generate-app.sh" --app-key multi --output "$out" --icon-mode skip "$compose" >/tmp/genm.out 2>&1; then fail "multi service should be rejected"; fi
  assert_contains /tmp/genm.out '多服务|检测到 2 个服务'
}

test_multiservice_partial_requires_lossy_for_depends_on(){
  local compose="$TMP_DIR/multi2.yml" out="$TMP_DIR/outm2"
  cp "$TMP_DIR/multi.yml" "$compose"
  if bash "$SKILL_DIR/scripts/generate-app.sh" --service web --allow-partial-compose --app-key multi --output "$out" --icon-mode skip "$compose" >/tmp/genm2a.out 2>&1; then fail "depends_on should require allow-lossy"; fi
  bash "$SKILL_DIR/scripts/generate-app.sh" --service web --allow-partial-compose --allow-lossy --app-key multi --output "$out" --icon-mode skip "$compose" >/tmp/genm2b.out
  assert_file "$out/multi/1.0.0/docker-compose.yml"
}

test_validator_accepts_8080_default(){
  local app="$TMP_DIR/v8080/demo"; mkdir -p "$app/1.0.0"; make_top "$app" demo
  cat > "$app/1.0.0/data.yml" <<'YAML'
additionalProperties:
  formFields:
    - default: 8080
      envKey: PANEL_APP_PORT_HTTP
      type: number
YAML
  cat > "$app/1.0.0/docker-compose.yml" <<'YAML'
services:
  demo:
    container_name: ${CONTAINER_NAME}
    restart: always
    networks: [1panel-network]
    ports: ["${PANEL_APP_PORT_HTTP}:80"]
    image: example/demo:1.0.0
    labels: {createdBy: Apps}
networks:
  1panel-network: {external: true}
YAML
  bash "$SKILL_DIR/scripts/validate-app.sh" --draft "$app" >/tmp/v8080.out
  assert_not_contains /tmp/v8080.out '默认宿主机端口不应使用 8080'
}

test_validator_rejects_static_80_and_undefined_port(){
  local app="$TMP_DIR/vbad/demo"; mkdir -p "$app/1.0.0"; make_top "$app" demo
  printf 'additionalProperties:\n  formFields: []\n' > "$app/1.0.0/data.yml"
  cat > "$app/1.0.0/docker-compose.yml" <<'YAML'
services:
  demo:
    container_name: ${CONTAINER_NAME}
    restart: always
    networks: [1panel-network]
    ports:
      - "80:80"
      - "${PANEL_APP_PORT_ADMIN}:9000"
    image: example/demo:1.0.0
    labels: {createdBy: Apps}
networks:
  1panel-network: {external: true}
YAML
  if bash "$SKILL_DIR/scripts/validate-app.sh" --draft "$app" >/tmp/vbad.out 2>&1; then fail "validator should reject bad ports"; fi
  assert_contains /tmp/vbad.out '80/443'
  assert_contains /tmp/vbad.out '未在版本 data.yml 定义'
}

test_validator_rejects_floating_image_in_concrete_version(){
  local app="$TMP_DIR/vfloat/demo"; mkdir -p "$app/1.0.0"; make_top "$app" demo
  printf 'additionalProperties:\n  formFields: []\n' > "$app/1.0.0/data.yml"
  cat > "$app/1.0.0/docker-compose.yml" <<'YAML'
services:
  demo:
    container_name: ${CONTAINER_NAME}
    restart: always
    networks: [1panel-network]
    image: example/demo:latest
    labels: {createdBy: Apps}
networks:
  1panel-network: {external: true}
YAML
  if bash "$SKILL_DIR/scripts/validate-app.sh" --draft "$app" >/tmp/vfloat.out 2>&1; then fail "validator should reject floating primary image"; fi
  assert_contains /tmp/vfloat.out '浮动主镜像'
}

test_validator_key_mismatch(){
  local app="$TMP_DIR/vkey/demo"; mkdir -p "$app/1.0.0"; make_top "$app" wrong-key
  printf 'additionalProperties:\n  formFields: []\n' > "$app/1.0.0/data.yml"
  cat > "$app/1.0.0/docker-compose.yml" <<'YAML'
services:
  demo:
    container_name: ${CONTAINER_NAME}
    restart: always
    networks: [1panel-network]
    image: example/demo:1.0.0
    labels: {createdBy: Apps}
networks:
  1panel-network: {external: true}
YAML
  if bash "$SKILL_DIR/scripts/validate-app.sh" --draft "$app" >/tmp/vkey.out 2>&1; then fail "key mismatch should fail"; fi
  assert_contains /tmp/vkey.out '必须等于目录名'
}

run_test dependencies test_dependencies
run_test icons test_icon_modes
run_test 'generate pinned + env mapping' test_generate_pinned_and_preserves_mapping
run_test 'no invented config' test_generate_no_invented_mount_or_env
run_test 'v tag directory normalization' test_source_v_tag_directory_normalized
run_test 'floating tag policy' test_floating_requires_version
run_test 'multi-service rejection' test_multiservice_rejected_by_default
run_test 'partial compose lossiness guard' test_multiservice_partial_requires_lossy_for_depends_on
run_test '8080 accepted' test_validator_accepts_8080_default
run_test 'static 80 + undefined variable rejected' test_validator_rejects_static_80_and_undefined_port
run_test 'floating image rejected' test_validator_rejects_floating_image_in_concrete_version
run_test 'key mismatch rejected' test_validator_key_mismatch

echo 'All skill script tests passed.'

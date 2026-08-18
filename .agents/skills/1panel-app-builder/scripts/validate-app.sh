#!/usr/bin/env bash

# 1Panel App Validator - production-oriented static checks
set -euo pipefail

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; BLUE='\033[0;34m'; NC='\033[0m'
ERRORS=0; WARNINGS=0; DRAFT=false; POSITIONAL=()

log_info() { echo -e "${GREEN}[INFO]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; ((WARNINGS+=1)); }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; ((ERRORS+=1)); }

print_help() {
  cat <<EOF_HELP
${BLUE}1Panel App Validator${NC}

用法:
  $0 [--draft] <app-directory>

--draft  草稿模式：缺少 logo/README 等发布材料时降级为警告
EOF_HELP
}

parse_args() {
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --draft) DRAFT=true; shift ;;
      -h|--help) print_help; exit 0 ;;
      -*) log_error "未知选项: $1"; exit 2 ;;
      *) POSITIONAL+=("$1"); shift ;;
    esac
  done
}

has_yq() { command -v yq >/dev/null 2>&1; }

yq_read() {
  local file="$1" expr="$2"
  has_yq && yq -r "$expr" "$file" 2>/dev/null || true
}

validate_yaml_syntax() {
  local file="$1"
  [[ -f "$file" ]] || return 0
  if has_yq; then
    yq -e '.' "$file" >/dev/null 2>&1 || log_error "YAML 解析失败: $file"
    return 0
  fi
  if python3 - "$file" <<'PY' >/dev/null 2>&1
import sys
try:
    import yaml
except Exception:
    raise SystemExit(2)
with open(sys.argv[1], 'r', encoding='utf-8') as f:
    yaml.safe_load(f)
PY
  then
    return 0
  else
    local rc=$?
    if [[ $rc -eq 2 ]]; then log_warn "未安装 yq/PyYAML，无法做完整 YAML 语法解析: $file"; else log_error "YAML 解析失败: $file"; fi
  fi
}

find_version_dirs() {
  find "$1" -mindepth 1 -maxdepth 1 -type d 2>/dev/null | while IFS= read -r dir; do
    [[ -f "$dir/data.yml" || -f "$dir/docker-compose.yml" ]] && echo "$dir"
  done
}

check_directory_structure() {
  local app_dir="$1" version_dirs
  log_info "检查目录结构: $(basename "$app_dir")"
  [[ -f "$app_dir/data.yml" ]] || log_error "缺少顶层 data.yml"
  if [[ ! -f "$app_dir/logo.png" ]]; then [[ "$DRAFT" == true ]] && log_warn "缺少 logo.png（草稿允许）" || log_error "缺少 logo.png"; fi
  if [[ ! -f "$app_dir/README.md" ]]; then [[ "$DRAFT" == true ]] && log_warn "缺少 README.md" || log_warn "缺少 README.md（发布前应补充）"; fi
  [[ -f "$app_dir/README_en.md" ]] || log_warn "缺少 README_en.md"
  version_dirs=$(find_version_dirs "$app_dir" || true)
  [[ -n "$version_dirs" ]] || { log_error "未找到版本目录"; return; }
  while IFS= read -r dir; do
    [[ -n "$dir" ]] || continue
    log_info "检查版本目录: $(basename "$dir")"
    [[ -f "$dir/data.yml" ]] || log_error "版本目录缺少 data.yml: $dir"
    [[ -f "$dir/docker-compose.yml" ]] || log_error "版本目录缺少 docker-compose.yml: $dir"
  done <<< "$version_dirs"
}

validate_top_data_yml() {
  local file="$1" app_name key locale
  [[ -f "$file" ]] || return 0
  validate_yaml_syntax "$file"
  app_name=$(basename "$(dirname "$file")")
  for field in name title description additionalProperties; do grep -qE "^${field}:" "$file" || log_error "顶层 data.yml 缺少: $field"; done
  if has_yq; then
    key=$(yq_read "$file" '.additionalProperties.key // ""')
    [[ -z "$key" || "$key" == "$app_name" ]] || log_error "additionalProperties.key 必须等于目录名: key=$key dir=$app_name"
    for locale in en es-es fa ja ms pt-br ru ko zh-hant zh tr; do
      if [[ "$locale" == zh-hant ]]; then
        [[ -n "$(yq_read "$file" ".additionalProperties.description[\"zh-hant\"] // .additionalProperties.description[\"zh-Hant\"] // \"\"")" ]] || log_warn "顶层 description 缺少语言: zh-hant"
      else
        [[ -n "$(yq_read "$file" ".additionalProperties.description[\"$locale\"] // \"\"")" ]] || log_warn "顶层 description 缺少语言: $locale"
      fi
    done
    [[ -n "$(yq_read "$file" '.additionalProperties.architectures[]? // ""')" ]] || log_warn "缺少 architectures"
  elif python3 -c 'import yaml' >/dev/null 2>&1; then
    while IFS=$'\t' read -r level message; do
      [[ -n "$level" ]] || continue
      [[ "$level" == ERROR ]] && log_error "$message" || log_warn "$message"
    done < <(python3 - "$file" "$app_name" <<'PY_TOP'
import sys,yaml
f,dirname=sys.argv[1:3]
d=yaml.safe_load(open(f,encoding='utf-8')) or {}
ap=d.get('additionalProperties') or {}
key=ap.get('key')
if not key:
    print('ERROR\t缺少 additionalProperties.key')
elif str(key)!=dirname:
    print(f'ERROR\tadditionalProperties.key 必须等于目录名: key={key} dir={dirname}')
desc=ap.get('description') or {}
for loc in ['en','es-es','fa','ja','ms','pt-br','ru','ko','zh','tr']:
    if not desc.get(loc): print(f'WARN\t顶层 description 缺少语言: {loc}')
if not (desc.get('zh-hant') or desc.get('zh-Hant')): print('WARN\t顶层 description 缺少语言: zh-hant')
if not ap.get('architectures'): print('WARN\t缺少 architectures')
PY_TOP
)
  else
    grep -q 'key:' "$file" || log_error "data.yml 缺少 additionalProperties.key"
  fi
}

validate_version_form_fields_python() {
  local file="$1"
  python3 - "$file" <<'PY' 2>/dev/null || true
import sys,re
try:
    import yaml
except Exception:
    raise SystemExit(0)
try:
    d=yaml.safe_load(open(sys.argv[1],encoding='utf-8')) or {}
except Exception:
    raise SystemExit(0)
fields=((d.get('additionalProperties') or {}).get('formFields') or [])
seen=set()
for i,f in enumerate(fields):
    if not isinstance(f,dict): continue
    k=f.get('envKey')
    if k:
        if k in seen: print(f'ERROR\t重复 envKey: {k}')
        seen.add(k)
    if str(k or '').startswith('PANEL_APP_PORT_') and str(f.get('default')) in {'80','443'}:
        print(f'ERROR\t默认宿主机端口不应使用 {f.get("default")}: {k}')
    if f.get('type')=='password' and f.get('random') is True:
        dv=str(f.get('default') or '')
        if not dv:
            print(f'ERROR\trandom password 字段 default 不能为空: {k or i}')
        elif not re.match(r'^[A-Za-z0-9]',dv):
            print(f'WARN\trandom password 默认前缀建议以字母/数字开头: {k or i}')
PY
}

validate_version_data_yml() {
  local file="$1" output line level message
  [[ -f "$file" ]] || return 0
  validate_yaml_syntax "$file"
  grep -q 'formFields:' "$file" || log_warn "版本 data.yml 缺少 formFields（无参数时建议显式 []）"
  output=$(validate_version_form_fields_python "$file")
  while IFS=$'\t' read -r level message; do
    [[ -n "$level" ]] || continue
    [[ "$level" == ERROR ]] && log_error "$message" || log_warn "$message"
  done <<< "$output"
}

extract_form_env_keys() {
  local file="$1"
  [[ -f "$file" ]] || return 0
  if has_yq; then yq -r '.additionalProperties.formFields[]?.envKey // empty' "$file" 2>/dev/null || true
  else grep -oE 'envKey:[[:space:]]*[A-Za-z_][A-Za-z0-9_]*' "$file" | awk '{print $2}' || true; fi
}

extract_compose_port_vars() {
  grep -oE '\$\{PANEL_APP_PORT_[A-Z0-9_]+' "$1" | sed 's/^${//' | sort -u || true
}

extract_all_compose_vars() {
  grep -oE '\$\{[A-Za-z_][A-Za-z0-9_]*([}:][-+?][^}]*)?\}' "$1" | sed -E 's/^\$\{//; s/[}:].*$//; s/}$//' | sort -u || true
}

validate_variables() {
  local data_file="$1" compose="$2" defined used var
  defined=$(extract_form_env_keys "$data_file" | sort -u)
  used=$(extract_compose_port_vars "$compose")
  while IFS= read -r var; do
    [[ -z "$var" ]] && continue
    grep -qx "$var" <<< "$defined" || log_error "端口变量 $var 在 Compose 中使用，但未在版本 data.yml 定义"
  done <<< "$used"

  while IFS= read -r var; do
    [[ -z "$var" ]] && continue
    case "$var" in
      CONTAINER_NAME) continue ;;
      PANEL_DB_PORT)
        if grep -q 'envKey:[[:space:]]*PANEL_DB_TYPE' "$data_file" || grep -q 'envKey:[[:space:]]*PANEL_DB_HOST' "$data_file"; then continue; fi ;;
    esac
    if ! grep -qx "$var" <<< "$defined"; then
      log_warn "Compose 变量 $var 未在 formFields 中定义；确认它由 1Panel、env_file 或其他机制提供"
    fi
  done < <(extract_all_compose_vars "$compose")
}

image_tag() {
  local image="$1" last
  [[ "$image" == *@sha256:* ]] && { echo digest; return; }
  last="${image##*/}"; [[ "$last" == *:* ]] && echo "${last##*:}" || echo latest
}

image_repository_without_tag() {
  local image="${1%@sha256:*}" last first
  last="${image##*/}"; [[ "$last" == *:* ]] && image="${image%:*}"
  first="${image%%/*}"
  if [[ "$image" == */* && ( "$first" == *.* || "$first" == *:* || "$first" == localhost ) ]]; then image="${image#*/}"; fi
  echo "$image"
}

is_dependency_image() {
  case "$(image_repository_without_tag "$1")" in
    postgres|postgis/postgis|pgvector/pgvector|redis|valkey/valkey|mysql|mariadb|mongo|memcached|rabbitmq|clickhouse/clickhouse-server|elasticsearch|opensearchproject/opensearch|nginx|caddy|traefik|prom/prometheus|grafana/grafana|minio/minio|getmeili/meilisearch) return 0 ;;
    *) return 1 ;;
  esac
}

is_floating_tag() { case "${1,,}" in latest|stable|main|master|develop|development|dev|edge|nightly|rolling|main-stable|*-latest) return 0 ;; *) return 1 ;; esac; }

validate_image_tags() {
  local version_dir="$1" compose="$2" version image tag primary_seen=false matched=false
  version=$(basename "$version_dir")
  while IFS= read -r image; do
    [[ -n "$image" ]] || continue
    tag=$(image_tag "$image")
    [[ "$tag" == digest ]] && continue
    if ! is_dependency_image "$image" && [[ "$primary_seen" == false ]]; then
      primary_seen=true
      case "$version" in
        latest|stable)
          [[ "$tag" == "$version" ]] || log_warn "浮动目录 $version 的主镜像 tag 为 $tag，请确认通道语义" ;;
        *)
          is_floating_tag "$tag" && log_error "具体版本目录 $version 不应使用浮动主镜像 tag: $image"
          if [[ "$tag" == "$version" || "$tag" == "v$version" || "${tag#v}" == "$version" || "$tag" == "$version"[-_]* || "${tag#v}" == "$version"[-_]* ]]; then matched=true; fi
          ;;
      esac
    fi
  done < <(grep -E '^[[:space:]]*image:[[:space:]]*' "$compose" | sed -E 's/^[[:space:]]*image:[[:space:]]*//; s/[[:space:]]+#.*$//; s/^['"'"'\"]//; s/['"'"'\"]$//' || true)
  if [[ "$version" != latest && "$version" != stable && "$primary_seen" == true && "$matched" != true ]]; then
    log_warn "主应用镜像 tag 未明显匹配版本目录 $version，请人工确认"
  fi
}

validate_logo_file() {
  local f="$1" mime
  [[ -f "$f" ]] || return 0
  if head -c 512 "$f" | grep -qiE '<!doctype|<html|<Error>|AccessDenied'; then log_error "logo.png 像 HTML/XML 错误响应，不是真实图标"; return; fi
  if command -v file >/dev/null 2>&1; then
    mime=$(file -b --mime-type "$f" 2>/dev/null || true)
    [[ "$mime" == image/* || "$DRAFT" == true ]] || log_warn "logo.png MIME 不是 image/*: $mime"
  fi
}

validate_env_files() {
  local version_dir="$1" compose="$2" f
  while IFS= read -r f; do
    [[ -n "$f" ]] || continue
    f="${f#- }"; f="${f%\"}"; f="${f#\"}"; f="${f%\'}"; f="${f#\'}"
    [[ "$f" == /* ]] && { log_warn "env_file 使用绝对路径: $f"; continue; }
    [[ -f "$version_dir/$f" ]] || log_warn "env_file 在版本目录中不存在: $f（确认安装时会提供）"
  done < <(awk '
    /^[[:space:]]*env_file:[[:space:]]*$/ {in_env=1; next}
    in_env && /^[[:space:]]*-[[:space:]]*/ {line=$0; sub(/^[[:space:]]*-[[:space:]]*/,"",line); print line; next}
    in_env && !/^[[:space:]]/ {in_env=0}
  ' "$compose")
}

validate_websocket_urls() {
  local compose="$1" match host
  while IFS= read -r match; do
    [[ -n "$match" ]] || continue
    host=$(sed -E 's#^wss?://([^/:]+).*#\1#' <<< "$match")
    if [[ "$host" != *.* && "$host" != localhost && ! "$host" =~ ^[0-9]+(\.[0-9]+){3}$ ]]; then
      log_warn "发现可能暴露给浏览器的 Docker 内部 WebSocket 主机: $match；确认客户端不会直接访问该 hostname"
    fi
  done < <(grep -oE 'wss?://[A-Za-z0-9_-]+:[0-9]+' "$compose" | sort -u || true)
}

validate_docker_compose() {
  local file="$1"
  [[ -f "$file" ]] || return 0
  validate_yaml_syntax "$file"
  grep -q '1panel-network:' "$file" || log_error "Compose 缺少 1panel-network"
  grep -q 'external:[[:space:]]*true' "$file" || log_error "1panel-network 应为 external: true"
  if grep -q 'container_name:' "$file" && ! grep -Fq 'container_name: ${CONTAINER_NAME}' "$file"; then
    log_warn "存在 container_name，但未发现主服务使用 \${CONTAINER_NAME}"
  fi
  grep -Eq "createdBy:[[:space:]]*[\"']?Apps" "$file" || log_warn "建议给主服务添加 createdBy: Apps"

  if python3 - "$file" <<'PY_PORT'
import re,sys
try:
    import yaml
except Exception:
    raise SystemExit(1)
try:
    data=yaml.safe_load(open(sys.argv[1],encoding='utf-8')) or {}
except Exception:
    raise SystemExit(1)
bad=False
for svc in (data.get('services') or {}).values():
    if not isinstance(svc,dict):
        continue
    for item in svc.get('ports') or []:
        published=None
        if isinstance(item,dict):
            published=item.get('published')
        elif isinstance(item,(str,int)):
            text=str(item).strip()
            # [host-ip:]published:target[/proto]. A single port means no static host remap.
            text=text.split('/',1)[0]
            parts=text.rsplit(':',2)
            if len(parts)>=2 and str(parts[-2]).isdigit():
                published=parts[-2]
        if str(published) in {'80','443'}:
            bad=True
raise SystemExit(0 if bad else 1)
PY_PORT
  then
    log_error "Compose 不应静态绑定宿主机 80/443；请改用 PANEL_APP_PORT_* 可配置端口"
  fi

  if python3 - "$file" <<'PY_VOL'
import re,sys
allowed=(
 '/var/run/docker.sock','/run','/tmp','/etc/localtime','/etc/timezone','/dev/net/tun'
)
warn=False
for raw in open(sys.argv[1],encoding='utf-8'):
    s=raw.strip()
    if not s.startswith('- '):
        continue
    x=s[2:].strip().strip('"\'')
    # Ignore Windows drive syntax and variable-based sources.
    if ':' not in x or x.startswith('${'):
        continue
    src=x.split(':',1)[0]
    if src.startswith('/'):
        if src in allowed or src.startswith('/var/run/') or src.startswith('/run/') or src.startswith('/tmp/') or src.startswith('/proc/') or src.startswith('/sys/'):
            continue
        warn=True
raise SystemExit(0 if warn else 1)
PY_VOL
  then
    log_warn "检测到绝对宿主机数据卷；优先改为 ./data/...，除非该绝对路径是应用必需的宿主机资源"
  fi
  validate_websocket_urls "$file"
}

main() {
  parse_args "$@"
  local app_dir="${POSITIONAL[0]:-}" version_dirs dir
  [[ -n "$app_dir" ]] || { print_help; exit 0; }
  [[ -d "$app_dir" ]] || { log_error "目录不存在: $app_dir"; exit 1; }
  echo -e "${BLUE}=== 1Panel App Validator ===${NC}"
  check_directory_structure "$app_dir"
  validate_top_data_yml "$app_dir/data.yml"
  validate_logo_file "$app_dir/logo.png"
  version_dirs=$(find_version_dirs "$app_dir" || true)
  while IFS= read -r dir; do
    [[ -n "$dir" ]] || continue
    validate_version_data_yml "$dir/data.yml"
    validate_docker_compose "$dir/docker-compose.yml"
    validate_variables "$dir/data.yml" "$dir/docker-compose.yml"
    validate_image_tags "$dir" "$dir/docker-compose.yml"
    validate_env_files "$dir" "$dir/docker-compose.yml"
  done <<< "$version_dirs"
  echo
  echo -e "${BLUE}=== 验证结果 ===${NC}"
  if [[ $ERRORS -eq 0 && $WARNINGS -eq 0 ]]; then echo -e "${GREEN}✓ 验证通过，未发现问题。${NC}"; exit 0
  elif [[ $ERRORS -eq 0 ]]; then echo -e "${YELLOW}⚠ 验证通过，但有 $WARNINGS 个警告。${NC}"; exit 0
  else echo -e "${RED}✗ 验证失败：$ERRORS 个错误，$WARNINGS 个警告。${NC}"; exit 1; fi
}

main "$@"

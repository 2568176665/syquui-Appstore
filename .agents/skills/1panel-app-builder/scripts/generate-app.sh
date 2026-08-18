#!/usr/bin/env bash

# 1Panel App Builder - safe draft generator
# Converts a verified single-service Docker deployment into a pinned 1Panel app draft.

set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OUTPUT_BASE="./apps"
ICON_MODE="auto"
ICON_URL=""
ICON_CACHE_DIR="${SCRIPT_DIR}/../.cache/icons"
USER_APP_KEY=""
USER_APP_NAME=""
USER_VERSION=""
USER_SERVICE=""
ARCHITECTURES="amd64"
FORCE=false
DRY_RUN=false
CHECK_DEPS_ONLY=false
RESOLVE_VERSION=false
CROSS_VERSION_UPDATE=false
ALLOW_PARTIAL_COMPOSE=false
ALLOW_LOSSY=false
POSITIONAL=()
SERVICE_VOLUMES=()
SERVICE_ENV=()
SERVICE_ENV_FILES=()
SERVICE_COMMAND_JSON=""
LOSSY_ITEMS=()
DOCKER_RUN_CONTENT=""
COMPOSE_CONTENT=""
GITHUB_API_BASE_URL="${GITHUB_API_BASE_URL:-https://api.github.com/repos}"
GITHUB_RAW_BASE_URL="${GITHUB_RAW_BASE_URL:-https://raw.githubusercontent.com}"

log_info() { echo -e "${GREEN}[INFO]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1" >&2; }

print_help() {
  cat <<EOF_HELP
${BLUE}1Panel App Builder${NC} - 生成生产导向的 1Panel 应用草稿

${YELLOW}用法:${NC}
  $0 [选项] <输入源> [输出目录]

${YELLOW}输入源:${NC}
  - GitHub 项目 URL
  - docker-compose.yml / compose.yml URL
  - 本地 Compose 文件
  - 单行 docker run 命令

${YELLOW}默认安全策略:${NC}
  - 只生成一个固定版本目录，不生成 latest/stable
  - 优先保留来源中的具体镜像 tag
  - 多服务 Compose 默认拒绝“抽掉依赖”
  - 不凭空添加 /app/data、PUID/PGID 等来源中不存在的配置
  - 遇到无法无损保留的 Compose 字段时默认拒绝生成

${YELLOW}选项:${NC}
  --output <目录>              输出目录（默认 ./apps）
  --app-key <key>              应用目录 key
  --name <名称>                应用显示名
  --service <服务名>           多服务 Compose 中选择主服务
  --version <tag>              固定镜像 tag/版本（推荐显式指定）
  --resolve-version            来源是 latest/stable 时尝试从 registry 找具体版本
  --architectures <csv>        元数据架构（默认 amd64，例如 amd64,arm64）
  --cross-version-update       将 crossVersionUpdate 设为 true（默认 false）
  --allow-partial-compose      允许从多服务 Compose 只抽一个服务（仅草稿）
  --allow-lossy                允许丢弃生成器不支持的字段（仅草稿）
  --icon-mode <模式>           auto|required|skip|cache-only
  --icon-url <URL>             使用指定图标 URL
  --force                      覆盖已有输出目录
  --dry-run                    只解析，不写文件
  --check-deps                 只检查依赖
  -h, --help                   显示帮助
EOF_HELP
}

normalize_app_key() {
  echo "$1" | tr '[:upper:]' '[:lower:]' | tr ' _' '--' | tr -cd 'a-z0-9.-'
}

yaml_quote() {
  local s="$1"
  s="${s//\\/\\\\}"
  s="${s//\"/\\\"}"
  s="${s//$'\n'/\\n}"
  s="${s//$'\r'/\\r}"
  s="${s//$'\t'/\\t}"
  printf '"%s"\n' "$s"
}

check_dependencies() {
  local missing=() dep
  for dep in curl jq python3; do
    command -v "$dep" >/dev/null 2>&1 || missing+=("$dep")
  done
  if ((${#missing[@]})); then
    log_error "缺少依赖: ${missing[*]}"
    log_info "generate-app.sh 需要 curl、jq 和 python3（含 PyYAML）"
    return 1
  fi
  if ! python3 -c "import yaml" >/dev/null 2>&1; then
    log_error "缺少 Python 模块 PyYAML（import yaml 失败）"
    return 1
  fi
}

parse_args() {
  POSITIONAL=()
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --output|-o) OUTPUT_BASE="${2:-}"; shift 2 ;;
      --app-key) USER_APP_KEY="${2:-}"; shift 2 ;;
      --name) USER_APP_NAME="${2:-}"; shift 2 ;;
      --service) USER_SERVICE="${2:-}"; shift 2 ;;
      --version) USER_VERSION="${2:-}"; shift 2 ;;
      --resolve-version) RESOLVE_VERSION=true; shift ;;
      --architectures) ARCHITECTURES="${2:-}"; shift 2 ;;
      --cross-version-update) CROSS_VERSION_UPDATE=true; shift ;;
      --allow-partial-compose) ALLOW_PARTIAL_COMPOSE=true; shift ;;
      --allow-lossy) ALLOW_LOSSY=true; shift ;;
      --icon-mode) ICON_MODE="${2:-}"; shift 2 ;;
      --icon-url) ICON_URL="${2:-}"; shift 2 ;;
      --force) FORCE=true; shift ;;
      --dry-run) DRY_RUN=true; shift ;;
      --check-deps) CHECK_DEPS_ONLY=true; shift ;;
      -h|--help) print_help; exit 0 ;;
      --) shift; POSITIONAL+=("$@"); break ;;
      -*) log_error "未知选项: $1"; exit 2 ;;
      *) POSITIONAL+=("$1"); shift ;;
    esac
  done

  case "$ICON_MODE" in auto|required|skip|cache-only) ;; *) log_error "无效图标模式: $ICON_MODE"; exit 2 ;; esac
  [[ ${#POSITIONAL[@]} -le 1 ]] || OUTPUT_BASE="${POSITIONAL[1]}"
  [[ -n "$ARCHITECTURES" ]] || { log_error "--architectures 不能为空"; exit 2; }
}

parse_image_ref() {
  local image_ref="$1" image_no_tag tag first_segment
  image_ref="${image_ref%%@*}"
  if [[ "$image_ref" =~ ^(.+):([^/:]+)$ ]]; then
    image_no_tag="${BASH_REMATCH[1]}"; tag="${BASH_REMATCH[2]}"
  else
    image_no_tag="$image_ref"; tag="latest"
  fi
  first_segment="${image_no_tag%%/*}"
  if [[ "$image_no_tag" == */* ]] && ([[ "$first_segment" == *.* ]] || [[ "$first_segment" == *:* ]] || [[ "$first_segment" == localhost ]]); then
    REGISTRY="$first_segment"; IMAGE_PATH="${image_no_tag#*/}"
  else
    REGISTRY="docker.io"; IMAGE_PATH="$image_no_tag"
  fi
  if [[ "$IMAGE_PATH" == */* ]]; then
    NAMESPACE="${IMAGE_PATH%%/*}"; REPO_PATH="${IMAGE_PATH#*/}"
  else
    NAMESPACE="library"; REPO_PATH="$IMAGE_PATH"
  fi
  IMAGE_BASE="$image_no_tag"; TAG="$tag"
}

is_floating_tag() {
  case "${1,,}" in latest|stable|main|master|develop|development|dev|edge|nightly|rolling) return 0 ;; *) return 1 ;; esac
}

get_latest_tag_docker_hub() {
  local url="https://hub.docker.com/v2/repositories/$1/$2/tags?page_size=100&ordering=last_updated" tags semver
  tags=$(curl -fsSL --connect-timeout 5 --max-time 20 "$url" | jq -r '.results[].name' 2>/dev/null || true)
  semver=$(printf '%s\n' "$tags" | grep -E '^[vV]?[0-9]+\.[0-9]+(\.[0-9]+)?([._-][0-9A-Za-z.-]+)?$' | grep -viE '(alpha|beta|rc|preview|dev|nightly)' | sort -V | tail -n1 || true)
  printf '%s\n' "$semver"
}

get_latest_tag_ghcr() {
  local token tags semver
  token=$(curl -fsSL --connect-timeout 5 --max-time 20 "https://ghcr.io/token?service=ghcr.io&scope=repository:$1/$2:pull" | jq -r '.token // empty' 2>/dev/null || true)
  [[ -n "$token" ]] || return 0
  tags=$(curl -fsSL --connect-timeout 5 --max-time 20 -H "Authorization: Bearer $token" "https://ghcr.io/v2/$1/$2/tags/list" | jq -r '.tags[]?' 2>/dev/null || true)
  semver=$(printf '%s\n' "$tags" | grep -E '^[vV]?[0-9]+\.[0-9]+(\.[0-9]+)?([._-][0-9A-Za-z.-]+)?$' | grep -viE '(alpha|beta|rc|preview|dev|nightly)' | sort -V | tail -n1 || true)
  printf '%s\n' "$semver"
}

get_latest_tag() {
  case "$REGISTRY" in
    ghcr.io) get_latest_tag_ghcr "$NAMESPACE" "$REPO_PATH" ;;
    docker.io) get_latest_tag_docker_hub "$NAMESPACE" "$REPO_PATH" ;;
    *) return 0 ;;
  esac
}

parse_port_entry() {
  local entry="$1"
  entry="${entry%\"}"; entry="${entry#\"}"; entry="${entry%\'}"; entry="${entry#\'}"
  [[ "$entry" == */* ]] && entry="${entry%/*}"
  IFS=':' read -r -a parts <<< "$entry"
  local n=${#parts[@]} host_port container_port
  if ((n==1)); then host_port="${parts[0]}"; container_port="${parts[0]}"
  elif ((n==2)); then host_port="${parts[0]}"; container_port="${parts[1]}"
  else host_port="${parts[n-2]}"; container_port="${parts[n-1]}"
  fi
  printf '%s:%s\n' "$host_port" "$container_port"
}

safe_default_host_port() {
  local port="$1" index="$2" candidate occupied used
  case "$port" in
    80) candidate=$((10080 + index)) ;;
    443) candidate=$((10443 + index)) ;;
    *) echo "$port"; return 0 ;;
  esac
  while :; do
    occupied=false
    for used in "${USED_HOST_PORTS[@]:-}"; do [[ "$used" == "$candidate" ]] && occupied=true && break; done
    [[ "$occupied" == false ]] && { echo "$candidate"; return 0; }
    candidate=$((candidate + 1))
  done
}

map_port_envkey() {
  local port="$1" index="$2"
  case "$port" in
    80|8080|3000|5173|8000|5000) echo PANEL_APP_PORT_HTTP ;;
    443|8443) echo PANEL_APP_PORT_HTTPS ;;
    22) echo PANEL_APP_PORT_SSH ;;
    3306|5432|27017|6379) echo PANEL_APP_PORT_DB ;;
    9000|9001|8081|7001) echo PANEL_APP_PORT_API ;;
    *) [[ "$index" -eq 0 ]] && echo PANEL_APP_PORT_HTTP || echo PANEL_APP_PORT_API ;;
  esac
}

labels_for_envkey() {
  case "$1" in
    PANEL_APP_PORT_HTTP) echo 'Web Port|Web端口' ;;
    PANEL_APP_PORT_HTTPS) echo 'HTTPS Port|HTTPS端口' ;;
    PANEL_APP_PORT_API) echo 'API Port|API端口' ;;
    PANEL_APP_PORT_ADMIN) echo 'Admin Port|管理端口' ;;
    PANEL_APP_PORT_PROXY) echo 'Proxy Port|代理端口' ;;
    PANEL_APP_PORT_DB) echo 'DB Port|数据库端口' ;;
    PANEL_APP_PORT_SSH) echo 'SSH Port|SSH端口' ;;
    PANEL_APP_PORT_S3) echo 'S3 Port|S3端口' ;;
    PANEL_APP_PORT_PROXY_HTTP) echo 'Proxy HTTP Port|代理HTTP端口' ;;
    PANEL_APP_PORT_PROXY_HTTPS) echo 'Proxy HTTPS Port|代理HTTPS端口' ;;
    PANEL_APP_PORT_SYNC) echo 'Sync Port|同步端口' ;;
    *) echo 'Port|端口' ;;
  esac
}

detect_input_type() {
  local input="$1"
  if [[ "$input" =~ ^https?://github\.com/[^/]+/[^/]+ ]]; then echo github
  elif [[ -f "$input" && "$input" =~ \.ya?ml$ ]]; then echo compose_file
  elif [[ "$input" =~ ^https?://.*(docker-)?compose[^/]*\.ya?ml([?].*)?$ ]] || [[ "$input" =~ ^https?://.*\.ya?ml([?].*)?$ ]]; then echo compose_url
  elif [[ "$input" =~ ^docker[[:space:]]+run([[:space:]]|$) ]]; then echo docker_run
  else echo unknown
  fi
}

extract_from_github() {
  local github_url="$1" owner_repo api_url repo_info
  owner_repo=$(echo "$github_url" | sed -E 's|https?://github.com/||; s|/$||; s|\.git$||')
  api_url="${GITHUB_API_BASE_URL%/}/${owner_repo}"
  repo_info=$(curl -fsSL --connect-timeout 5 --max-time 20 "$api_url" 2>/dev/null || echo '{}')
  APP_NAME=$(echo "$repo_info" | jq -r '.name // empty')
  APP_KEY=$(normalize_app_key "$APP_NAME")
  DESCRIPTION=$(echo "$repo_info" | jq -r '.description // empty')
  GITHUB="$github_url"
  WEBSITE=$(echo "$repo_info" | jq -r '.homepage // empty')
  [[ -n "$WEBSITE" ]] || WEBSITE="$github_url"
  DEFAULT_BRANCH=$(echo "$repo_info" | jq -r '.default_branch // "main"')
  COMPOSE_CONTENT=$(discover_github_compose "$owner_repo" "$DEFAULT_BRANCH")
  [[ -n "$COMPOSE_CONTENT" ]] || DOCKER_RUN_CONTENT=$(discover_github_docker_run "$owner_repo" "$DEFAULT_BRANCH")
  if [[ -z "$COMPOSE_CONTENT" && -z "$DOCKER_RUN_CONTENT" ]]; then
    log_error "未发现常见生产 Compose 或可解析的 docker run；请提供明确部署文件"
    exit 1
  fi
}

discover_github_compose() {
  local owner_repo="$1" default_branch="$2" branch path url content
  local branches=("$default_branch")
  [[ "$default_branch" == main ]] || branches+=(main)
  [[ "$default_branch" == master ]] || branches+=(master)
  local paths=(docker-compose.production.yml docker-compose.production.yaml compose.production.yml compose.production.yaml docker-compose.yml docker-compose.yaml compose.yml compose.yaml deploy/docker-compose.yml deploy/docker-compose.yaml docker/docker-compose.yml docker/docker-compose.yaml)
  for branch in "${branches[@]}"; do
    for path in "${paths[@]}"; do
      url="${GITHUB_RAW_BASE_URL%/}/${owner_repo}/${branch}/${path}"
      content=$(curl -fsSL --connect-timeout 5 --max-time 20 "$url" 2>/dev/null || true)
      if [[ -n "$content" ]] && printf '%s\n' "$content" | python3 "$SCRIPT_DIR/compose-helper.py" validate >/dev/null 2>&1; then
        log_info "发现 Compose: $path ($branch)" >&2
        printf '%s\n' "$content"; return 0
      fi
    done
  done
}

discover_github_docker_run() {
  local owner_repo="$1" default_branch="$2" branch path url content line
  local branches=("$default_branch")
  [[ "$default_branch" == main ]] || branches+=(main)
  [[ "$default_branch" == master ]] || branches+=(master)
  for branch in "${branches[@]}"; do
    for path in README.md README_en.md docs/README.md; do
      url="${GITHUB_RAW_BASE_URL%/}/${owner_repo}/${branch}/${path}"
      content=$(curl -fsSL --connect-timeout 5 --max-time 20 "$url" 2>/dev/null || true)
      [[ -n "$content" ]] || continue
      line=$(printf '%s\n' "$content" | python3 -c 'import sys,re; s=sys.stdin.read(); s=re.sub(r"\\\\\n\s*", " ", s); m=re.search(r"(^|\n)\s*(docker\s+run\s+[^\n`]+)", s); print(m.group(2).strip() if m else "")')
      if [[ -n "$line" ]]; then log_info "发现 README docker run: $path ($branch)" >&2; printf '%s\n' "$line"; return 0; fi
    done
  done
}

inspect_compose() {
  printf '%s\n' "$COMPOSE_CONTENT" | python3 "$SCRIPT_DIR/compose-helper.py" inspect-all
}

check_compose_lossiness_json() {
  local service="$1" service_json="$2" unsupported="" key volume
  while IFS= read -r key; do
    [[ -z "$key" ]] && continue
    case "$key" in image|ports|volumes|environment|env_file|restart|networks|container_name|labels) ;;
      *) unsupported+=" $key" ;;
    esac
  done < <(jq -r '.keys[]?' <<< "$service_json")
  if [[ -n "$unsupported" ]]; then
    if [[ "$ALLOW_LOSSY" != true ]]; then
      log_error "服务 $service 含生成器不会无损保留的字段:$unsupported"
      log_error "请手工打包，或仅为草稿显式加 --allow-lossy"
      exit 1
    fi
    log_warn "--allow-lossy: 将忽略字段:$unsupported"
  fi
  while IFS= read -r volume; do
    [[ -z "$volume" ]] && continue
    if [[ "$volume" == __LONG__* || "$volume" == __LONG_INVALID__* ]]; then
      if [[ "$ALLOW_LOSSY" != true ]]; then
        log_error "检测到 volumes 长语法；生成器不会安全重写。请手工打包或加 --allow-lossy（仅草稿）"
        exit 1
      fi
      log_warn "--allow-lossy: 忽略 volumes 长语法: ${volume#__LONG__}"
    fi
  done < <(jq -r '.volumes[]?' <<< "$service_json")
}

extract_from_compose() {
  COMPOSE_CONTENT="$1"
  local inspect service_count names image line service_json parsed_path
  inspect=$(inspect_compose)
  service_count=$(jq -r '.count' <<< "$inspect")
  names=$(jq -r '.names[]' <<< "$inspect")
  if [[ "$service_count" -gt 1 ]]; then
    if [[ -z "$USER_SERVICE" ]]; then
      log_error "检测到 $service_count 个服务：$(tr '\n' ' ' <<< "$names")"
      log_error "为避免丢失 DB/Redis/worker/init 依赖，默认不抽取单服务。请手工保留完整 Compose；若只做草稿，使用 --service <name> --allow-partial-compose"
      exit 1
    fi
    if [[ "$ALLOW_PARTIAL_COMPOSE" != true ]]; then
      log_error "多服务 Compose 选择了 --service，但未确认允许丢弃其他服务。草稿请加 --allow-partial-compose"
      exit 1
    fi
    log_warn "--allow-partial-compose: 仅生成 $USER_SERVICE，其他服务将被丢弃。最终发布前必须人工补回或替换依赖。"
  fi

  if [[ -n "$USER_SERVICE" ]]; then
    SERVICE_NAME="$USER_SERVICE"
    grep -qxF "$SERVICE_NAME" <<< "$names" || { log_error "Compose 中不存在服务: $SERVICE_NAME"; exit 1; }
  else
    SERVICE_NAME=$(jq -r '.names[0] // ""' <<< "$inspect")
  fi
  [[ -n "$SERVICE_NAME" ]] || { log_error "Compose 中没有可用服务"; exit 1; }
  service_json=$(jq -c --arg s "$SERVICE_NAME" '.services[$s] // empty' <<< "$inspect")
  [[ -n "$service_json" ]] || { log_error "无法读取服务: $SERVICE_NAME"; exit 1; }
  check_compose_lossiness_json "$SERVICE_NAME" "$service_json"

  image=$(jq -r '.image // ""' <<< "$service_json")
  [[ -n "$image" ]] || { log_error "服务 $SERVICE_NAME 缺少 image；build-only Compose 需手工打包"; exit 1; }
  parse_image_ref "$image"

  PORT_ENTRIES=()
  while IFS= read -r line; do
    [[ -n "$line" ]] || continue
    [[ "$line" == __LONG_INVALID__* ]] && { log_error "无法解析端口长语法: ${line#__LONG_INVALID__}"; exit 1; }
    PORT_ENTRIES+=("$line")
  done < <(jq -r '.ports[]?' <<< "$service_json")

  SERVICE_VOLUMES=()
  while IFS= read -r line; do
    [[ -n "$line" ]] || continue
    [[ "$line" == __LONG__* ]] && continue
    SERVICE_VOLUMES+=("$line")
  done < <(jq -r '.volumes[]?' <<< "$service_json")

  SERVICE_ENV=()
  while IFS= read -r line; do
    [[ -n "$line" ]] || continue
    [[ "$line" == __INVALID__* ]] && { log_error "无法解析 environment: ${line#__INVALID__}"; exit 1; }
    SERVICE_ENV+=("$line")
  done < <(jq -r '.environment[]?' <<< "$service_json")

  SERVICE_ENV_FILES=()
  while IFS= read -r line; do
    [[ -n "$line" ]] || continue
    if [[ "$line" == __LONG__* ]]; then
      if [[ "$ALLOW_LOSSY" != true ]]; then
        log_error "env_file 使用长语法，生成器不会无损保留；请手工打包或加 --allow-lossy（仅草稿）"
        exit 1
      fi
      parsed_path=$(jq -r 'try (fromjson | .path // "") catch ""' <<< "${line#__LONG__}")
      if [[ -n "$parsed_path" ]]; then
        SERVICE_ENV_FILES+=("$parsed_path")
        log_warn "--allow-lossy: env_file 长语法仅保留 path=$parsed_path"
      else
        log_warn "--allow-lossy: env_file 长语法无法提取 path，已忽略"
      fi
      continue
    fi
    SERVICE_ENV_FILES+=("$line")
  done < <(jq -r '.env_file[]?' <<< "$service_json")
  if ((${#SERVICE_ENV_FILES[@]})); then
    log_warn "来源使用 env_file；生成器只保留路径，不会复制可能含密钥的文件。发布前必须确认对应文件会被提供。"
  fi
  log_info "服务: $SERVICE_NAME / 镜像: $IMAGE_BASE:$TAG / 端口: ${#PORT_ENTRIES[@]}"
}

extract_from_docker_run() {
  local cmd="$1" args=() i=0 image_ref="" arg
  while IFS= read -r line; do args+=("$line"); done < <(python3 - "$cmd" <<'PY'
import shlex,sys
for x in shlex.split(sys.argv[1]): print(x)
PY
)
  [[ "${args[0]:-}" == docker && "${args[1]:-}" == run ]] && i=2
  SERVICE_NAME=app; PORT_ENTRIES=(); SERVICE_VOLUMES=(); SERVICE_ENV=(); SERVICE_ENV_FILES=(); LOSSY_ITEMS=(); SERVICE_COMMAND_JSON=""
  while ((i < ${#args[@]})); do
    arg="${args[$i]}"
    case "$arg" in
      --name=*) SERVICE_NAME="${arg#--name=}" ;;
      --name) ((i+=1)); SERVICE_NAME="${args[$i]:-app}" ;;
      -p|--publish) ((i+=1)); PORT_ENTRIES+=("${args[$i]:-}") ;;
      -p=*|--publish=*) PORT_ENTRIES+=("${arg#*=}") ;;
      -v|--volume) ((i+=1)); SERVICE_VOLUMES+=("${args[$i]:-}") ;;
      -v=*|--volume=*) SERVICE_VOLUMES+=("${arg#*=}") ;;
      -e|--env) ((i+=1)); SERVICE_ENV+=("${args[$i]:-}") ;;
      -e=*|--env=*) SERVICE_ENV+=("${arg#*=}") ;;
      --env-file) ((i+=1)); SERVICE_ENV_FILES+=("${args[$i]:-}") ;;
      --env-file=*) SERVICE_ENV_FILES+=("${arg#--env-file=}") ;;
      -d|--detach|--rm|-i|-t|-it|-ti|--init) ;;
      --restart|--network|--hostname|--user|--workdir|--entrypoint|--add-host|--dns|--cap-add|--device|--security-opt|--shm-size)
        LOSSY_ITEMS+=("$arg"); ((i+=1)) ;;
      --restart=*|--network=*|--hostname=*|--user=*|--workdir=*|--entrypoint=*|--add-host=*|--dns=*|--cap-add=*|--device=*|--security-opt=*|--shm-size=*|--privileged)
        LOSSY_ITEMS+=("${arg%%=*}") ;;
      --) ((i+=1)); image_ref="${args[$i]:-}"; ((i+=1)); break ;;
      -*) LOSSY_ITEMS+=("$arg"); if [[ "$arg" != *=* && "${args[$((i+1))]:-}" != -* && -n "${args[$((i+1))]:-}" ]]; then ((i+=1)); fi ;;
      *) image_ref="$arg"; ((i+=1)); break ;;
    esac
    ((i+=1))
  done
  [[ -n "$image_ref" ]] || { log_error "未能从 docker run 中解析镜像"; exit 1; }
  if ((${#LOSSY_ITEMS[@]})) && [[ "$ALLOW_LOSSY" != true ]]; then
    log_error "docker run 含生成器不会无损保留的选项: ${LOSSY_ITEMS[*]}"
    log_error "请手工打包，或仅为草稿显式加 --allow-lossy"
    exit 1
  fi
  ((${#LOSSY_ITEMS[@]}==0)) || log_warn "--allow-lossy: 忽略选项 ${LOSSY_ITEMS[*]}"
  if ((i < ${#args[@]})); then
    SERVICE_COMMAND_JSON=$(python3 - "${args[@]:$i}" <<'PY'
import json,sys
print(json.dumps(sys.argv[1:], ensure_ascii=False))
PY
)
  fi
  parse_image_ref "$image_ref"
  APP_NAME="$SERVICE_NAME"; APP_KEY=$(normalize_app_key "$SERVICE_NAME")
}

generate_top_data_yml() {
  local out="$1" desc_en desc_zh
  desc_zh="${DESCRIPTION:-自动生成的 1Panel 应用草稿，请在发布前核对上游文档。}"
  desc_en="${DESCRIPTION:-Auto-generated 1Panel app draft. Verify upstream documentation before release.}"
  {
    echo "name: $(yaml_quote "${APP_NAME:-MyApp}")"
    echo 'tags:'; echo '  - 实用工具'; echo '  - 容器'
    echo "title: $(yaml_quote "${APP_NAME:-MyApp}")"
    echo "description: $(yaml_quote "$desc_zh")"
    echo 'additionalProperties:'
    echo "  key: ${APP_KEY:-myapp}"
    echo "  name: $(yaml_quote "${APP_NAME:-MyApp}")"
    echo '  tags:'; echo '    - Utility'; echo '    - Container'
    echo "  shortDescZh: $(yaml_quote "$desc_zh")"
    echo "  shortDescEn: $(yaml_quote "$desc_en")"
    echo '  description:'
    for locale in en es-es fa ja ms pt-br ru ko tr; do echo "    $locale: $(yaml_quote "$desc_en")"; done
    echo "    zh-hant: $(yaml_quote "$desc_zh")"
    echo "    zh: $(yaml_quote "$desc_zh")"
    echo '  type: website'
    echo "  crossVersionUpdate: $CROSS_VERSION_UPDATE"
    echo '  limit: 0'; echo '  recommend: 50'
    echo "  website: $(yaml_quote "${WEBSITE:-${GITHUB:-}}")"
    echo "  github: $(yaml_quote "${GITHUB:-}")"
    echo "  document: $(yaml_quote "${DOCUMENT:-${GITHUB:-}}")"
    echo '  architectures:'
    IFS=',' read -r -a archs <<< "$ARCHITECTURES"
    local arch; for arch in "${archs[@]}"; do arch="${arch// /}"; [[ -n "$arch" ]] && echo "    - $arch"; done
  } > "$out"
}

generate_version_data_yml() {
  local out="$1" i labels en zh locale
  echo 'additionalProperties:' > "$out"; echo '  formFields:' >> "$out"
  if ((${#CONTAINER_PORTS[@]}==0)); then echo '    []' >> "$out"; return; fi
  for ((i=0;i<${#CONTAINER_PORTS[@]};i++)); do
    labels=$(labels_for_envkey "${PORT_ENV_KEYS[$i]}"); en="${labels%%|*}"; zh="${labels##*|}"
    cat >> "$out" <<EOF_FIELD
    - default: ${HOST_PORTS[$i]}
      edit: true
      envKey: ${PORT_ENV_KEYS[$i]}
      labelEn: $(yaml_quote "$en")
      labelZh: $(yaml_quote "$zh")
      required: true
      rule: paramPort
      type: number
      label:
EOF_FIELD
    for locale in en es-es fa ja ms pt-br ru ko tr; do echo "        $locale: $(yaml_quote "$en")" >> "$out"; done
    echo "        zh-hant: $(yaml_quote "$zh")" >> "$out"
    echo "        zh: $(yaml_quote "$zh")" >> "$out"
  done
}

generate_docker_compose() {
  local out="$1" image_tag="$2" i volume env env_file
  {
    echo 'services:'
    echo "  ${SERVICE_NAME:-app}:"
    echo '    container_name: ${CONTAINER_NAME}'
    echo '    restart: always'
    echo '    networks:'; echo '      - 1panel-network'
    if ((${#CONTAINER_PORTS[@]})); then
      echo '    ports:'
      for ((i=0;i<${#CONTAINER_PORTS[@]};i++)); do echo "      - \"\${${PORT_ENV_KEYS[$i]}}:${CONTAINER_PORTS[$i]}\""; done
    fi
    if ((${#SERVICE_VOLUMES[@]})); then
      echo '    volumes:'
      for volume in "${SERVICE_VOLUMES[@]}"; do echo "      - $(yaml_quote "$volume")"; done
    fi
    if ((${#SERVICE_ENV[@]})); then
      echo '    environment:'
      for env in "${SERVICE_ENV[@]}"; do echo "      - $(yaml_quote "$env")"; done
    fi
    if ((${#SERVICE_ENV_FILES[@]})); then
      echo '    env_file:'
      for env_file in "${SERVICE_ENV_FILES[@]}"; do echo "      - $(yaml_quote "$env_file")"; done
    fi
    [[ -z "$SERVICE_COMMAND_JSON" ]] || echo "    command: $SERVICE_COMMAND_JSON"
    echo "    image: ${IMAGE_BASE}:${image_tag}"
    echo '    labels:'; echo '      createdBy: "Apps"'
    echo 'networks:'; echo '  1panel-network:'; echo '    external: true'
  } > "$out"
}

generate_readme() {
  local dir="$1"
  cat > "$dir/README.md" <<EOF_MD
# ${APP_NAME:-MyApp}

## 简介

${DESCRIPTION:-这是由 1Panel App Builder 生成的草稿。正式发布前请核对上游生产部署文档、镜像版本、持久化和升级流程。}

## 安装说明

1. 在 1Panel 本地应用商店中安装。
2. 核对端口、数据目录和外部依赖。
3. 如使用反向代理/HTTPS/WebSocket，请按应用官方文档配置。
4. 升级前备份并验证该版本的迁移步骤。

## 来源

- 官网: ${WEBSITE:-}
- GitHub: ${GITHUB:-}
EOF_MD
  cat > "$dir/README_en.md" <<EOF_MD
# ${APP_NAME:-MyApp}

## Introduction

${DESCRIPTION:-This is a draft generated by 1Panel App Builder. Verify the upstream production deployment, image version, persistence, and upgrade flow before release.}

## Installation

1. Install from the 1Panel local App Store.
2. Verify ports, persistent storage, and external dependencies.
3. Configure reverse proxy/HTTPS/WebSocket according to upstream documentation when required.
4. Back up data and verify migrations before upgrades.

## Sources

- Website: ${WEBSITE:-}
- GitHub: ${GITHUB:-}
EOF_MD
}

download_icon() {
  local args=(--mode "$ICON_MODE" --cache-dir "$ICON_CACHE_DIR")
  [[ -z "$ICON_URL" ]] || args+=(--url "$ICON_URL")
  bash "$SCRIPT_DIR/download-icon.sh" "${args[@]}" "$1" "$2" || { [[ "$ICON_MODE" == required ]] && return 1; log_warn "未找到图标，请发布前补充真实 logo.png"; }
}

main() {
  parse_args "$@"
  if [[ "$CHECK_DEPS_ONLY" == true ]]; then check_dependencies; exit $?; fi
  check_dependencies
  local input="${POSITIONAL[0]:-}" input_type
  [[ -n "$input" ]] || { print_help; exit 0; }
  input_type=$(detect_input_type "$input")
  log_info "输入类型: $input_type"
  case "$input_type" in
    github)
      extract_from_github "$input"
      if [[ -n "$COMPOSE_CONTENT" ]]; then extract_from_compose "$COMPOSE_CONTENT"; else extract_from_docker_run "$DOCKER_RUN_CONTENT"; fi ;;
    compose_url)
      COMPOSE_CONTENT=$(curl -fsSL --connect-timeout 5 --max-time 20 "$input")
      extract_from_compose "$COMPOSE_CONTENT"; APP_NAME="$SERVICE_NAME"; APP_KEY=$(normalize_app_key "$SERVICE_NAME") ;;
    compose_file)
      COMPOSE_CONTENT=$(cat "$input")
      extract_from_compose "$COMPOSE_CONTENT"; APP_NAME="$SERVICE_NAME"; APP_KEY=$(normalize_app_key "$SERVICE_NAME") ;;
    docker_run) extract_from_docker_run "$input" ;;
    *) log_error "无法识别输入: $input"; exit 1 ;;
  esac
  [[ -z "$USER_APP_NAME" ]] || APP_NAME="$USER_APP_NAME"
  [[ -z "$USER_APP_KEY" ]] || APP_KEY=$(normalize_app_key "$USER_APP_KEY")
  [[ -n "${APP_KEY:-}" ]] || APP_KEY=$(normalize_app_key "${APP_NAME:-app}")

  HOST_PORTS=(); CONTAINER_PORTS=(); PORT_ENV_KEYS=(); PORT_ENV_KEYS_USED=(); USED_HOST_PORTS=()
  local i mapping host_port container_port safe envkey
  for ((i=0;i<${#PORT_ENTRIES[@]};i++)); do mapping=$(parse_port_entry "${PORT_ENTRIES[$i]}"); USED_HOST_PORTS+=("${mapping%%:*}"); done
  for ((i=0;i<${#PORT_ENTRIES[@]};i++)); do
    mapping=$(parse_port_entry "${PORT_ENTRIES[$i]}"); host_port="${mapping%%:*}"; container_port="${mapping##*:}"
    [[ "$host_port" =~ ^[0-9]+$ && "$container_port" =~ ^[0-9]+$ ]] || { log_error "无法解析端口映射: ${PORT_ENTRIES[$i]}"; exit 1; }
    safe=$(safe_default_host_port "$host_port" "$i"); [[ "$safe" == "$host_port" ]] || log_warn "默认宿主机端口 $host_port 改为 $safe，避免 1Panel 常见反向代理端口冲突"
    HOST_PORTS+=("$safe"); USED_HOST_PORTS+=("$safe"); CONTAINER_PORTS+=("$container_port")
    envkey=$(map_port_envkey "$container_port" "$i")
    if [[ " ${PORT_ENV_KEYS_USED[*]:-} " == *" $envkey "* ]]; then envkey="${envkey}_${i}"; fi
    PORT_ENV_KEYS+=("$envkey"); PORT_ENV_KEYS_USED+=("$envkey")
  done

  if [[ -n "$USER_VERSION" ]]; then
    VERSION_TAG="$USER_VERSION"
  elif ! is_floating_tag "$TAG"; then
    VERSION_TAG="$TAG"
  elif [[ "$RESOLVE_VERSION" == true ]]; then
    VERSION_TAG=$(get_latest_tag)
    [[ -n "$VERSION_TAG" ]] || { log_error "无法从 registry 解析具体版本；请显式 --version"; exit 1; }
  else
    log_error "来源镜像使用浮动 tag '$TAG'。为生成可复现包，请显式 --version；或使用 --resolve-version 后再人工核对。"
    exit 1
  fi
  VERSION_DIR="${VERSION_TAG#v}"
  [[ -n "$VERSION_DIR" ]] || { log_error "版本目录为空"; exit 1; }

  if [[ "$DRY_RUN" == true ]]; then
    echo "app_key=$APP_KEY"; echo "app_name=${APP_NAME:-}"; echo "service=${SERVICE_NAME:-}"; echo "image=${IMAGE_BASE}:${VERSION_TAG}"; echo "version_dir=$VERSION_DIR"; echo "output=${OUTPUT_BASE}/${APP_KEY}"; exit 0
  fi

  local app_dir version_dir
  app_dir="${OUTPUT_BASE}/${APP_KEY}"
  version_dir="$app_dir/$VERSION_DIR"
  if [[ -e "$app_dir" ]]; then
    [[ "$FORCE" == true ]] || { log_error "输出目录已存在: $app_dir（使用 --force 覆盖）"; exit 1; }
    rm -rf "$app_dir"
  fi
  mkdir -p "$version_dir"
  generate_version_data_yml "$version_dir/data.yml"
  generate_docker_compose "$version_dir/docker-compose.yml" "$VERSION_TAG"
  generate_readme "$app_dir"
  download_icon "${APP_NAME:-$APP_KEY}" "$app_dir/logo.png"
  generate_top_data_yml "$app_dir/data.yml"

  echo
  log_info "✓ 已生成固定版本草稿: $version_dir"
  find "$app_dir" -maxdepth 2 -type f | sort
  echo
  log_warn "生成器只负责安全草稿；正式发布前必须运行 validate-app.sh 并人工检查上游生产拓扑、初始化、迁移和反向代理。"
}

main "$@"

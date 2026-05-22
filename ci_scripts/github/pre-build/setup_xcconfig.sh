#!/usr/bin/env bash

set -euo pipefail

usage() {
  cat <<'USAGE'
Usage:
  setup_xcconfig.sh [--dry-run]

Options:
  --dry-run      Print planned files without changing them.
  --help         Show this help.
USAGE
}

die() {
  echo "setup_xcconfig.sh: $*" >&2
  exit 1
}

notify_failure() {
  local message="$1"

  echo "XCConfig setup failed"
  echo "Reason: $message" >&2

  ci_scripts/github/webhook/send_discord.sh \
    --status failure \
    --message "XCConfig 설정에 실패했어요: ${message}" \
    --step setup-xcconfig || true
}

fail() {
  local message="$1"

  trap - ERR
  notify_failure "$message"
  exit 1
}

handle_unexpected_failure() {
  local line="$1"
  local command="$2"

  trap - ERR
  notify_failure "line ${line}: ${command}"
  exit 1
}

escape_xcconfig_value() {
  local value="$1"

  printf '%s' "$value" | sed 's#//#/$()/#g'
}

create_xcconfigs() {
  local raw_api_base_url_dev
  local raw_api_base_url_prod
  local api_base_url_dev
  local api_base_url_prod

  raw_api_base_url_dev="${API_BASE_URL_DEV:-}"
  raw_api_base_url_prod="${API_BASE_URL_PROD:-}"

  [[ -n "$raw_api_base_url_dev" ]] || fail "required XCConfig secret/env is missing: API_BASE_URL_DEV"
  [[ -n "$raw_api_base_url_prod" ]] || fail "required XCConfig secret/env is missing: API_BASE_URL_PROD"

  api_base_url_dev="$(escape_xcconfig_value "$raw_api_base_url_dev")"
  api_base_url_prod="$(escape_xcconfig_value "$raw_api_base_url_prod")"

  mkdir -p XCConfig

  cat > XCConfig/Shared.xcconfig <<'EOF'
ENABLE_USER_SCRIPT_SANDBOXING = NO
OTHER_LDFLAGS = -ObjC
EOF

  cat > XCConfig/Dev.xcconfig <<EOF
#include "./Shared.xcconfig"

BUNDLE_IDENTIFIER = com.jumy.microfeature-dev
BUNDLE_NAME = MicroFeature DEV
ENV = Dev
SWIFT_ACTIVE_COMPILATION_CONDITIONS = DEV
BASE_URL = ${api_base_url_dev}
EOF

  cat > XCConfig/Prod.xcconfig <<EOF
#include "./Shared.xcconfig"

BUNDLE_IDENTIFIER = com.jumy.microfeature
BUNDLE_NAME = MicroFeature
ENV = Prod
SWIFT_ACTIVE_COMPILATION_CONDITIONS = PROD
BASE_URL = ${api_base_url_prod}
EOF

  cp XCConfig/Prod.xcconfig XCConfig/Release.xcconfig

  [[ -f XCConfig/Shared.xcconfig ]] || fail "failed to create XCConfig/Shared.xcconfig"
  [[ -f XCConfig/Dev.xcconfig ]] || fail "failed to create XCConfig/Dev.xcconfig"
  [[ -f XCConfig/Prod.xcconfig ]] || fail "failed to create XCConfig/Prod.xcconfig"
  [[ -f XCConfig/Release.xcconfig ]] || fail "failed to create XCConfig/Release.xcconfig"
}

dry_run=false

while [[ $# -gt 0 ]]; do
  case "$1" in
    --dry-run)
      dry_run=true
      shift
      ;;
    --help|-h)
      usage
      exit 0
      ;;
    *)
      fail "unknown argument: $1"
      ;;
  esac
done

if [[ "$dry_run" == true ]]; then
  echo "XCConfig setup dry-run"
  echo "files=XCConfig/Shared.xcconfig XCConfig/Dev.xcconfig XCConfig/Prod.xcconfig XCConfig/Release.xcconfig"
  echo "required_env=API_BASE_URL_DEV API_BASE_URL_PROD"
  exit 0
fi

echo "Setup XCConfig started"
trap 'handle_unexpected_failure "$LINENO" "$BASH_COMMAND"' ERR
create_xcconfigs

echo "XCConfig setup succeeded"

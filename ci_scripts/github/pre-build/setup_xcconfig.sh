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

required_env() {
  local name="$1"
  local value="${!name:-}"

  [[ -n "$value" ]] || die "required XCConfig secret/env is missing: $name"
  printf '%s' "$value"
}

escape_xcconfig_value() {
  local value="$1"

  printf '%s' "$value" | sed 's#//#/$()/#g'
}

create_xcconfigs() {
  local api_base_url_dev
  local api_base_url_prod

  api_base_url_dev="$(escape_xcconfig_value "$(required_env "API_BASE_URL_DEV")")"
  api_base_url_prod="$(escape_xcconfig_value "$(required_env "API_BASE_URL_PROD")")"

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

  [[ -f XCConfig/Shared.xcconfig ]] || die "failed to create XCConfig/Shared.xcconfig"
  [[ -f XCConfig/Dev.xcconfig ]] || die "failed to create XCConfig/Dev.xcconfig"
  [[ -f XCConfig/Prod.xcconfig ]] || die "failed to create XCConfig/Prod.xcconfig"
  [[ -f XCConfig/Release.xcconfig ]] || die "failed to create XCConfig/Release.xcconfig"
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
      die "unknown argument: $1"
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
create_xcconfigs

echo "XCConfig setup succeeded"

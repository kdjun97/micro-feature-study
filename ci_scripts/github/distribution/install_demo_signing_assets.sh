#!/usr/bin/env bash

set -euo pipefail

usage() {
  cat <<'USAGE'
Usage:
  install_demo_signing_assets.sh [--dry-run]

Options:
  --dry-run      Print planned signing asset installation without changing keychains.
  --help         Show this help.
USAGE
}

notify_failure() {
  local message="$1"

  echo "Demo signing asset install failed"
  echo "Reason: $message" >&2

  ci_scripts/github/webhook/send_discord.sh \
    --status failure \
    --message "Demo 서명 자산 설치에 실패했어요: ${message}" \
    --step install-demo-signing-assets || true
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

require_env() {
  local name="$1"
  local value="${!name:-}"

  [[ -n "$value" ]] || fail "required demo signing secret/env is missing: $name"
}

decode_base64() {
  local value="$1"
  local output_path="$2"

  printf '%s' "$value" | base64 -D > "$output_path"
  [[ -s "$output_path" ]] || fail "failed to decode signing asset: $output_path"
}

deployment_kind="${CICD_DEPLOYMENT_KIND:-}"
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

case "$deployment_kind" in
  DEMO|DESIGN)
    ;;
  *)
    echo "Demo signing asset install skipped"
    echo "Reason: deployment_kind=${deployment_kind:-unknown} does not use demo Ad Hoc signing assets"
    exit 0
    ;;
esac

echo "Demo signing asset install started"
trap 'handle_unexpected_failure "$LINENO" "$BASH_COMMAND"' ERR

if [[ "$dry_run" == true ]]; then
  echo "Demo signing asset install dry-run"
  echo "deployment_kind=$deployment_kind"
  echo "certificate_secret=DEMO_IOS_DISTRIBUTION_CERTIFICATE_BASE64"
  echo "profile_secret=DEMO_IOS_ADHOC_PROFILE_BASE64"
  echo "keychain_secret=DEMO_SIGNING_KEYCHAIN_PASSWORD"
  exit 0
fi

require_env "DEMO_IOS_DISTRIBUTION_CERTIFICATE_BASE64"
require_env "DEMO_IOS_DISTRIBUTION_CERTIFICATE_PASSWORD"
require_env "DEMO_IOS_ADHOC_PROFILE_BASE64"
require_env "DEMO_SIGNING_KEYCHAIN_PASSWORD"

signing_dir="${RUNNER_TEMP:-build/signing}/demo-signing"
certificate_path="$signing_dir/demo_distribution.p12"
profile_path="$signing_dir/demo_adhoc.mobileprovision"
profile_plist_path="$signing_dir/demo_adhoc.plist"
keychain_path="$signing_dir/demo_signing.keychain-db"

mkdir -p "$signing_dir"

decode_base64 "$DEMO_IOS_DISTRIBUTION_CERTIFICATE_BASE64" "$certificate_path"
decode_base64 "$DEMO_IOS_ADHOC_PROFILE_BASE64" "$profile_path"

security cms -D -i "$profile_path" > "$profile_plist_path"
profile_uuid="$(/usr/libexec/PlistBuddy -c 'Print UUID' "$profile_plist_path")"
[[ -n "$profile_uuid" ]] || fail "failed to read provisioning profile UUID"

security create-keychain -p "$DEMO_SIGNING_KEYCHAIN_PASSWORD" "$keychain_path"
security set-keychain-settings -lut 21600 "$keychain_path"
security unlock-keychain -p "$DEMO_SIGNING_KEYCHAIN_PASSWORD" "$keychain_path"

current_keychains="$(security list-keychains -d user | tr -d '"')"
security list-keychains -d user -s "$keychain_path" $current_keychains

security import "$certificate_path" \
  -k "$keychain_path" \
  -P "$DEMO_IOS_DISTRIBUTION_CERTIFICATE_PASSWORD" \
  -T /usr/bin/codesign \
  -T /usr/bin/security

security set-key-partition-list \
  -S apple-tool:,apple:,codesign: \
  -s \
  -k "$DEMO_SIGNING_KEYCHAIN_PASSWORD" \
  "$keychain_path"

mkdir -p "$HOME/Library/MobileDevice/Provisioning Profiles"
cp "$profile_path" "$HOME/Library/MobileDevice/Provisioning Profiles/${profile_uuid}.mobileprovision"

echo "Demo signing asset install succeeded"
echo "Installed provisioning profile UUID: $profile_uuid"

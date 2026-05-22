#!/usr/bin/env bash

set -euo pipefail

usage() {
  cat <<'USAGE'
Usage:
  setup_firebase.sh [--environment <DEV|PROD>] [--dry-run]

Options:
  --environment  Firebase environment. Defaults to CICD_ENVIRONMENT.
  --dry-run      Print planned copy without changing files.
  --help         Show this help.
USAGE
}

die() {
  echo "setup_firebase.sh: $*" >&2
  exit 1
}

required_env() {
  local name="$1"
  local value="${!name:-}"

  [[ -n "$value" ]] || die "required Firebase secret/env is missing: $name"
  printf '%s' "$value"
}

xml_escape() {
  local value="$1"

  value="${value//&/&amp;}"
  value="${value//</&lt;}"
  value="${value//>/&gt;}"
  value="${value//\"/&quot;}"
  value="${value//\'/&apos;}"

  printf '%s' "$value"
}

create_firebase_plist() {
  local environment="$1"
  local output_path="$2"

  local raw_api_key
  local raw_google_app_id
  local raw_gcm_sender_id
  local raw_project_id
  local raw_storage_bucket
  local raw_bundle_id
  local api_key
  local google_app_id
  local gcm_sender_id
  local project_id
  local storage_bucket
  local bundle_id

  raw_api_key="$(required_env "FIREBASE_API_KEY_${environment}")"
  raw_google_app_id="$(required_env "FIREBASE_GOOGLE_APP_ID_${environment}")"
  raw_gcm_sender_id="$(required_env "FIREBASE_GCM_SENDER_ID_${environment}")"
  raw_project_id="$(required_env "FIREBASE_PROJECT_ID_${environment}")"
  raw_storage_bucket="$(required_env "FIREBASE_STORAGE_BUCKET_${environment}")"
  raw_bundle_id="$(required_env "FIREBASE_BUNDLE_ID_${environment}")"

  api_key="$(xml_escape "$raw_api_key")"
  google_app_id="$(xml_escape "$raw_google_app_id")"
  gcm_sender_id="$(xml_escape "$raw_gcm_sender_id")"
  project_id="$(xml_escape "$raw_project_id")"
  storage_bucket="$(xml_escape "$raw_storage_bucket")"
  bundle_id="$(xml_escape "$raw_bundle_id")"

  mkdir -p "$(dirname "$output_path")"

  cat > "$output_path" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>API_KEY</key>
	<string>${api_key}</string>
	<key>GCM_SENDER_ID</key>
	<string>${gcm_sender_id}</string>
	<key>PLIST_VERSION</key>
	<string>1</string>
	<key>BUNDLE_ID</key>
	<string>${bundle_id}</string>
	<key>PROJECT_ID</key>
	<string>${project_id}</string>
	<key>STORAGE_BUCKET</key>
	<string>${storage_bucket}</string>
	<key>IS_ADS_ENABLED</key>
	<false></false>
	<key>IS_ANALYTICS_ENABLED</key>
	<false></false>
	<key>IS_APPINVITE_ENABLED</key>
	<true></true>
	<key>IS_GCM_ENABLED</key>
	<true></true>
	<key>IS_SIGNIN_ENABLED</key>
	<true></true>
	<key>GOOGLE_APP_ID</key>
	<string>${google_app_id}</string>
</dict>
</plist>
EOF

  [[ -f "$output_path" ]] || die "failed to create Firebase plist: $output_path"
}

environment="${ENVIRONMENT:-${CICD_ENVIRONMENT:-}}"
firebase_dir="Projects/App/Resources/Firebase"
dry_run=false

while [[ $# -gt 0 ]]; do
  case "$1" in
    --environment)
      [[ $# -ge 2 ]] || die "--environment requires a value"
      environment="$2"
      shift 2
      ;;
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

case "$environment" in
  DEV|PROD)
    ;;
  *)
    die "environment must be DEV or PROD: ${environment:-empty}"
    ;;
esac

source_plist="${firebase_dir}/GoogleService-Info-${environment}.plist"
destination_plist="${firebase_dir}/GoogleService-Info.plist"

if [[ "$dry_run" == true ]]; then
  echo "Firebase setup dry-run"
  echo "environment=$environment"
  echo "generated_source=$source_plist"
  echo "destination=$destination_plist"
  exit 0
fi

create_firebase_plist "$environment" "$source_plist"
cp "$source_plist" "$destination_plist"
[[ -f "$destination_plist" ]] || die "failed to create destination Firebase plist"

echo "Firebase plist created and selected for $environment"

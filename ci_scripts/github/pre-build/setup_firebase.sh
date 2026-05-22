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

[[ -f "$source_plist" ]] || die "source Firebase plist does not exist: $source_plist"

if [[ "$dry_run" == true ]]; then
  echo "Firebase setup dry-run"
  echo "environment=$environment"
  echo "source=$source_plist"
  echo "destination=$destination_plist"
  exit 0
fi

mkdir -p "$firebase_dir"
cp "$source_plist" "$destination_plist"
[[ -f "$destination_plist" ]] || die "failed to create destination Firebase plist"

echo "Firebase plist selected for $environment"

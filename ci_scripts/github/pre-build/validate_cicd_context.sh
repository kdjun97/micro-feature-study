#!/usr/bin/env bash

set -euo pipefail

die() {
  echo "validate_cicd_context.sh: $*" >&2
  exit 1
}

branch="${BRANCH:-${GITHUB_REF_NAME:-}}"

case "$branch" in
  dev/*)
    [[ "$branch" =~ ^dev/[0-9]+(\.[0-9]+){2}-[0-9]{10}$ ]] || die "invalid dev tag format: $branch"
    ;;
  prod/*)
    [[ "$branch" =~ ^prod/[0-9]+(\.[0-9]+){2}-[0-9]{10}$ ]] || die "invalid prod tag format: $branch"
    ;;
  demo/*/*)
    [[ "$branch" =~ ^demo/[^/]+/[0-9]+(\.[0-9]+){2}-[0-9]{10}$ ]] || die "invalid demo tag format: $branch"
    ;;
  *)
    die "unsupported tag prefix: $branch"
    ;;
esac

echo "CI/CD deployment tag is valid"

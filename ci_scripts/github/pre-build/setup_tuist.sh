#!/usr/bin/env bash

set -euo pipefail

usage() {
  cat <<'USAGE'
Usage:
  setup_tuist.sh [--dry-run]

Options:
  --dry-run      Print planned commands without running them.
  --help         Show this help.
USAGE
}

die() {
  echo "setup_tuist.sh: $*" >&2
  exit 1
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
  echo "Tuist setup dry-run"
  echo "commands=curl mise install, mise install tuist, tuist version, make clean, make generate"
  exit 0
fi

echo "Setup Tuist started"

if [[ -n "${GITHUB_TOKEN:-}" ]]; then
  echo "GitHub token detected for mise downloads"
else
  echo "GitHub token is not set; mise may hit GitHub API rate limits"
fi

if ! command -v mise >/dev/null 2>&1; then
  echo "mise install started"
  curl https://mise.jdx.dev/install.sh | sh
  export PATH="$HOME/.local/bin:$PATH"
  echo "mise install succeeded"
else
  echo "mise already installed"
fi

export PATH="$HOME/.local/bin:$PATH"

echo "Tuist install started"
mise install tuist
echo "Tuist install succeeded"

echo "mise activate started"
eval "$(mise activate bash --shims)" || echo "mise activate warning: continuing without shell activation"

echo "mise doctor started"
mise doctor || echo "mise doctor warning: continuing despite warnings"

echo "Tuist version check started"
mise exec -- tuist version
echo "Tuist version check succeeded"

echo "Tuist clean started"
mise exec -- make clean
echo "Tuist clean succeeded"

echo "Tuist generate started"
mise exec -- make generate

echo "Tuist setup succeeded"

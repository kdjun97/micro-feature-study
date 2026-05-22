#!/usr/bin/env bash

set -euo pipefail

usage() {
  cat <<'USAGE'
Usage:
  send_discord.sh --status <status> --message <message> --step <step> [options]

Required:
  --status       CI/CD step status. Example: started, success, failure
  --message      Human-readable message. Example: Pre-Build completed
  --step         CI/CD step name. Example: pre-build, tests, distribution

Options:
  --workflow     Workflow name. Defaults to GITHUB_WORKFLOW or local
  --job          Job name. Defaults to GITHUB_JOB or local
  --branch       Branch or tag. Defaults to GITHUB_REF_NAME or current git branch
  --scheme       Xcode scheme. Defaults to tag-based inference
  --environment  Environment. Defaults to tag-based inference
  --dry-run      Print payload without sending to Discord
  --help         Show this help

Environment:
  DISCORD_WEBHOOK_URL is required unless --dry-run is used.
USAGE
}

die() {
  echo "send_discord.sh: $*" >&2
  exit 1
}

status="${STATUS:-}"
message="${MESSAGE:-}"
step="${STEP:-}"
workflow="${WORKFLOW:-${GITHUB_WORKFLOW:-}}"
job="${JOB:-${GITHUB_JOB:-}}"
branch="${BRANCH:-${GITHUB_REF_NAME:-}}"
scheme="${SCHEME:-}"
environment="${ENVIRONMENT:-}"
dry_run=false

while [[ $# -gt 0 ]]; do
  case "$1" in
    --status)
      [[ $# -ge 2 ]] || die "--status requires a value"
      status="$2"
      shift 2
      ;;
    --message)
      [[ $# -ge 2 ]] || die "--message requires a value"
      message="$2"
      shift 2
      ;;
    --step)
      [[ $# -ge 2 ]] || die "--step requires a value"
      step="$2"
      shift 2
      ;;
    --workflow)
      [[ $# -ge 2 ]] || die "--workflow requires a value"
      workflow="$2"
      shift 2
      ;;
    --job)
      [[ $# -ge 2 ]] || die "--job requires a value"
      job="$2"
      shift 2
      ;;
    --branch)
      [[ $# -ge 2 ]] || die "--branch requires a value"
      branch="$2"
      shift 2
      ;;
    --scheme)
      [[ $# -ge 2 ]] || die "--scheme requires a value"
      scheme="$2"
      shift 2
      ;;
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

[[ -n "$status" ]] || die "--status is required"
[[ -n "$message" ]] || die "--message is required"
[[ -n "$step" ]] || die "--step is required"

if [[ -z "$branch" ]] && command -v git >/dev/null 2>&1; then
  branch="$(git rev-parse --abbrev-ref HEAD 2>/dev/null || true)"
fi

workflow="${workflow:-local}"
job="${job:-local}"
branch="${branch:-unknown}"

infer_from_ref() {
  local ref="$1"

  case "$ref" in
    dev/*)
      [[ -n "$scheme" ]] || scheme="MicroFeatureStudy-DEV"
      [[ -n "$environment" ]] || environment="DEV"
      ;;
    prod/*)
      [[ -n "$scheme" ]] || scheme="MicroFeatureStudy-PROD"
      [[ -n "$environment" ]] || environment="PROD"
      ;;
    demo/*/*)
      local demo_target="${ref#demo/}"
      demo_target="${demo_target%%/*}"
      [[ -n "$scheme" ]] || scheme="$demo_target"
      [[ -n "$environment" ]] || environment="DEV"
      ;;
  esac
}

infer_from_ref "$branch"

scheme="${scheme:-unknown}"
environment="${environment:-unknown}"
datetime="$(TZ=Asia/Seoul date '+%Y-%m-%d %H:%M KST')"

make_payload() {
  if command -v python3 >/dev/null 2>&1; then
    STATUS="$status" \
    MESSAGE="$message" \
    STEP="$step" \
    WORKFLOW="$workflow" \
    JOB="$job" \
    BRANCH="$branch" \
    SCHEME="$scheme" \
    ENVIRONMENT="$environment" \
    DATETIME="$datetime" \
      python3 - <<'PY'
import json
import os

fields = [
    ("status", os.environ["STATUS"]),
    ("message", os.environ["MESSAGE"]),
    ("step", os.environ["STEP"]),
    ("workflow", os.environ["WORKFLOW"]),
    ("job", os.environ["JOB"]),
    ("scheme", os.environ["SCHEME"]),
    ("environment", os.environ["ENVIRONMENT"]),
    ("branch", os.environ["BRANCH"]),
    ("datetime", os.environ["DATETIME"]),
]

payload = {
    "username": "MicroFeatureStudy CI",
    "content": f"[{os.environ['STATUS']}] {os.environ['MESSAGE']}",
    "embeds": [
        {
            "title": "CI/CD Notification",
            "color": 3066993 if os.environ["STATUS"].lower() in ("success", "succeeded", "completed") else 15158332 if os.environ["STATUS"].lower() in ("failure", "failed", "error") else 3447003,
            "fields": [
                {"name": name, "value": value or "unknown", "inline": True}
                for name, value in fields
            ],
        }
    ],
}

print(json.dumps(payload, ensure_ascii=False))
PY
    return
  fi

  die "python3 is required to build the Discord JSON payload"
}

payload="$(make_payload)"

if [[ "$dry_run" == true ]]; then
  printf '%s\n' "$payload"
  exit 0
fi

[[ -n "${DISCORD_WEBHOOK_URL:-}" ]] || die "DISCORD_WEBHOOK_URL is required"

curl \
  --fail \
  --silent \
  --show-error \
  --request POST \
  --header "Content-Type: application/json" \
  --data "$payload" \
  "$DISCORD_WEBHOOK_URL" >/dev/null

echo "Discord notification sent"

#!/usr/bin/env bash

set -euo pipefail

usage() {
  cat <<'USAGE'
Usage:
  send_discord.sh --status <status> --message <message> --step <step> [--dry-run]

Required:
  --status       CI/CD step status. Example: started, success, failure
  --message      Human-readable message. Example: Pre-Build completed
  --step         CI/CD step name. Example: pre-build, tests, distribution

Options:
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
branch="${CICD_BRANCH:-${BRANCH:-${GITHUB_REF_NAME:-}}}"
scheme="${CICD_SCHEME:-${SCHEME:-unknown}}"
environment="${CICD_ENVIRONMENT:-${ENVIRONMENT:-unknown}}"
version_display="${CICD_VERSION_DISPLAY:-}"
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
scheme="${scheme:-unknown}"
environment="${environment:-unknown}"
version_display="${version_display:-unknown}"
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
    VERSION_DISPLAY="$version_display" \
    DATETIME="$datetime" \
      python3 - <<'PY'
import json
import os

status = os.environ["STATUS"].lower()
message = os.environ["MESSAGE"]
step = os.environ["STEP"]

status_labels = {
    "started": "🚀 시작",
    "success": "✅ 성공",
    "succeeded": "✅ 성공",
    "completed": "✅ 성공",
    "failure": "❌ 실패",
    "failed": "❌ 실패",
    "error": "❌ 실패",
    "cancelled": "⏹️ 취소",
    "canceled": "⏹️ 취소",
}

status_titles = {
    "started": "🚀 CI/CD 배포가 시작됐어요",
    "success": "✅ CI/CD 단계가 성공했어요",
    "succeeded": "✅ CI/CD 단계가 성공했어요",
    "completed": "✅ CI/CD 단계가 성공했어요",
    "failure": "❌ CI/CD 단계가 실패했어요",
    "failed": "❌ CI/CD 단계가 실패했어요",
    "error": "❌ CI/CD 단계가 실패했어요",
    "cancelled": "⏹️ CI/CD 실행이 취소됐어요",
    "canceled": "⏹️ CI/CD 실행이 취소됐어요",
}

status_colors = {
    "started": 3447003,
    "success": 3066993,
    "succeeded": 3066993,
    "completed": 3066993,
    "failure": 15158332,
    "failed": 15158332,
    "error": 15158332,
    "cancelled": 9807270,
    "canceled": 9807270,
}

fields = [
    ("📌 상태", status_labels.get(status, os.environ["STATUS"])),
    ("💬 메시지", message),
    ("🧩 단계", os.environ["STEP"]),
    ("🛠️ 워크플로우", os.environ["WORKFLOW"]),
    ("📦 작업", os.environ["JOB"]),
    ("🎯 대상", os.environ["SCHEME"]),
    ("🌱 환경", os.environ["ENVIRONMENT"]),
    ("🏷️ 버전", os.environ["VERSION_DISPLAY"]),
    ("🔖 태그/브랜치", os.environ["BRANCH"]),
    ("🕒 시간", os.environ["DATETIME"]),
]

payload = {
    "username": "MicroFeatureStudy CI",
    "content": message if step == "tag-validation" else status_titles.get(status, message),
    "embeds": [
        {
            "title": message,
            "color": status_colors.get(status, 3447003),
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

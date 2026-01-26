#!/bin/bash
# ============================================================================
# Mock GitHub CLI for local testing with act
# ============================================================================
# This script replaces the 'gh' CLI when running workflows locally with act.
# It allows TF-via-PR and other actions to run while gracefully handling
# GitHub API calls that would otherwise fail.
#
# Features:
# - Captures PR comments to .act/pr-comments/<timestamp>.md
# - Captures check-run summaries (used by TF-via-PR for output)
# - Handles gh api, gh pr comment, and gh issue comment
# - Returns mock JSON for API calls
# - Logs all gh commands for debugging
# ============================================================================

set -euo pipefail

COMMENT_FILE="${ACT_COMMENT_FILE:-.act/pr-comments/unknown.md}"
LOG_FILE="${COMMENT_FILE%.md}.log"

# Log all calls for debugging
echo "[$(date '+%H:%M:%S')] gh $*" >> "$LOG_FILE"
echo "[act mock] gh $*" >&2

# Read stdin if available (some commands pass body via stdin)
stdin_data=""
if [[ ! -t 0 ]]; then
  stdin_data=$(cat)
  if [[ -n "$stdin_data" ]]; then
    echo "[$(date '+%H:%M:%S')] STDIN: $stdin_data" >> "$LOG_FILE"
  fi
fi

# Function to save comment to file
save_comment() {
  local body="$1"
  local title="${2:-Comment}"
  if [[ -n "$body" ]]; then
    echo "---" >> "$COMMENT_FILE"
    echo "### $title" >> "$COMMENT_FILE"
    echo "" >> "$COMMENT_FILE"
    echo "$body" >> "$COMMENT_FILE"
    echo "" >> "$COMMENT_FILE"
    echo "[act mock] 📝 Saved to $COMMENT_FILE" >&2
  fi
}

# Capture PR/issue comments (gh pr comment, gh issue comment)
if [[ "$*" == *"pr comment"* || "$*" == *"issue comment"* ]]; then
  body=""
  args=("$@")
  for ((i=0; i<${#args[@]}; i++)); do
    case "${args[i]}" in
      --body|-b)
        body="${args[i+1]:-}"
        break
        ;;
      --body=*)
        body="${args[i]#--body=}"
        break
        ;;
    esac
  done

  # Use stdin if no --body provided
  [[ -z "$body" && -n "$stdin_data" ]] && body="$stdin_data"
  save_comment "$body" "PR Comment"
fi

# Handle gh api calls
if [[ "$*" == *"api"* ]]; then
  echo "[$(date '+%H:%M:%S')] API call detected" >> "$LOG_FILE"

  # Capture all --field/-f arguments for logging
  args=("$@")
  for ((i=0; i<${#args[@]}; i++)); do
    arg="${args[i]}"
    # Log field arguments
    if [[ "$arg" == "-f" || "$arg" == "--field" ]]; then
      field_value="${args[i+1]:-}"
      echo "[$(date '+%H:%M:%S')] FIELD: $field_value" >> "$LOG_FILE"

      # Capture body fields for comments
      if [[ "$field_value" == body=* ]]; then
        body="${field_value#body=}"
        save_comment "$body" "API Comment"
      fi
    fi
  done

  # Check for comment creation/update (POST/PATCH to comments endpoint)
  if [[ "$*" == *"comments"* && ("$*" == *"POST"* || "$*" == *"PATCH"*) ]]; then
    # Use stdin if available
    if [[ -n "$stdin_data" ]]; then
      body=$(echo "$stdin_data" | jq -r '.body // empty' 2>/dev/null || echo "$stdin_data")
      save_comment "$body" "API Comment (stdin)"
    fi
    echo '{"id": 1, "body": "mock comment"}'
    exit 0
  fi

  # Return mock job data for jobs endpoint
  if [[ "$*" == *"/jobs"* ]]; then
    echo '{"jobs": [{"id": 1, "name": "Validate & Plan", "status": "in_progress", "html_url": "https://github.com/mock/run/1"}]}'
    exit 0
  fi

  # Return mock data for pulls endpoint
  if [[ "$*" == *"/pulls/"* ]]; then
    echo '{"number": 999, "head": {"sha": "abc123"}, "base": {"ref": "main"}}'
    exit 0
  fi

  # Return mock for check-runs
  if [[ "$*" == *"check-runs"* ]]; then
    echo '{"id": 1, "status": "completed"}'
    exit 0
  fi

  # Return empty array for other API calls
  echo "[]"
  exit 0
fi

# Return appropriate responses for other commands
case "$*" in
  *"auth status"*)
    echo "Logged in to github.com as act-mock"
    ;;
  *"repo view"*)
    echo '{"name": "mock-repo"}'
    ;;
  *)
    # Default: return empty/success
    ;;
esac

exit 0

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
# - Handles gh api, gh pr comment, and gh issue comment
# - Returns empty JSON for API calls
# - Logs all gh commands for debugging
# ============================================================================

set -euo pipefail

COMMENT_FILE="${ACT_COMMENT_FILE:-.act/pr-comments/unknown.md}"

echo "[act mock] gh $*" >&2

# Read stdin if available (some commands pass body via stdin)
stdin_data=""
if [[ ! -t 0 ]]; then
  stdin_data=$(cat)
fi

# Function to save comment to file
save_comment() {
  local body="$1"
  if [[ -n "$body" ]]; then
    echo "---" >> "$COMMENT_FILE"
    echo "" >> "$COMMENT_FILE"
    echo "$body" >> "$COMMENT_FILE"
    echo "" >> "$COMMENT_FILE"
    echo "[act mock] 📝 Comment saved to $COMMENT_FILE" >&2
  fi
}

# Capture PR/issue comments (gh pr comment, gh issue comment)
if [[ "$*" == *"pr comment"* || "$*" == *"issue comment"* ]]; then
  body=""
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --body|-b)
        body="$2"
        shift 2
        ;;
      --body=*)
        body="${1#--body=}"
        shift
        ;;
      *)
        shift
        ;;
    esac
  done

  # Use stdin if no --body provided
  [[ -z "$body" && -n "$stdin_data" ]] && body="$stdin_data"
  save_comment "$body"
fi

# Capture gh api calls that create/update comments
if [[ "$*" == *"api"* ]]; then
  # Check for comment-related API endpoints
  if [[ "$*" == *"comments"* || "$*" == *"issues"* || "$*" == *"pulls"* ]]; then
    # Try to extract body from -f body= or --field body=
    body=""
    args_str="$*"
    if [[ "$args_str" =~ body=([^[:space:]]+) ]]; then
      body="${BASH_REMATCH[1]}"
    fi

    # Use stdin if available (gh api often receives JSON via stdin)
    if [[ -z "$body" && -n "$stdin_data" ]]; then
      # Try to extract body from JSON
      body=$(echo "$stdin_data" | jq -r '.body // empty' 2>/dev/null || echo "$stdin_data")
    fi

    save_comment "$body"
  fi

  # Return empty JSON array for API calls
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

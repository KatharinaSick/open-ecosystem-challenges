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
# - Returns empty JSON for API calls
# - Logs all gh commands for debugging
# ============================================================================

set -euo pipefail

COMMENT_FILE="${ACT_COMMENT_FILE:-.act/pr-comments/unknown.md}"

echo "[act mock] gh $*" >&2

# Capture PR comments to a markdown file
if [[ "$*" == *"pr comment"* || "$*" == *"issue comment"* ]]; then
  # Extract the comment body (usually passed via --body or -b)
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

  if [[ -n "$body" ]]; then
    echo "---" >> "$COMMENT_FILE"
    echo "" >> "$COMMENT_FILE"
    echo "$body" >> "$COMMENT_FILE"
    echo "" >> "$COMMENT_FILE"
    echo "[act mock] 📝 Comment saved to $COMMENT_FILE" >&2
  fi
fi

# Return empty JSON for API calls that expect output
if [[ "$*" == *"api"* ]]; then
  echo "[]"
fi

exit 0

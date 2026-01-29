#!/usr/bin/env bash

# github.sh - Helper functions for GitHub Actions and PR verification
# These functions verify workflow runs and pull requests via the GitHub CLI

# -----------------------------------------------------------------------------
# Check if a workflow has succeeded at least once
# Usage: check_workflow_succeeded "workflow-file.yaml" "Display Name" "Hint message"
# -----------------------------------------------------------------------------
check_workflow_succeeded() {
  local workflow_file=$1
  local display_name=$2
  local hint=$3

  print_test_section "Checking $display_name workflow..."

  local run_id
  run_id=$(gh run list --workflow="$workflow_file" --status=success --limit=1 --json databaseId --jq '.[0].databaseId' 2>/dev/null || echo "")

  if [ -z "$run_id" ] || [ "$run_id" == "null" ]; then
    print_error_indent "$display_name workflow has not succeeded yet"
    print_hint "$hint"
    TESTS_FAILED=$((TESTS_FAILED + 1))
    FAILED_CHECKS+=("check_workflow_succeeded:$workflow_file")
    return 1
  else
    print_success_indent "$display_name workflow has succeeded"
    TESTS_PASSED=$((TESTS_PASSED + 1))
    return 0
  fi
}

# -----------------------------------------------------------------------------
# Check if a PR exists with a specific label
# Usage: check_pr_exists_with_label "label" "Display Name" "Hint message"
# Sets: PR_NUMBER and PR_TITLE variables if found
# -----------------------------------------------------------------------------
check_pr_exists_with_label() {
  local label=$1
  local display_name=$2
  local hint=$3

  print_test_section "Checking if $display_name PR exists..."

  local pr_json
  pr_json=$(gh pr list --label="$label" --json number,title --jq '.[0]' 2>/dev/null || echo "")

  if [ -z "$pr_json" ] || [ "$pr_json" == "null" ]; then
    print_error_indent "No PR with '$label' label found"
    print_hint "$hint"
    TESTS_FAILED=$((TESTS_FAILED + 1))
    FAILED_CHECKS+=("check_pr_exists_with_label:$label")
    PR_NUMBER=""
    PR_TITLE=""
    return 1
  else
    PR_NUMBER=$(echo "$pr_json" | jq -r '.number')
    PR_TITLE=$(echo "$pr_json" | jq -r '.title')
    print_success_indent "$display_name PR found: #$PR_NUMBER - $PR_TITLE"
    TESTS_PASSED=$((TESTS_PASSED + 1))
    return 0
  fi
}

# -----------------------------------------------------------------------------
# Check if a PR has a comment containing specific text
# Usage: check_pr_has_comment "pr-number" "search-pattern" "Display Name" "Hint message"
# -----------------------------------------------------------------------------
check_pr_has_comment() {
  local pr_number=$1
  local search_pattern=$2
  local display_name=$3
  local hint=$4

  print_test_section "Checking $display_name..."

  if [ -z "$pr_number" ]; then
    print_error_indent "Cannot check PR comments - no PR number provided"
    TESTS_FAILED=$((TESTS_FAILED + 1))
    FAILED_CHECKS+=("check_pr_has_comment:$display_name")
    return 1
  fi

  local comment_count
  comment_count=$(gh pr view "$pr_number" --comments --json comments --jq '.comments[].body' 2>/dev/null | grep -c "$search_pattern" || echo "0")

  if [ "$comment_count" -gt 0 ]; then
    print_success_indent "PR has $display_name"
    TESTS_PASSED=$((TESTS_PASSED + 1))
    return 0
  else
    print_error_indent "PR is missing $display_name"
    print_hint "$hint"
    TESTS_FAILED=$((TESTS_FAILED + 1))
    FAILED_CHECKS+=("check_pr_has_comment:$display_name")
    return 1
  fi
}

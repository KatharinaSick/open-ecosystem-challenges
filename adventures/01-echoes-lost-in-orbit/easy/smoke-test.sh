#!/usr/bin/env bash
set -euo pipefail

# Load shared libraries
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck disable=SC1091
source "$SCRIPT_DIR/../../../lib/loader.sh"

print_header \
  'Challenge 01: Echoes Lost in Orbit' \
  'Level 1: The Echo Distortion' \
  'Smoke Test Verification'

check_prerequisites kubectl curl

print_sub_header "Running smoke tests..."

# Check if both environments are reachable
check_app_reachable "echo-server-staging" "echo-staging" 8081 80 "Staging" \
  "Hostname: echo-server-staging" \
  "Check if the ArgoCD ApplicationSet is configured correctly"

check_app_reachable "echo-server-prod" "echo-prod" 8082 80 "Production" \
  "Hostname: echo-server-prod" \
  "Check if the ArgoCD ApplicationSet is configured correctly"

# Display summary and exit
print_summary \
  "It looks like you've successfully completed Level 1! 🌟" \
  "Next steps:" \
  "1. Commit your changes: git add . && git commit -m 'Solved Level 1'" \
  "2. Push to main: git push origin main" \
  "3. Manually trigger the 'Verify Adventure' workflow on GitHub Actions" \
  "4. Once verified, share your success with the community! 🎉" \
  "" \
  "📖 For detailed verification instructions, see:" \
  "   https://dynatrace-oss.github.io/open-ecosystem-challenges/verification/"

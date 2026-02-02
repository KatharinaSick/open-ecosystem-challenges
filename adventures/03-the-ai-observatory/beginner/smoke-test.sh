#!/usr/bin/env bash
set -euo pipefail

# Load shared libraries
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck disable=SC1091
source "$SCRIPT_DIR/../../../lib/scripts/loader.sh"

OBJECTIVE="By the end of this level, you should:

TODO"

DOCS_URL="https://dynatrace-oss.github.io/open-ecosystem-challenges/03-the-ai-observatory/beginner"

print_header \
  'Challenge 03: The AI Observatory' \
  'Level 1: TODO' \
  'Smoke Test Verification'



print_test_summary "the ai observatory" "$DOCS_URL" "$OBJECTIVE"

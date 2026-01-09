#!/usr/bin/env bash
set -euo pipefail

# Load shared libraries
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck disable=SC1091
source "$SCRIPT_DIR/../../../lib/scripts/loader.sh"

OBJECTIVE="By the end of this level, you should:

TODO"

DOCS_URL="https://dynatrace-oss.github.io/open-ecosystem-challenges/02-building-cloudhaven/beginner"

print_header \
  'Challenge 02: Building CloudHaven' \
  'Level 1: The Foundation Stones' \
  'Smoke Test Verification'

# TODO: Implement smoke test verification steps
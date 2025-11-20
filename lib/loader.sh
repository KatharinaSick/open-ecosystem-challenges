#!/usr/bin/env bash

# loader.sh - Main library loader
# This script loads all shared libraries for smoke test scripts
# Usage: source "$(dirname "${BASH_SOURCE[0]}")/../lib/loader.sh"

# Get the directory where this script is located
LIB_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source all library files
# shellcheck disable=SC1091
source "$LIB_DIR/output.sh"
source "$LIB_DIR/prerequisites.sh"
source "$LIB_DIR/k8s_checks.sh"

# Set up cleanup trap for port-forwards
setup_cleanup_trap


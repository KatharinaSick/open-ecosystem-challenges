#!/usr/bin/env bash

# k8s_checks.sh - Shared library for Kubernetes resource checks
# This library provides functions to check k8s resources and application health

# Track test results globally
TESTS_PASSED=0
TESTS_FAILED=0

# Array to track port-forward PIDs for cleanup
declare -a PF_PIDS=()

# Cleanup function to ensure port-forwards are killed
cleanup_port_forwards() {
  local exit_code=$?
  if [[ ${#PF_PIDS[@]} -gt 0 ]]; then
    for pid in "${PF_PIDS[@]}"; do
      kill "$pid" 2>/dev/null || true
    done
  fi
  exit "$exit_code"
}

# Set up cleanup trap (should be called once in main script)
setup_cleanup_trap() {
  trap cleanup_port_forwards EXIT INT TERM
}

# Check if a namespace exists
# Usage: check_namespace "namespace-name" ["hint-message"]
# Returns: 0 if exists, 1 if not
check_namespace() {
  local ns=$1
  local hint_msg=${2:-""}

  if ! kubectl get namespace "$ns" &> /dev/null; then
    print_error_indent "Namespace '$ns' does not exist"
    if [[ -n "$hint_msg" ]]; then
      print_hint "$hint_msg"
    fi
    return 1
  fi
  return 0
}

# Check if a service exists in a namespace
# Usage: check_service "service-name" "namespace" ["hint-message"]
# Returns: 0 if exists, 1 if not
check_service() {
  local svc_name=$1
  local ns=$2
  local hint_msg=${3:-""}

  if ! kubectl get service "$svc_name" -n "$ns" &> /dev/null; then
    print_error_indent "Service '$svc_name' not found in namespace '$ns'"
    if [[ -n "$hint_msg" ]]; then
      print_hint "$hint_msg"
    fi
    return 1
  fi
  return 0
}

# Wait for port-forward to be ready
# Usage: wait_for_port_forward 8081 10
# Args: port, max_wait_seconds
# Returns: 0 if ready, 1 if timeout
wait_for_port_forward() {
  local port=$1
  local max_wait=${2:-10}
  local waited=0

  while ! lsof -i:"$port" &>/dev/null && [[ $waited -lt $max_wait ]]; do
    sleep 0.5
    waited=$((waited + 1))
  done

  if [[ $waited -ge $max_wait ]]; then
    return 1
  fi
  return 0
}

# Setup port forward for a service
# Usage: setup_port_forward "service-name" "namespace" 8081 80
# Args: service_name, namespace, local_port, remote_port
# Returns: PID of port-forward process, or empty string on failure
setup_port_forward() {
  local svc_name=$1
  local ns=$2
  local local_port=$3
  local remote_port=$4
  local pf_pid=""

  print_step "Setting up port-forward on localhost:$local_port..."
  kubectl port-forward "svc/$svc_name" "$local_port:$remote_port" -n "$ns" >/dev/null 2>&1 &
  pf_pid=$!
  PF_PIDS+=("$pf_pid")

  if ! wait_for_port_forward "$local_port"; then
    print_error_indent "Port-forward failed to establish"
    kill "$pf_pid" 2>/dev/null || true
    return 1
  fi

  echo "$pf_pid"
  return 0
}

# Test HTTP endpoint
# Usage: test_http_endpoint "http://localhost:8081/healthz" "expected-string" ["hint-message"]
# Returns: 0 if matches, 1 if not
test_http_endpoint() {
  local url=$1
  local expected=$2
  local hint_msg=${3:-""}
  local response

  print_step "Testing health endpoint..."
  response=$(curl -s --max-time 5 "$url" 2>/dev/null || echo "")

  if [[ -z "$response" ]]; then
    print_error_indent "No response from service (connection failed)"
    return 1
  fi

  if [[ "$response" == *"$expected"* ]]; then
    return 0
  else
    print_error_indent "Service responded but with unexpected content"
    if [[ -n "$hint_msg" ]]; then
      print_hint "$hint_msg"
    fi
    print_info_indent "📝 Actual response: $response"
    return 1
  fi
}

# Main function to check if an application is reachable
# Usage: check_app_reachable "service-name" "namespace" local_port remote_port "Label" "expected-string" ["hint"]
# Args: service_name, namespace, local_port, remote_port, label, expected_response, hint
check_app_reachable() {
  local svc_name=$1
  local ns=$2
  local local_port=$3
  local remote_port=${4:-80}
  local label=$5
  local expected=${6:-"Hostname: $svc_name"}
  local hint=${7:-""}
  local pf_pid=""

  print_test_section "Checking $label Environment"

  # Check namespace exists
  if ! check_namespace "$ns" "$hint"; then
    TESTS_FAILED=$((TESTS_FAILED + 1))
    echo ""
    return 1
  fi
  print_success_indent "Namespace '$ns' exists"

  # Check service exists
  if ! check_service "$svc_name" "$ns" "$hint"; then
    TESTS_FAILED=$((TESTS_FAILED + 1))
    echo ""
    return 1
  fi
  print_success_indent "Service '$svc_name' exists"

  # Setup port forwarding
  if ! pf_pid=$(setup_port_forward "$svc_name" "$ns" "$local_port" "$remote_port"); then
    TESTS_FAILED=$((TESTS_FAILED + 1))
    echo ""
    return 1
  fi

  # Test the endpoint
  if ! test_http_endpoint "http://localhost:$local_port/healthz" "$expected" "$hint"; then
    kill "$pf_pid" 2>/dev/null || true
    TESTS_FAILED=$((TESTS_FAILED + 1))
    echo ""
    return 1
  fi

  gum style --foreground 120 --bold "  ✅ $label environment is healthy!"
  TESTS_PASSED=$((TESTS_PASSED + 1))

  # Cleanup port-forward
  kill "$pf_pid" 2>/dev/null || true
  sleep 0.5
  echo ""
}

# Print summary of test results
# Usage: print_summary [success_message] [next_steps...]
print_summary() {
  local success_msg=${1:-"You've successfully completed this level! 🌟"}
  shift || true
  local next_steps=("$@")

  # Display summary header
  print_header "Test Results Summary"

  echo ""
  if [[ $TESTS_FAILED -eq 0 ]]; then
    gum style --foreground 120 --bold "🎉 SUCCESS! All checks passed ($TESTS_PASSED/$((TESTS_PASSED + TESTS_FAILED)))"
    echo ""
    print_info "$success_msg"
    echo ""

    if [[ ${#next_steps[@]} -gt 0 ]]; then
      gum style --foreground 212 "📋 Next Steps:"
      for step in "${next_steps[@]}"; do
        print_info "  $step"
      done
      echo ""
    fi
    exit 0
  else
    gum style --foreground 196 --bold "❌ FAILED: $TESTS_FAILED check(s) failed, $TESTS_PASSED passed"
    echo ""
    print_info "Please review the errors above and try again."
    print_info "Need help? Check the challenge documentation or review your configuration."
    echo ""

    # Offer to show ArgoCD applications
    if command -v gum &> /dev/null; then
      if gum confirm "Would you like to see the current ArgoCD applications?"; then
        echo ""
        gum style --foreground 212 "ArgoCD Applications:"
        kubectl get applications -n argocd -o wide 2>/dev/null || print_error "Failed to retrieve applications"
        echo ""
      fi
    fi

    exit 1
  fi
}


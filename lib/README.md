# Shared Libraries for Smoke Tests

This directory contains reusable functions for creating smoke test scripts across all challenges. The libraries provide consistent styling, error handling, and Kubernetes checks to make creating new smoke test scripts quick and easy.

---

## 📁 Library Files

- **`loader.sh`** - Main entry point that loads all libraries
- **`output.sh`** - Styled output functions using Gum
- **`prerequisites.sh`** - Tool and cluster prerequisite checking
- **`k8s_checks.sh`** - Kubernetes resource validation and health checks

---

## 🚀 Quick Start

### Basic Template

Copy this template to create a new smoke test:

```bash
#!/usr/bin/env bash
set -euo pipefail

# Load shared libraries
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck disable=SC1091
source "$SCRIPT_DIR/../../../lib/loader.sh"

# Main execution
print_header \
  'Challenge XX: Your Challenge Name' \
  'Level X: Your Level Name' \
  'Smoke Test Verification'

check_prerequisites kubectl curl

print_sub_header "Running smoke tests..."

check_app_reachable "service-name" "namespace" 8080 80 "Environment Label"

print_summary \
  "You've successfully completed Level X! 🌟" \
  "1. Commit your changes: git add . && git commit -m 'Solve Level X'" \
  "2. Push to main: git push origin main" \
  "3. Check the GitHub Actions workflow for full verification"
```

---

## 📖 Core Functions Reference

### Print Header

```bash
print_header "Line 1" "Line 2" "Line 3"
```

Creates a styled box with multiple lines centered. Perfect for showing challenge/level information.

**Example:**
```bash
print_header \
  'Challenge 01: Echoes Lost in Orbit' \
  'Level 1: The Echo Distortion' \
  'Smoke Test Verification'
```

### Check Prerequisites

```bash
check_prerequisites kubectl curl [other_tools...]
```

**What it does:**
- Validates that specified tools are installed
- If `kubectl` is in the list, automatically checks cluster connectivity
- Exits with error message if prerequisites are not met

**Examples:**
```bash
check_prerequisites kubectl curl
check_prerequisites kubectl curl jq helm argocd yq
```

### Check Application Reachability

```bash
check_app_reachable "service" "namespace" local_port remote_port "Label" "expected_string" ["hint"]
```

**Parameters:**
- `service` - Kubernetes service name
- `namespace` - Kubernetes namespace
- `local_port` - Local port for port-forward
- `remote_port` - Remote service port (usually 80)
- `Label` - Display label (e.g., "Production", "Staging")
- `expected_string` - String to match in response, defaults to "Hostname: service"
- `hint` - (optional) Custom hint message if any check fails

**What it does:**
1. ✅ Checks namespace exists
2. ✅ Checks service exists
3. ✅ Sets up port-forward
4. ✅ Tests `/healthz` endpoint
5. ✅ Validates response contains expected string
6. ✅ Updates `TESTS_PASSED`/`TESTS_FAILED` counters
7. ✅ Cleans up port-forward automatically

**Examples:**
```bash
# Basic usage (no hints)
check_app_reachable "echo-server" "production" 8080 80 "Production"

# With custom expected response
check_app_reachable "my-service" "prod" 8080 80 "Production" "healthy: true"

# With custom hint
check_app_reachable "echo-server" "production" 8080 80 "Production" \
  "Hostname: echo-server" \
  "Check if ArgoCD ApplicationSet is configured correctly"

# Different remote port
check_app_reachable "grpc-service" "prod" 8080 9090 "gRPC Service"
```

### Print Summary

```bash
print_summary "success_message" "next_step_1" "next_step_2" ...
```

**What it does:**
1. Shows test results summary with styled header
2. Displays pass/fail counts
3. On success: shows success message and next steps
4. On failure: shows error message and offers to display ArgoCD apps
5. Exits with appropriate code (0=success, 1=failure)

**Example:**
```bash
print_summary \
  "You've successfully completed Level 1! 🌟" \
  "1. Commit your changes: git add . && git commit -m 'Solve Level 1'" \
  "2. Push to main: git push origin main" \
  "3. Check the GitHub Actions workflow for full verification" \
  "4. Once verified, move on to Level 2!"
```

---

## 🎨 Additional Output Functions

All these functions use Gum for consistent, beautiful styling:

```bash
print_sub_header "Text"        # Bold subheader in pink
print_success "Text"            # Green success message
print_error "Text"              # Red error message
print_info "Text"               # Gray info message
print_warning "Text"            # Orange warning message
print_success_indent "Text"     # Indented with ✓
print_error_indent "Text"       # Indented with ❌
print_info_indent "Text"        # Indented info
print_hint "Text"               # Gray with 💡 prefix
print_step "Text"               # Gray with ⏳ prefix
print_test_section "Text"       # Bold with 🔬 prefix
```

---

## 🔧 Advanced Functions

### Low-Level Kubernetes Checks

Use these when you need custom logic beyond `check_app_reachable`:

```bash
# Check if namespace exists (returns 0 if exists, 1 if not)
check_namespace "namespace-name" ["hint-message"]

# Check if service exists (returns 0 if exists, 1 if not)
check_service "service-name" "namespace" ["hint-message"]

# Setup port forwarding (returns PID or empty on failure)
setup_port_forward "service" "namespace" local_port remote_port

# Test HTTP endpoint (returns 0 if matches, 1 if not)
test_http_endpoint "http://localhost:8080/healthz" "expected-string" ["hint-message"]
```

### Global Variables

```bash
TESTS_PASSED    # Counter for passed tests (auto-managed)
TESTS_FAILED    # Counter for failed tests (auto-managed)
PF_PIDS         # Array of port-forward PIDs (auto-cleaned up)
```

---

## 📝 Complete Examples

### Example 1: Single Service Check

```bash
#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../../../lib/loader.sh"

print_header 'Challenge 01' 'Level 1' 'Smoke Test'
check_prerequisites kubectl curl
print_sub_header "Running tests..."

check_app_reachable "my-api" "production" 8080 80 "Production API"

print_summary "Level completed! 🎉" "1. Commit changes" "2. Push to main"
```

### Example 2: Multiple Services

```bash
#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../../../lib/loader.sh"

print_header 'Challenge 02' 'Level 1' 'Multi-Service Test'
check_prerequisites kubectl curl
print_sub_header "Running tests..."

check_app_reachable "frontend" "prod" 8080 80 "Frontend"
check_app_reachable "backend" "prod" 8081 8080 "Backend API"
check_app_reachable "database" "prod" 8082 5432 "Database"

print_summary \
  "All services are healthy! 🎉" \
  "1. Review your changes" \
  "2. Commit and push" \
  "3. Verify on GitHub Actions"
```

### Example 3: Custom Health Checks

```bash
#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../../../lib/loader.sh"

print_header 'Challenge 03' 'Level 1' 'Custom Checks'
check_prerequisites kubectl curl jq
print_sub_header "Running tests..."

# Use low-level functions for custom logic
print_test_section "Checking Custom Service"

if ! check_namespace "my-namespace"; then
  TESTS_FAILED=$((TESTS_FAILED + 1))
  print_hint "Check your namespace configuration"
else
  print_success_indent "Namespace exists"
  
  if ! check_service "my-service" "my-namespace"; then
    TESTS_FAILED=$((TESTS_FAILED + 1))
    print_hint "Check if service is deployed"
  else
    print_success_indent "Service exists"
    TESTS_PASSED=$((TESTS_PASSED + 1))
  fi
fi

echo ""
print_summary "Custom checks complete! 🎉" "1. Next step" "2. Another step"
```

---

## 🎯 Best Practices

### 1. Always Load Libraries First

```bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../../../lib/loader.sh"  # Adjust ../ count as needed
```

### 2. Use Descriptive Labels

```bash
# ❌ Bad - unclear what's being tested
check_app_reachable "svc" "ns" 8080 80 "Env"

# ✅ Good - clear and descriptive
check_app_reachable "payment-service" "production" 8080 80 "Production Payment Service"
```

### 3. Provide Helpful Next Steps

```bash
print_summary \
  "Level completed! 🌟" \
  "1. Review your changes: git diff" \
  "2. Commit: git add . && git commit -m 'Solve Level X'" \
  "3. Push: git push origin main" \
  "4. Verify on GitHub Actions"
```

### 4. Use Unique Ports

```bash
# Avoid port conflicts by using different local ports
check_app_reachable "service1" "ns" 8081 80 "Service 1"
check_app_reachable "service2" "ns" 8082 80 "Service 2"
check_app_reachable "service3" "ns" 8083 80 "Service 3"
```

### 5. Add Comments for Clarity

```bash
# Check staging environment
check_app_reachable "echo-server-staging" "echo-staging" 8081 80 "Staging"

# Check production environment
check_app_reachable "echo-server-prod" "echo-prod" 8082 80 "Production"
```

---

## 🐛 Troubleshooting

### Libraries Not Found

**Problem:** `loader.sh: No such file or directory`

**Solution:** Check the relative path from your script to the lib directory:
```bash
# From challenges/XX/level-1/smoke-test.sh
source "$SCRIPT_DIR/../../../lib/loader.sh"  # Go up 3 levels

# From challenges/XX/smoke-test.sh
source "$SCRIPT_DIR/../../lib/loader.sh"     # Go up 2 levels
```

### Function Not Available

**Problem:** `print_header: command not found`

**Solution:** Verify `loader.sh` is sourcing all libraries:
```bash
cat lib/loader.sh
# Should source: output.sh, prerequisites.sh, k8s_checks.sh
```

### Port-Forward Issues

**Problem:** Port is already in use or port-forward hangs

**Solution:** Libraries handle cleanup automatically, but you can manually clean up:
```bash
# Kill processes on specific ports
lsof -ti:8080,8081,8082 | xargs kill -9 2>/dev/null || true

# Or kill all kubectl port-forwards
pkill -f "kubectl port-forward" || true
```

### Cluster Connection Failed

**Problem:** `Cannot connect to Kubernetes cluster`

**Solution:**
```bash
# Check if cluster is running
kubectl cluster-info

# Check if context is set
kubectl config current-context

# List available contexts
kubectl config get-contexts
```

---

## ✅ Validation Checklist

Before running your smoke test, verify:

1. **Syntax is valid:**
   ```bash
   bash -n your-smoke-test.sh
   ```

2. **Script is executable:**
   ```bash
   chmod +x your-smoke-test.sh
   ```

3. **Libraries can be loaded:**
   ```bash
   bash -c 'source lib/loader.sh && echo "✓ Libraries loaded"'
   ```

4. **Prerequisites are met:**
   ```bash
   command -v kubectl && command -v curl && command -v gum
   ```

---

## 📊 Expected Output

When you run a smoke test, you should see:

```
┌──────────────────────────────────────────────────────┐
│       Challenge 01: Echoes Lost in Orbit             │
│       Level 1: The Echo Distortion                   │
│       Smoke Test Verification                        │
└──────────────────────────────────────────────────────┘

Checking prerequisites...
✓ All prerequisites met

Running smoke tests...

🔬 Checking Staging Environment
  ✓ Namespace 'echo-staging' exists
  ✓ Service 'echo-server-staging' exists
  ⏳ Setting up port-forward on localhost:8081...
  ⏳ Testing health endpoint...
  ✅ Staging environment is healthy!

🔬 Checking Production Environment
  ✓ Namespace 'echo-prod' exists
  ✓ Service 'echo-server-prod' exists
  ⏳ Setting up port-forward on localhost:8082...
  ⏳ Testing health endpoint...
  ✅ Production environment is healthy!

┌──────────────────────────────────────────────────────┐
│              Test Results Summary                     │
└──────────────────────────────────────────────────────┘

🎉 SUCCESS! All checks passed (2/2)

You've successfully completed Level 1! 🌟

📋 Next Steps:
  1. Commit your changes: git add . && git commit -m 'Solve Level 1'
  2. Push to main: git push origin main
  3. Check the GitHub Actions workflow for full verification
  4. Once verified, move on to Level 2!
```

---

## 🔗 Requirements

- **bash** 4.0+
- **gum** - for styled output
- **kubectl** - for Kubernetes checks
- **curl** - for HTTP endpoint testing
- **lsof** - for port-forward validation

---

## 📚 Complete Function Reference

### Output Functions (output.sh)

| Function | Purpose | Example |
|----------|---------|---------|
| `print_header` | Multi-line styled header | `print_header "Line 1" "Line 2"` |
| `print_sub_header` | Bold subheader | `print_sub_header "Running tests..."` |
| `print_success` | Green success message | `print_success "All tests passed!"` |
| `print_error` | Red error message | `print_error "Test failed"` |
| `print_info` | Gray info message | `print_info "Please wait..."` |
| `print_warning` | Orange warning | `print_warning "Deprecated feature"` |
| `print_success_indent` | Indented ✓ message | `print_success_indent "Service exists"` |
| `print_error_indent` | Indented ❌ message | `print_error_indent "Service not found"` |
| `print_info_indent` | Indented info | `print_info_indent "Additional context"` |
| `print_hint` | Hint with 💡 | `print_hint "Check your configuration"` |
| `print_step` | Step with ⏳ | `print_step "Setting up port-forward..."` |
| `print_test_section` | Section with 🔬 | `print_test_section "Checking Production"` |

### Prerequisite Functions (prerequisites.sh)

| Function | Purpose | Example |
|----------|---------|---------|
| `check_prerequisites` | Validate tools and cluster | `check_prerequisites kubectl curl` |

### Kubernetes Functions (k8s_checks.sh)

| Function | Purpose | Example |
|----------|---------|---------|
| `check_namespace` | Verify namespace exists | `check_namespace "production"` |
| `check_service` | Verify service exists | `check_service "my-svc" "prod"` |
| `setup_port_forward` | Create port-forward | `setup_port_forward "svc" "ns" 8080 80` |
| `test_http_endpoint` | Test HTTP endpoint | `test_http_endpoint "http://..." "expected"` |
| `check_app_reachable` | Complete health check | `check_app_reachable "svc" "ns" 8080 80 "Label"` |
| `print_summary` | Display results & exit | `print_summary "Success!" "Step 1" "Step 2"` |

---

**Happy testing! 🚀**

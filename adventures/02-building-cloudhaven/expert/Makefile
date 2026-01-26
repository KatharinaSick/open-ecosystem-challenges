# ============================================================================
# Makefile for CloudHaven Infrastructure - Intermediate Level
# ============================================================================
# This Makefile provides convenient commands for testing, planning, and
# applying the CloudHaven district infrastructure.
# ============================================================================

.PHONY: help test-district test-integration test plan apply clean drift-check-local validate-plan-local

# Default target - show help
help:
	@echo "CloudHaven Infrastructure - Available Commands:"
	@echo ""
	@echo "Testing:"
	@echo "  make test-district     - Run district module tests (plan-only)"
	@echo "  make test-integration  - Run integration tests (apply-based)"
	@echo "  make test              - Run all tests (district + integration)"
	@echo ""
	@echo "Infrastructure:"
	@echo "  make plan              - Run tofu plan to preview changes"
	@echo "  make apply             - Apply infrastructure changes"
	@echo ""
	@echo "GitHub Workflows:"
	@echo "  make drift-check-local    - Test drift detection workflow locally with act"
	@echo "  make validate-plan-local  - Test validate & plan workflow locally with act"
	@echo ""
	@echo "Cleanup:"
	@echo "  make clean             - Remove .terraform directories and lock files"

# ----------------------------------------------------------------------------
# Testing Targets
# ----------------------------------------------------------------------------

# Run district module tests (plan-only tests with mock_provider)
test-district:
	@echo "🧪 Running district module tests..."
	@cd modules/district && tofu test

# Run integration tests (apply-based tests against mock API)
# Starts a separate mock server on port 9000 to avoid conflicts
test-integration:
	@echo "🧪 Starting test mock server on port 9000..."
	@docker run -d -p 9000:8080 --name gcp-api-mock-test ghcr.io/katharinasick/gcp-api-mock:v1.1.4 > /dev/null
	@sleep 1
	@echo "🧪 Running integration tests..."
	@tofu test || (docker stop gcp-api-mock-test > /dev/null 2>&1; docker rm gcp-api-mock-test > /dev/null 2>&1; exit 1)
	@echo "🧪 Stopping test mock server..."
	@docker stop gcp-api-mock-test > /dev/null 2>&1 || true
	@docker rm gcp-api-mock-test > /dev/null 2>&1 || true

# Run all tests
test: test-district test-integration
	@echo "✅ All tests complete!"

# ----------------------------------------------------------------------------
# Infrastructure Targets
# ----------------------------------------------------------------------------

# Preview infrastructure changes
plan:
	@echo "📋 Planning infrastructure changes..."
	@tofu plan

# Apply infrastructure changes
apply:
	@echo "🚀 Applying infrastructure changes..."
	@tofu apply

# ----------------------------------------------------------------------------
# GitHub Workflow Targets
# ----------------------------------------------------------------------------

# Test drift detection workflow locally with nektos/act
drift-check-local:
	@echo "🔍 Running drift detection workflow locally with nektos/act..."
	@gh act workflow_dispatch -e .github/sample-events/trigger-drift-detection.json -P ubuntu-latest=catthehacker/ubuntu:act-latest --bind

# Test validate & plan workflow locally with nektos/act
validate-plan-local:
	@echo "🔎 Running validate & plan workflow locally with nektos/act..."
	@gh act pull_request -e .github/sample-events/pull_request.json -P ubuntu-latest=catthehacker/ubuntu:act-latest --bind

# ----------------------------------------------------------------------------
# Cleanup Targets
# ----------------------------------------------------------------------------

# Clean up .terraform directories and lock files
clean:
	@echo "🧹 Cleaning up..."
	@rm -rf .terraform modules/district/.terraform
	@rm -f .terraform.lock.hcl modules/district/.terraform.lock.hcl
	@podman stop gcp-api-mock-test > /dev/null 2>&1 || true
	@podman rm gcp-api-mock-test > /dev/null 2>&1 || true
	@echo "✨ Clean complete!"


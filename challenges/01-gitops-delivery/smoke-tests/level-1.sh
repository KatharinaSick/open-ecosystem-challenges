#!/usr/bin/env bash
set -e

# Lightweight verification: Check if staging and prod echo servers are reachable

check_app() {
  local svc_name=$1
  local ns=$2
  local port=$3
  local label=$4

  echo ""
  echo "🔬 Checking $label"
  kubectl port-forward svc/$svc_name $port:80 -n $ns >/dev/null 2>&1 &
  pf_pid=$!
  sleep 2
  response=$(curl -s "http://localhost:$port/healthz" || true)
  if [[ "$response" == *"Hostname: $svc_name"* ]]; then
    echo "✅ $label is healthy"
  else
    echo "❌ $label is NOT reachable or did not respond as expected"
  fi
  kill $pf_pid
  sleep 1
}

check_app "echo-server-staging" "echo-staging" 8081 "Staging"
check_app "echo-server-prod" "echo-prod" 8082 "Prod"

echo ""
echo "============="
echo "💡 SUMMARY 💡"
echo "============="
echo "If both, staging and prod, are healthy, you passed the first checkpoint! 🎉"
echo "Proceed with pushing your changes to main and trigger the deep verification workflow."
# 🚧 TODO add more instructions

#!/usr/bin/env bash
set -e

echo "✨ Sleeping 10s to allow previous setups to settle"
sleep 10s

echo "✨ Exposing Argo Rollouts dashboard on port 30101"
nohup kubectl argo rollouts dashboard --address 0.0.0.0 --port 30101 > /tmp/argo-rollouts-dashboard.log 2>&1 &

# Wait a bit to ensure the dashboard starts
sleep 3

echo "✅ Argo Rollouts dashboard started in background (logs: /tmp/argo-rollouts-dashboard.log)"

#!/usr/bin/env bash
set -e

echo "✨ Sleeping 10s to allow previous setups to settle"
sleep 10s

echo "✨ Exposing Argo Rollouts dashboard"
kubectl argo rollouts dashboard --port 30101

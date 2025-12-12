#!/usr/bin/env bash
set -e

# Use a minimal Jaeger setup instead of deploying it via the operator to keep the Codespace lightweight and focused.

echo "✨ Adding Jaeger Helm repo"
helm repo add jaegertracing https://jaegertracing.github.io/helm-charts
helm repo update

echo "✨ Creating jaeger namespace"
kubectl create namespace jaeger

echo "✨ Installing Jaeger via Helm"
helm install jaeger jaegertracing/jaeger \
  --version 4.0.0 \
  --namespace jaeger \
  --set storage.type=memory \
  --set allInOne.enabled=true \
  --set allInOne.resources.requests.memory=128Mi \
  --set allInOne.resources.requests.cpu=50m \
  --set allInOne.resources.limits.memory=128Mi \
  --set allInOne.resources.limits.cpu=50m \
  --set service.type=NodePort \
  --set service.nodePort=30103 \
  --wait \
  --timeout 5m

echo "✅ Jaeger is ready"
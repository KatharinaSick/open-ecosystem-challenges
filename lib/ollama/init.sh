#!/usr/bin/env bash
set -e

# Deploy Ollama to Kubernetes with TinyLlama model pre-loaded

echo "✨ Adding Ollama Helm repo"
helm repo add ollama-helm https://otwld.github.io/ollama-helm/
helm repo update

echo "✨ Creating ollama namespace"
kubectl create namespace ollama

echo "✨ Installing Ollama via Helm"
helm install ollama ollama-helm/ollama \
  --namespace ollama \
  --values lib/ollama/values.yaml \
  --wait \
  --timeout 10m

echo "✨ Waiting for Ollama to be ready"
kubectl wait --for=condition=ready pod -l app.kubernetes.io/name=ollama -n ollama --timeout=300s

echo "✅ Ollama is ready with TinyLlama model"

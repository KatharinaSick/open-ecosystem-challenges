#!/usr/bin/env bash
set -e

echo "✨ Installing Argo Rollouts"
kubectl create namespace argo-rollouts
kubectl apply -k features/argo-rollouts/manifests

echo "✨ Installing Argo Rollouts Kubectl plugin"
curl -LO https://github.com/argoproj/argo-rollouts/releases/v1.8.3/download/kubectl-argo-rollouts-linux-amd64
chmod +x ./kubectl-argo-rollouts-linux-amd64
sudo mv ./kubectl-argo-rollouts-linux-amd64 /usr/local/bin/kubectl-argo-rollouts


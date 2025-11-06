#!/usr/bin/env bash
set -e

echo "Installing Argo CD..."
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/v3.2.0/manifests/install.yaml

echo "Installing Argo CD CLI..."
curl -sSL -o argocd-linux-amd64 https://github.com/argoproj/argo-cd/releases/download/v3.2.0/argocd-linux-amd64
sudo install -m 555 argocd-linux-amd64 /usr/local/bin/argocd
rm argocd-linux-amd64
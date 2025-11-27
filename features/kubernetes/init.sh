#!/usr/bin/env bash
set -e

echo "✨ Installing Kind"
curl -sS https://webi.sh/kind@v0.30.0 | sh

echo "✨ Installing kubectl"
curl -LO "https://dl.k8s.io/release/v1.34.1/bin/linux/amd64/kubectl"
chmod +x kubectl
sudo mv kubectl /usr/local/bin/

echo "✨ Installing kubens"
curl -sS https://webi.sh/kubens@v0.9.5 | bash

echo "✨ Installing k9s"
curl -sS https://webinstall.dev/k9s@0.50.16 | bash

echo "✨ Installing Helm"
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-4
chmod 755 get_helm.sh
./get_helm.sh
rm get_helm.sh

echo "✨ Starting Kind cluster"
kind create cluster --config features/kubernetes/config.yaml --wait 300s
kubectl cluster-info

echo "✅ Kubernetes cluster is ready"


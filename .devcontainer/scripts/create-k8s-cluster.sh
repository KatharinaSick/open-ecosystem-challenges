#!/usr/bin/env bash
set -e

echo "Installing Kind..."
curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.30.0/kind-linux-amd64
chmod +x ./kind
sudo mv ./kind /usr/local/bin/kind

echo "Installing kubectl..."
curl -LO "https://dl.k8s.io/release/v1.34.1/bin/linux/amd64/kubectl"
chmod +x kubectl
sudo mv kubectl /usr/local/bin/

echo "Starting Kind cluster..."
kind create cluster --name open-ecosystem-challenge --wait 300s
kubectl cluster-info


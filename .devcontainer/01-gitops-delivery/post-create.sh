#!/usr/bin/env bash
set -e

chmod +x .devcontainer/scripts/create-k8s-cluster.sh
.devcontainer/scripts/create-k8s-cluster.sh

chmod +x .devcontainer/scripts/install-argocd.sh
.devcontainer/scripts/install-argocd.sh

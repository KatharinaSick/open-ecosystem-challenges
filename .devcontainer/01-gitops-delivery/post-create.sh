#!/usr/bin/env bash
set -e

chmod +x .devcontainer/scripts/kubernetes/create-cluster.sh
.devcontainer/scripts/kubernetes/create-cluster.sh

chmod +x .devcontainer/scripts/argocd/install.sh
.devcontainer/scripts/argocd/install.sh

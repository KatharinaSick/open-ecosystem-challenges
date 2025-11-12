#!/usr/bin/env bash
set -e

chmod +x features/kubernetes/create-cluster.sh
features/kubernetes/create-cluster.sh

chmod +x features/argocd/install.sh
features/argocd/install.sh

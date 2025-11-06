#!/usr/bin/env bash
set -e

../scripts/create-k8s-cluster.sh
../scripts/install-argocd.sh

#!/usr/bin/env bash
set -e

features/kubernetes/init.sh
features/argocd/init.sh --read-only

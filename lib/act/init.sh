#!/usr/bin/env bash
set -e

echo "✨ Installing nektos/act for local GitHub Actions execution"
gh extension install https://github.com/nektos/gh-act

echo "✅ nektos/act is ready"
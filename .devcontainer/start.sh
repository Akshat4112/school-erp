#!/usr/bin/env bash
# Runs on every new or restarted GitHub Codespace; no local machine needed.
set -euo pipefail
cd "$(dirname "$0")/.."
bash dev/cloud-bootstrap.sh

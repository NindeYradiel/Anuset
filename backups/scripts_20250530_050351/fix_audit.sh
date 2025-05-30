#!/bin/bash
set -euo pipefail
cd "$(dirname "$0")/../frontend"
npm audit fix --force


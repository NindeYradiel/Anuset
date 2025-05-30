#!/bin/bash
set -euo pipefail

FRONTEND_DIR="$(dirname "$0")/../frontend"

if [ -d "$FRONTEND_DIR" ]; then
  cd "$FRONTEND_DIR"
  echo "🛠️ Arreglando problemas de auditoría en frontend..."
  npm audit fix || true
else
  echo "⚠️  Directorio frontend no encontrado. Saltando auditoría."
fi

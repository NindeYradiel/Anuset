#!/bin/bash
set -euo pipefail

echo "🚀 Iniciando servicio IA: $(basename $(pwd))"
echo "📂 Directorio de trabajo: $(pwd)"

# Verificar si app.py existe
if [[ -f "./app.py" ]]; then
  echo "▶️ Ejecutando app.py..."
  exec python3 app.py
else
  echo "⚠️ Error: No se encontró app.py en $(pwd)"
  exit 1
fi

#!/bin/bash
set -euo pipefail

MODEL_DIR="./data/codellama/models"
MODEL_FILE="$MODEL_DIR/codellama-model.bin"

if [ ! -f "$MODEL_FILE" ]; then
  echo "❌ Modelo no encontrado en $MODEL_FILE"
  echo "ℹ️ Ejecuta ./download_models.sh primero."
  exit 1
fi

echo "🚀 Lanzando servicio Codellama con modelo $MODEL_FILE"
exec python3 app.py

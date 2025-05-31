#!/bin/bash
set -euo pipefail

MODEL_DIR="./data/xtts-es/models"
MODEL_FILE="$MODEL_DIR/xtts-es-model.bin"

if [ ! -f "$MODEL_FILE" ]; then
  echo "❌ Modelo no encontrado en $MODEL_FILE"
  echo "ℹ️ Ejecuta ./download_models.sh primero."
  exit 1
fi

echo "🚀 Lanzando servicio Xtts-es con modelo $MODEL_FILE"
exec python3 app.py

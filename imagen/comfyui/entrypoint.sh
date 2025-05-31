#!/bin/bash
set -euo pipefail

MODEL_DIR="./data/comfyui/models"
MODEL_FILE="$MODEL_DIR/comfyui-model.bin"

if [ ! -f "$MODEL_FILE" ]; then
  echo "❌ Modelo no encontrado en $MODEL_FILE"
  echo "ℹ️ Ejecuta ./download_models.sh primero."
  exit 1
fi

echo "🚀 Lanzando servicio Comfyui con modelo $MODEL_FILE"
exec python3 app.py

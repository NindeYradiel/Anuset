#!/bin/bash
set -euo pipefail

MODEL_DIR="./data/animatediff/models"
MODEL_FILE="$MODEL_DIR/animatediff-model.bin"

if [ ! -f "$MODEL_FILE" ]; then
  echo "❌ Modelo no encontrado en $MODEL_FILE"
  echo "ℹ️ Ejecuta ./download_models.sh primero."
  exit 1
fi

echo "🚀 Lanzando servicio Animatediff con modelo $MODEL_FILE"
exec python3 app.py

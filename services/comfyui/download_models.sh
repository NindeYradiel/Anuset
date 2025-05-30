#!/bin/bash
set -euo pipefail
echo "⬇️ Descargando modelo de Comfyui..."

MODEL_DIR="./data/comfyui/models"
mkdir -p "$MODEL_DIR"

# Aquí va tu comando real de descarga, por ejemplo:
echo "🌀 Simulando descarga de Comfyui..."
touch "$MODEL_DIR/comfyui-model.bin"

# ==== FINALIZACIÓN ====
echo "✅ Modelos descargados para Comfyui:"
ls -lh "$MODEL_DIR"

#!/bin/bash
set -euo pipefail
echo "⬇️ Descargando modelo de Codellama..."

MODEL_DIR="./data/codellama/models"
mkdir -p "$MODEL_DIR"

# Aquí va tu comando real de descarga, por ejemplo:
echo "🌀 Simulando descarga de Codellama..."
touch "$MODEL_DIR/codellama-model.bin"

# ==== FINALIZACIÓN ====
echo "✅ Modelos descargados para Codellama:"
ls -lh "$MODEL_DIR"

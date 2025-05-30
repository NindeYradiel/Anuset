#!/bin/bash
set -euo pipefail
echo "⬇️ Descargando modelo de Animatediff..."

MODEL_DIR="./data/animatediff/models"
mkdir -p "$MODEL_DIR"

# Aquí va tu comando real de descarga, por ejemplo:
echo "🌀 Simulando descarga de Animatediff..."
touch "$MODEL_DIR/animatediff-model.bin"

# ==== FINALIZACIÓN ====
echo "✅ Modelos descargados para Animatediff:"
ls -lh "$MODEL_DIR"

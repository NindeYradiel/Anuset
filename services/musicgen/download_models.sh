#!/bin/bash
set -euo pipefail
echo "⬇️ Descargando modelo de Musicgen..."

MODEL_DIR="./data/musicgen/models"
mkdir -p "$MODEL_DIR"

# Aquí va tu comando real de descarga, por ejemplo:
echo "🌀 Simulando descarga de Musicgen..."
touch "$MODEL_DIR/musicgen-model.bin"

# ==== FINALIZACIÓN ====
echo "✅ Modelos descargados para Musicgen:"
ls -lh "$MODEL_DIR"

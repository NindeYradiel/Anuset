#!/bin/bash
set -euo pipefail
echo "⬇️ Descargando modelo de Xtts-es..."

MODEL_DIR="./data/xtts-es/models"
mkdir -p "$MODEL_DIR"

# Aquí va tu comando real de descarga, por ejemplo:
echo "🌀 Simulando descarga de Xtts-es..."
touch "$MODEL_DIR/xtts-es-model.bin"

# ==== FINALIZACIÓN ====
echo "✅ Modelos descargados para Xtts-es:"
ls -lh "$MODEL_DIR"

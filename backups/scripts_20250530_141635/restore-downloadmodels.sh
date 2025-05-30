#!/usr/bin/env bash
set -euo pipefail

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$PROJECT_ROOT"

echo "🧠 Restaurando o descargando modelos IA..."

declare -A models=(
  ["stableaudio"]="https://huggingface.co/stabilityai/stable-audio-open-1.0/resolve/main/model.pth"
  ["xtts-es"]="https://huggingface.co/coqui/XTTS-v2/resolve/main/model.pth"
  ["memgpt"]="https://huggingface.co/download/memgpt/models/memgpt-7b-instruct.bin"
  ["codellama"]="https://huggingface.co/TheBloke/CodeLlama-7B-Instruct-GGUF/resolve/main/codellama-7b-instruct.Q4_K_M.gguf"
  ["musicgen"]="https://huggingface.co/facebook/musicgen-small/resolve/main/model.bin"
  ["animatediff"]="https://huggingface.co/ByteDance/AnimateDiff-Lightning/resolve/main/mm_sdxl_v10_beta.ckpt"
)

for name in "${!models[@]}"; do
  url="${models[$name]}"
  folder="./data/$name/models"
  mkdir -p "$folder"
  filename=$(basename "$url")

  echo "📦 $name → $folder/$filename"

  if [[ -f "$folder/$filename" ]]; then
    echo "✅ Modelo ya presente, omitiendo."
  else
    echo "⏬ Descargando $filename..."
    curl -L "$url" -o "$folder/$filename"
    echo "✅ Descargado."
  fi
done

echo "🚀 Modelos listos. Puedes lanzar los servicios."

#!/bin/bash
# diag_anu89.sh mejorado: revisa modelos automáticamente

set -euo pipefail
IFS=$'\n\t'

echo "🧠 Iniciando diagnóstico de modelos Anuset89..."
echo

# Función para verificar modelos (última versión válida)
check_model() {
  local name="$1"
  local path="$2"
  local pattern="$3"

  echo "🔎 $name → $path"

  if [[ -d "$path" ]]; then
    local newest_file
    newest_file=$(find "$path" -type f -name "$pattern" \
      ! -path "*/.git/lfs/incomplete/*" \
      -printf "%T@ %p\n" 2>/dev/null | sort -nr | head -n1 | cut -d' ' -f2-)

    if [[ -n "$newest_file" ]]; then
      local mod_time
      mod_time=$(date -d @"$(stat -c %Y "$newest_file")" +"%Y-%m-%d %H:%M:%S")
      echo "✅ Modelo encontrado: $(basename "$newest_file")"
      echo "📅 Última modificación: $mod_time"
    else
      echo "⚠️ Carpeta encontrada pero modelo faltante (ningún '$pattern' válido fuera de LFS incompleto)"
    fi
  else
    echo "❌ Carpeta no encontrada: $path"
  fi

  echo
}

# Lista de modelos y rutas relevantes
check_model "StableAudio"    "./data/stableaudio/models"     "*.pth"
check_model "XTTS-es"         "./data/xtts-es/model"          "*.pth"
check_model "MemGPT"          "./data/memgpt/models"          "*.bin"
check_model "CodeLLaMA"       "./data/codellama/models"       "*.bin"
check_model "MusicGen"        "./data/musicgen/models"        "*.bin"
check_model "AnimateDiff"     "./data/animatediff/models"     "*.ckpt"
check_model "ComfyUI"         "./data/comfyui"                "*.ckpt"

# Final
echo "🚀 Diagnóstico de modelos completo."
echo

#!/bin/bash
set -euo pipefail

echo "📥 Iniciando descarga de todos los modelos necesarios para Anuset-FINAL..."
BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DATA_DIR="$BASE_DIR/data"

function download_model() {
    local name="$1"
    local hf_repo="$2"
    local target_dir="$3"

    echo -e "\n🐾 Verificando modelo: $name"

    if [ -d "$target_dir" ] && [ "$(ls -A "$target_dir")" ]; then
        echo "✅ Modelo $name ya está descargado."
        return
    fi

    echo "⬇️ Descargando modelo $name desde $hf_repo..."

    TMP_DIR="$DATA_DIR/tmp_${name}_$$"
    mkdir -p "$TMP_DIR"

    if huggingface-cli download "$hf_repo" --local-dir "$TMP_DIR" --local-dir-use-symlinks False; then
        echo "✅ Descarga completada con huggingface-cli"
    else
        echo "❌ huggingface-cli falló, intentando git lfs clone..."
        if git lfs clone "https://huggingface.co/$hf_repo" "$TMP_DIR"; then
            echo "✅ Descarga completada con git lfs"
        else
            echo "❌ Error al clonar $name"
            rm -rf "$TMP_DIR"
            return
        fi
    fi

    mkdir -p "$target_dir"
    mv "$TMP_DIR"/* "$target_dir"/
    rm -rf "$TMP_DIR"
}

# Modelos definidos (puedes añadir más fácilmente)
download_model "stable-diffusion" "stabilityai/stable-diffusion-3.5-large" "$DATA_DIR/stable-diffusion/models"
download_model "memgpt"            "starsnatched/MemGPT"                     "$DATA_DIR/memgpt/models"
download_model "stableaudio"      "stabilityai/stable-audio-open-1.0"       "$DATA_DIR/stableaudio/models"
download_model "codellama"        "codellama/CodeLlama-7b-Instruct-hf"      "$DATA_DIR/codellama/models"
download_model "xtts-es"          "coqui/XTTS-v2"                            "$DATA_DIR/xtts-es/model"
download_model "animatediff"      "guoyww/animatediff"                       "$DATA_DIR/animatediff/models"

echo -e "\n🎉 Descarga de modelos completada."

# ==== FINALIZACIÓN AUTOMÁTICA ====

echo "🎯 Verificando estructuras de carpetas para cada servicio..."

SERVICIOS=$(ls ./data 2>/dev/null || echo "")
for servicio in $SERVICIOS; do
  MODELS_DIR="./data/$servicio/models"
  if [ ! -d "$MODELS_DIR" ]; then
    echo "📁 Creando carpeta de modelos para: $servicio"
    mkdir -p "$MODELS_DIR" || echo "❌ No se pudo crear $MODELS_DIR. Verifica permisos."
  fi
done

echo "✅ Verificación completa. Carpetas listas."

# ==== LISTADO FINAL DE MODELOS DESCARGADOS ====
echo -e "\n📦 Modelos actualmente en ./data/*/models:"
find ./data -type d -name "models" -exec sh -c 'ls "{}"' \; -exec echo "---" \;


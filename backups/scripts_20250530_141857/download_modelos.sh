#!/bin/bash
#
# scripts/download_models.sh
# Descarga y verifica todos los modelos de IA necesarios para Anuset-FINAL

set -euo pipefail
IFS=$'\n\t'

echo "📥 Iniciando descarga de todos los modelos necesarios para Anuset-FINAL..."

base_dir="$(cd "$(dirname "$0")/.." && pwd)"
cd "$base_dir"

# 📦 Diccionario de modelos por servicio: "servicio"="ruta repo rama"
declare -A MODELS=(
  ["stable-diffusion"]="data/stable-diffusion/models stabilityai/stable-diffusion-3.5-large main"
  ["memgpt"]="data/memgpt/models starsnatched/MemGPT main"
  ["stableaudio"]="data/stableaudio/models stabilityai/stable-audio-open-1.0 main"
  ["codellama"]="data/codellama/models codellama/CodeLlama-7b-Instruct-hf main"
  ["xtts-es"]="data/xtts-es/model coqui/XTTS-v2 main"
  ["animatediff"]="data/animatediff/models guoyww/animatediff main"
)

only=""
showmodels=false
logfile="download_models_$(date +%Y%m%d_%H%M%S).log"

# 🧩 Argumentos de línea
for arg in "$@"; do
  case "$arg" in
    --only=*)
      only="${arg#*=}"
      ;;
    --showmodels)
      showmodels=true
      ;;
  esac
done

# 🔍 Mostrar modelos disponibles
if $showmodels; then
  echo "📦 Modelos disponibles:"
  for model in "${!MODELS[@]}"; do
    echo "  - $model"
  done
  exit 0
fi

# 🧮 Verifica espacio en disco antes de descargar
check_disk_space() {
  REQUIRED_GB=10
  FREE_GB=$(df -BG "$base_dir" | tail -1 | awk '{print $4}' | sed 's/G//')
  if (( FREE_GB < REQUIRED_GB )); then
    echo "⚠️ Espacio insuficiente: ${FREE_GB}GB libres, se necesitan al menos ${REQUIRED_GB}GB." | tee -a "$logfile"
    exit 1
  fi
}

# 🔽 Descarga un modelo según su entrada en el diccionario
download_model() {
  local name="$1"
  local path="$2"
  local repo_id="$3"
  local branch="$4"

  echo -e "\n🐾 Verificando modelo: $name" | tee -a "$logfile"
  if [ -d "$path" ] && [ "$(ls -A "$path")" ]; then
    echo "✅ Modelo $name ya existe en $path" | tee -a "$logfile"
  else
    echo "⬇️ Descargando modelo $name desde $repo_id..." | tee -a "$logfile"
    mkdir -p "$path"
    cd "$path"
    if command -v huggingface-cli &>/dev/null; then
      echo "✨ Usando huggingface-cli para descarga..." | tee -a "$logfile"
      if huggingface-cli download "$repo_id" --local-dir "$path"; then
        echo "✅ Descarga completada con huggingface-cli" | tee -a "$logfile"
      else
        echo "❌ Fallo en huggingface-cli, probando git clone..." | tee -a "$logfile"
        cd "$base_dir"
        rm -rf "$path"
        mkdir -p "$path"
        cd "$path"
        git lfs install
        if git clone --branch "$branch" "https://huggingface.co/$repo_id" .; then
          echo "✅ Descarga completada con git clone" | tee -a "$logfile"
        else
          echo "❌ Error al clonar $name" | tee -a "$logfile"
          exit 1
        fi
      fi
    else
      echo "❌ huggingface-cli no disponible, usando git clone..." | tee -a "$logfile"
      git lfs install
      if git clone --branch "$branch" "https://huggingface.co/$repo_id" .; then
        echo "✅ Descarga completada con git clone" | tee -a "$logfile"
      else
        echo "❌ Error al clonar $name" | tee -a "$logfile"
        exit 1
      fi
    fi
    cd "$base_dir"
  fi
}

check_disk_space

IFS=',' read -ra MODEL_FILTER <<< "$only"

# 🔁 Ejecutar descarga para cada modelo en paralelo
for name in "${!MODELS[@]}"; do
  if [ -n "$only" ]; then
    skip=true
    for f in "${MODEL_FILTER[@]}"; do
      [[ "$name" == "$f" ]] && skip=false
    done
    $skip && continue
  fi

  IFS=' ' read -r path repo_id branch <<< "${MODELS[$name]}"
  download_model "$name" "$path" "$repo_id" "$branch" &
done

wait

echo -e "\n🎉 Descarga de modelos completada." | tee -a "$logfile"

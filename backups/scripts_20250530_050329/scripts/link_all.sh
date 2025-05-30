#!/bin/bash
set -euo pipefail

echo "🔗 Iniciando enlace simbólico de todos los modelos y servicios..."

# Rutas base
ANUSET_DIR="$HOME/Anuset"
RESPALDO_MODELS="$HOME/Respaldo/models"
DATA_DIR="$ANUSET_DIR/data"

# Crear enlaces simbólicos solo si no existen o apuntan a otro lado
link_model() {
  origen="$1"
  destino="$2"

  if [[ -f "$origen" ]]; then
    if [[ ! -e "$destino" || "$(readlink -f "$destino")" != "$(readlink -f "$origen")" ]]; then
      ln -sf "$origen" "$destino"
      echo "✅ Enlazado: $(basename "$origen") → $(basename "$destino")"
    else
      echo "🟣 Ya enlazado correctamente: $(basename "$destino")"
    fi
  fi
}

# Crear estructura de directorios si no existe
mkdir -p "$DATA_DIR"/{stable-diffusion,stableaudio,codellama,animatediff,xtts-es}/models

# Establecer rutas destino por tipo
SD_DIR="$DATA_DIR/stable-diffusion/models"
SA_DIR="$DATA_DIR/stableaudio/models"
CL_DIR="$DATA_DIR/codellama/models"
AD_DIR="$DATA_DIR/animatediff/models"
XT_DIR="$DATA_DIR/xtts-es/model"

# Procesar todos los modelos por extensión
for modelo in "$RESPALDO_MODELS"/*.{ckpt,safetensors}; do
  nombre="$(basename "$modelo")"

  # Detectar a qué grupo pertenece por nombre
  case "$nombre" in
    *sd*|*v1*|*v2*|*pro*|*safetensors|*master*) link_model "$modelo" "$SD_DIR/$nombre" ;;
    *audio*|*sound*)                           link_model "$modelo" "$SA_DIR/$nombre" ;;
    *code*|*llama*)                            link_model "$modelo" "$CL_DIR/$nombre" ;;
    *anim*|*diff*)                             link_model "$modelo" "$AD_DIR/$nombre" ;;
    *xtts*|*voice*)                            link_model "$modelo" "$XT_DIR/$nombre" ;;
    *) echo "⚠️ Modelo no clasificado: $nombre" ;;
  esac
done

# Enlaces al frontend y backend
ln -sfn "$ANUSET_DIR/frontend" "$ANUSET_DIR/services/frontend"
ln -sfn "$ANUSET_DIR/backend" "$ANUSET_DIR/services/backend"

echo "🎉 Enlaces simbólicos completados."

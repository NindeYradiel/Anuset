#!/bin/bash
# 🐾 scripts/enlazar_modelos.sh - Anuset ✨
# Crea symlinks desde ~/Respaldo/models/* hacia el servicio adecuado

echo "🔗 Buscando modelos en ~/Respaldo/models/..."

ORIG=~/Respaldo/models
DEST=services

# Asocia patrones con servicios
declare -A MAPEO=(
  [diff]="animatediff stable-diffusion"
  [anime]="animatediff"
  [music]="musicgen musica"
  [code]="codellama codigo"
  [llama]="codellama"
  [voice]="xtts-es voz"
  [tts]="xtts-es"
  [mem]="memgpt memoria mem0"
  [comfy]="comfyui"
  [estilo]="estilo"
)

# Recorre archivos
for modelo in "$ORIG"/*; do
  nombre=$(basename "$modelo")
  echo "🔍 Detectando destino para: $nombre"
  destino_detectado=false

  for patron in "${!MAPEO[@]}"; do
    if [[ "$nombre" == *"$patron"* ]]; then
      for servicio in ${MAPEO[$patron]}; do
        ruta_destino="$DEST/$servicio/models"
        mkdir -p "$ruta_destino"
        ln -sf "$modelo" "$ruta_destino/$nombre"
        echo "✅ $nombre → $ruta_destino/"
        destino_detectado=true
      done
    fi
  done

  if [ "$destino_detectado" = false ]; then
    echo "⚠️  No se encontró destino para: $nombre (ignorado)"
  fi
done

echo "✨ Enlace de modelos completado."

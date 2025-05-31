#!/bin/bash
# cleanup_anu89.sh - Limpieza automatizada de Anuset89-Vault

echo "🧹 Iniciando limpieza... Puedes revisar /home/saze/Respaldo si algo se mueve."

# 1. Archivos fantasma en la raíz
echo "1️⃣ Eliminando archivos vacíos/raros en raíz..."
for ghost in '['' =' '[backend' '[backend]' '[animatediff' '[animatediff]' '[codellama' '[codellama]' '[comfyui' '[comfyui]' '[memgpt' '[memgpt]' '[musicgen' '[musicgen]' '[stableaudio' '[stableaudio]' '[xtts-es' '[xtts-es]'; do
  if [[ -e "$ghost" ]]; then
    echo "  • Eliminando '$ghost'"
    rm -rf "$ghost"
  fi
done

# 2. Eliminar carpeta Anuset89/d/ si existe
if [[ -d "Anuset89/d" ]]; then
  echo "2️⃣ Moviendo Anuset89/d/ a /home/saze/Respaldo/ (o eliminando)..."
  mkdir -p /home/saze/Respaldo
  mv Anuset89/d/ /home/saze/Respaldo/ || rm -rf Anuset89/d/
fi

# 3. Eliminar objetos temporales de Git
echo "3️⃣ Limpiando temporales de Git (.git/objects/pack/tmp_pack_*)..."
find .git/objects/pack -type f -name 'tmp_pack_*' -print -exec rm -f {} \;

# 4. Mover modelos pesados de data/imagen/models/ a /home/saze/Respaldo/models/
echo "4️⃣ Moviendo modelos pesados de data/imagen/models/ a /home/saze/Respaldo/models/ ..."
MODELPATH="data/imagen/models"
DEST="/home/saze/Respaldo/models"
if [[ -d "$MODELPATH" ]]; then
  mkdir -p "$DEST"
  find "$MODELPATH" -type f \( -iname "*.safetensors" -o -iname "*.ckpt" \) -size +100M | while read -r m; do
    echo "  • Moviendo $(basename "$m")"
    mv "$m" "$DEST/"
  done

  # Si el directorio quedó vacío, lo eliminamos
  if [[ -z "$(ls -A "$MODELPATH")" ]]; then
    echo "  • $MODELPATH está vacío. Eliminando..."
    rmdir "$MODELPATH"
  fi
fi
echo "✅ Limpieza completada con éxito."
echo "📦 Revisa /home/saze/Respaldo para archivos respaldados."

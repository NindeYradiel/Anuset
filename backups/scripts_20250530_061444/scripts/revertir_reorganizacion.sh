#!/bin/bash
set -euo pipefail

echo "♻️ Revirtiendo estructura Anuset..."

BASE="$HOME/Anuset"
SERVICES="$BASE/services"
ARCHIVES="$BASE/archives"
TMP="$BASE/tmp"
MODELS="$BASE/models"
DATA="$BASE/data"

# 1. Restaurar backend, frontend, animatediff a raíz
for svc in backend frontend animatediff; do
  if [[ -d "$SERVICES/$svc" ]]; then
    echo "🔄 Restaurando $svc/ a raíz del proyecto"
    mv "$SERVICES/$svc" "$BASE/$svc"
    ln -s "$BASE/$svc" "$SERVICES/$svc"
  fi
done

# 2. Restaurar models/ y data/
mkdir -p "$MODELS" "$DATA"

for dir in "$SERVICES"/*; do
  name=$(basename "$dir")
  modelpath="$dir/models"
  logpath="$modelpath/logs"

  if [[ -d "$modelpath" ]]; then
    echo "🧬 Devolviendo modelos de $name → models/"
    mkdir -p "$MODELS/$name" 2>/dev/null || echo "⚠️ No se pudo crear $MODELS/$name"
    mv "$modelpath"/* "$MODELS/$name/" 2>/dev/null || echo "⚠️ No se pudieron mover modelos de $name"
  fi

  if [[ -d "$logpath" ]]; then
    echo "🧾 Devolviendo logs de $name → data/"
    mkdir -p "$DATA/$name" 2>/dev/null || echo "⚠️ No se pudo crear $DATA/$name"
    mv "$logpath"/* "$DATA/$name/" 2>/dev/null || echo "⚠️ No se pudieron mover logs de $name"
  fi
done

# 3. Restaurar archivos sueltos
for f in CACHED CANCELED tree writing transferring re; do
  [[ -e "$TMP/$f" ]] && echo "📂 Restaurando $f → raíz" && mv "$TMP/$f" "$BASE/"
done

# 4. Restaurar services.zip
[[ -f "$ARCHIVES/services.zip" ]] && echo "📦 Restaurando services.zip" && mv "$ARCHIVES/services.zip" "$BASE/"

echo "✅ Reversión completada. La estructura anterior ha sido restaurada."

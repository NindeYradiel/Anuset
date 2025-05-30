#!/bin/bash
set -euo pipefail

echo "🧹 Iniciando reorganización estructural de Anuset..."

# Rutas
BASE="$HOME/Anuset"
SERVICES="$BASE/services"
ARCHIVES="$BASE/archives"
TMP="$BASE/tmp"
MODELS="$BASE/models"
DATA="$BASE/data"

# 1. Preparar directorios de destino
mkdir -p "$ARCHIVES" "$TMP"

# 2. Mover servicios duplicados raíz → services/
for svc in animatediff backend frontend; do
  SRC="$BASE/$svc"
  DST="$SERVICES/$svc"

  if [[ -d "$SRC" && ! -L "$DST" ]]; then
    echo "📦 Moviendo $svc/ a services/"
    mv "$SRC" "$SERVICES/${svc}-real"
    rm -rf "$DST"
    mv "$SERVICES/${svc}-real" "$DST"
  fi
done

# 3. Eliminar symlinks si quedan
for link in backend frontend; do
  LINK="$SERVICES/$link"
  [[ -L "$LINK" ]] && echo "🗑️  Eliminando symlink: $LINK" && rm "$LINK"
done

# 4. Mover ZIPs y backups
if [[ -f "$BASE/services.zip" ]]; then
  echo "📦 Moviendo services.zip → archives/"
  mv "$BASE/services.zip" "$ARCHIVES/"
fi

# 5. Mover archivos vacíos o dispersos a tmp/
for f in CACHED CANCELED tree writing transferring re; do
  [[ -e "$BASE/$f" ]] && echo "📂 Moviendo $f → tmp/" && mv "$BASE/$f" "$TMP/"
done

# 6. Reubicar modelos a cada servicio
if [[ -d "$MODELS" ]]; then
  for service in "$MODELS"/*; do
    name=$(basename "$service")
    dest="$SERVICES/$name/models"
    if [[ -d "$service" && -d "$SERVICES/$name" ]]; then
      echo "🎯 Moviendo modelos $name → services/$name/models/"
      mkdir -p "$dest"
      mv "$service"/* "$dest/" 2>/dev/null || true
    fi
  done
  rmdir "$MODELS" 2>/dev/null || true
fi

# 7. Mover data a cada servicio
if [[ -d "$DATA" ]]; then
  for service in "$DATA"/*; do
    name=$(basename "$service")
    dest="$SERVICES/$name/models/logs"
    if [[ -d "$service" && -d "$SERVICES/$name" ]]; then
      echo "🗃️  Moviendo data $name → services/$name/models/logs/"
      mkdir -p "$dest"
      mv "$service"/* "$dest/" 2>/dev/null || true
    fi
  done
  rmdir "$DATA" 2>/dev/null || true
fi

echo "✅ Reorganización completa. Estructura limpia y lista para los rituales ✨"

#!/bin/bash
set -euo pipefail

SERVICE="$1"
FILE="services/$SERVICE/app.py"

if [ ! -f "$FILE" ]; then
    echo "❌ No se encontró $FILE"
    exit 1
fi

echo "👁️ Vigilando cambios en $FILE... (Ctrl+C para salir)"

while inotifywait -e close_write "$FILE"; do
    echo "🔁 Cambios detectados en $SERVICE. Actualizando requirements.txt..."
    make actualizar-requirements NAME="$SERVICE"
done

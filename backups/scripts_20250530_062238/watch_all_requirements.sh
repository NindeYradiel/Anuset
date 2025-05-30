#!/bin/bash
set -euo pipefail

echo "👁️ Vigilando *todos* los app.py..."

find services -type f -name app.py | while read -r file; do
    service=$(basename "$(dirname "$file")")
    echo "👁️ Activado: $service"
    inotifywait -mq -e close_write "$file" |
    while read -r _; do
        echo "🔁 Cambios en $service. Actualizando requirements.txt..."
        make actualizar-requirements NAME="$service"
    done &
done

wait

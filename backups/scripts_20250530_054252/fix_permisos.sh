#!/bin/bash
set -euo pipefail

echo "🛠️ Corrigiendo permisos en ~/Anuset..."
BASE="$HOME/Anuset"
USER=$(whoami)

# No tocar estos directorios
EXCLUDE_DIRS=(
  "$BASE/.git"
)

# Verifica si un archivo o carpeta está dentro de las excluidas
is_excluded() {
  for ex in "${EXCLUDE_DIRS[@]}"; do
    if [[ "$1" == "$ex"* ]]; then
      return 0
    fi
  done
  return 1
}

# Recorre todo y corrige dueño si no eres tú
find "$BASE" \( -type f -o -type d \) ! -user "$USER" | while read -r item; do
  if is_excluded "$item"; then
    echo "🔒 Saltando $item (excluido)"
    continue
  fi
  echo "🔧 Corrigiendo dueño de: $item"
  sudo chown "$USER:$USER" "$item"
done

echo "✅ Todos los permisos están ahora bajo control de $USER."

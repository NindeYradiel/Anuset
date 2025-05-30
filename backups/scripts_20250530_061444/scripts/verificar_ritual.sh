#!/bin/bash
set -euo pipefail

echo "🔍 Verificando estado de contenedores antes del ritual..."

running=$(docker ps -q)

if [[ -n "$running" ]]; then
  echo "🛑 Contenedores en ejecución detectados:"
  docker ps --format "   → {{.Names}} ({{.Image}}) - {{.Status}}"
  echo
  read -p "❓ ¿Deseas detenerlos y hacer una limpieza (docker system prune)? (s/n) " respuesta
  if [[ "$respuesta" == "s" ]]; then
    echo "⛔ Deteniendo contenedores..."
    docker compose down
    echo "🧹 Haciendo limpieza profunda con docker system prune..."
    docker system prune -f
  else
    echo "❌ Ritual cancelado por el usuario."
    exit 1
  fi
else
  echo "✅ No hay contenedores activos. Continuamos con el ritual..."
fi

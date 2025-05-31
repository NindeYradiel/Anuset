#!/bin/bash
# Script robusto para copiar nginx.conf y dist/ al contenedor "frontend"

set -euo pipefail

PROJECT_ROOT="/home/saze/Anuset89-Vault"
CONTAINER_NAME="frontend"

# Verificar si el contenedor existe
if ! docker ps -a --format '{{.Names}}' | grep -q "^${CONTAINER_NAME}$"; then
  echo "❌ El contenedor '${CONTAINER_NAME}' no existe."
  docker ps -a
  exit 1
fi

# Iniciar si no está corriendo
if ! docker ps --format '{{.Names}}' | grep -q "^${CONTAINER_NAME}$"; then
  echo "🟡 El contenedor '${CONTAINER_NAME}' no está corriendo. Iniciando..."
  docker start "${CONTAINER_NAME}" || {
    echo "❌ No se pudo iniciar el contenedor '${CONTAINER_NAME}'."
    exit 1
  }
  sleep 3
fi

# Verificación de archivos
if [[ ! -f "${PROJECT_ROOT}/frontend/nginx.conf" ]]; then
  echo "❌ No se encontró nginx.conf en ${PROJECT_ROOT}/frontend/"
  exit 1
fi

if [[ ! -d "${PROJECT_ROOT}/frontend/dist" ]]; then
  echo "❌ No se encontró la carpeta dist/ en ${PROJECT_ROOT}/frontend/"
  exit 1
fi

# Copiar archivos
echo "📁 Copiando nginx.conf..."
docker cp "${PROJECT_ROOT}/frontend/nginx.conf" "${CONTAINER_NAME}:/etc/nginx/conf.d/default.conf"

echo "📁 Copiando dist/..."
docker cp "${PROJECT_ROOT}/frontend/dist/." "${CONTAINER_NAME}:/usr/share/nginx/html/front/"

# Recargar nginx
echo "🔄 Recargando Nginx..."
docker exec -it "${CONTAINER_NAME}" nginx -s reload || {
  echo "⚠️  No se pudo recargar Nginx automáticamente. ¿Está instalado dentro del contenedor?"
  exit 1
}

echo "✅ ¡Archivos copiados y Nginx recargado en '${CONTAINER_NAME}'!"

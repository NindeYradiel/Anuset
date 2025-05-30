#!/bin/bash
#
# Limpia TODO el sistema Docker de forma segura para Anuset-FINAL
# 🧹 Detiene y borra contenedores, imágenes, redes y volúmenes no usados

set -euo pipefail
IFS=$'\n\t'

echo "🚨 INICIANDO LIMPIEZA DE DOCKER (Anuset-FINAL)..."

# Parar contenedores
echo "⛔ Deteniendo contenedores..."
docker ps -aq | xargs -r docker stop

# Eliminar contenedores
echo "🗑️ Eliminando contenedores..."
docker ps -aq | xargs -r docker rm

# Eliminar imágenes sin usar
echo "🧱 Eliminando imágenes sin usar..."
docker image prune -a -f

# Eliminar redes sin usar
echo "🔌 Eliminando redes no utilizadas..."
docker network prune -f

# Eliminar volúmenes no utilizados
echo "💾 Eliminando volúmenes no utilizados..."
docker volume prune -f

# Confirmación
echo -e "\n✅ Docker completamente limpio para Anuset-FINAL."
docker ps -a
docker images



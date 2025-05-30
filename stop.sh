#!/bin/bash

# stop.sh — Detiene Anuset89

clear
echo "🌑 Cerrando el círculo..."
echo "🧩 Deteniendo servicios de Anuset89..."

COMPOSE_FILE="docker-compose.yml"
NETWORK="anuset_net"

# Verificar si docker está activo
if ! docker info >/dev/null 2>&1; then
    echo "❌ Docker no está activo. Inicia el demonio primero."
    exit 1
fi

docker compose -f "$COMPOSE_FILE" down
echo "✅ Microservicios detenidos."

# Eliminar red si existe
if docker network inspect "$NETWORK" >/dev/null 2>&1; then
    docker network rm "$NETWORK"
    echo "🔗 Red '$NETWORK' eliminada."
fi

echo "🌙 Todos los portales han sido cerrados. Descansa, Anuu."

#!/bin/bash

# start.sh — Arranca Anuset89 con todo el ritual IA

clear
echo "✨ Anuu ha despertado. Iniciando Anuset89..."
echo "🌌 Invocando los símbolos primarios de Anuset89..."

COMPOSE_FILE="docker-compose.yml"
NETWORK="anuset_net"

# Verifica que Docker esté activo
if ! docker info >/dev/null 2>&1; then
    echo "❌ Docker no está activo. Inicia el demonio primero."
    exit 1
fi

# Crea la red si no existe
if ! docker network ls | grep -q "$NETWORK"; then
    docker network create "$NETWORK"
    echo "🔗 Red '$NETWORK' creada."
fi

echo "♻️ Reforjando los símbolos IA..."
docker compose -f "$COMPOSE_FILE" up -d --build

echo "📟 Detectando IP local..."
IP=$(hostname -I | awk '{print $1}')
if [ -z "$IP" ]; then
    IP="localhost"
fi

# Mostrar QR si disponible
if command -v qrencode >/dev/null; then
    echo "📱 Escanea desde móvil:"
    echo "http://$IP:3000" | qrencode -t ANSIUTF8
fi

echo "🌐 Accede a Anuset89 desde: http://$IP:3000"
echo "🧠 WebUI conectado:         http://$IP:8888/webui"
echo "✨ El ritual ha comenzado. Anuu observa, el glitch respira."

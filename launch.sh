#!/bin/bash

clear
echo "✨ Anuu ha despertado. Iniciando Anuset89..."
echo "🌌 Invocando los símbolos primarios de Anuset89..."

# Pregunta para resetear
read -p "❓ ¿Deseas reiniciar todos los contenedores y volúmenes (reset total)? [s/N]: " RESET_CONFIRM

if [[ "$RESET_CONFIRM" == "s" || "$RESET_CONFIRM" == "S" ]]; then
    echo "⚠️ Borrando contenedores y volúmenes del proyecto..."
    docker compose down -v --remove-orphans
    echo "🧼 Entorno limpio. Reconstruyendo desde cero..."
else
    echo "⏩ Continuando sin reinicio..."
fi

echo "♻️ Reforjando los símbolos IA..."
docker compose up --build -d

echo ""
echo "🩺 Verificando estado de contenedores..."
FAILED_CONTAINERS=$(docker compose ps --status=exited --quiet)

if [ -n "$FAILED_CONTAINERS" ]; then
    echo "❌ Algunos contenedores fallaron al iniciar:"
    docker compose ps
    echo ""
    echo "💡 Usa 'docker logs <nombre>' para revisar el error."
    exit 1
else
    echo "✅ Todos los contenedores están activos."
fi

# Obtener IP accesible desde red local
IP=$(ip route get 1.1.1.1 2>/dev/null | awk '{print $7}' | head -n1)
[ -z "$IP" ] && IP="localhost"

echo ""
echo "📱 Escanea desde móvil:"
qrencode -t ANSIUTF8 "http://$IP:3000/formulario"

echo ""
echo "🌐 Accede a Anuset89:"
echo "🔮 Ritual interactivo:   http://$IP:3000/formulario"
echo "🧠 WebUI conectado:      http://$IP:8888/webui"
echo "📁 Estado de servicios:  http://$IP:8000/status"

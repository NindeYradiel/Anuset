#!/bin/bash
set -euo pipefail

SERVICES=(
  animatediff audio codellama codigo comfyui estilo imagen interaccion
  mem0 memgpt memoria musica musicgen openmemory stableaudio stable-diffusion
  video voz xtts-es
)

echo "\n🧪 Probando servicios IA en la red interna anuset_net..."

for service in "${SERVICES[@]}"; do
  echo -n "🔹 $service: "
  if docker exec "$service" curl -s http://localhost:8000/items > /dev/null; then
    echo "✅ OK"
  else
    echo "❌ FALLO"
    echo "🔍 Últimos logs de $service:"
    docker logs --tail 7 "$service" || echo "(sin logs)"
  fi
  echo ""
  sleep 0.2
done

echo "\n🌠 Pruebas completadas. Usa 'docker logs <servicio>' para más información."

# Añadir esto al Makefile:
#
# ## 🧪 make test-all
# ##    Prueba el endpoint /items de todos los servicios IA y muestra logs
# test-all: backup
# 	@bash scripts/test_all_services.sh


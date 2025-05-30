#!/bin/bash

# 💥 Limpiar todo el entorno Docker (containers, networks, volumes, images sin usar)
echo "[⚠️] Ejecutando prune completo de Docker..."
docker system prune -a --volumes -f

# 🔁 Relevantar contenedores desde cero
echo "[🚀] Levantando contenedores desde docker-compose.yml..."
docker-compose up -d --build

# ✅ Estado final
echo "[🔍] Estado de contenedores tras reinicio:"
docker ps -a

# 🔧 Recomendación: correr main_controller.py para ver estado de Anuset89
if [[ -f main_controller.py ]]; then
    echo "[🧠] Ejecutando verificación de servicios con main_controller.py"
    python3 main_controller.py
else
    echo "[ℹ️] No se encontró main_controller.py. Verificá manualmente."
fi


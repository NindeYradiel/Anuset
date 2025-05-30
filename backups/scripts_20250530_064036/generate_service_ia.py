#!/usr/bin/env python3
import os
from pathlib import Path

# Servicios IA que necesitan app.py y Dockerfile
SERVICIOS = [
    "codellama", "xtts-es", "memgpt", "musicgen",
    "animatediff", "stable-diffusion", "comfyui", "stableaudio"
]

BASE_DIR = Path.home() / "Anuset" / "services"
APP_TEMPLATE = '''from fastapi import FastAPI

app = FastAPI()

@app.get("/")
def status():
    return {{"status": "Servicio {name} activo"}}
'''

ENTRYPOINT_TEMPLATE = '''#!/bin/bash
cd /app
echo "🚀 Iniciando servicio IA: $(basename $(pwd))"
exec uvicorn app:app --host 0.0.0.0 --port 8080
'''

DOCKERFILE_TEMPLATE = '''FROM python:3.10-slim
WORKDIR /app
COPY . /app
RUN pip install --no-cache-dir fastapi uvicorn
RUN chmod +x /app/entrypoint.sh
CMD ["/app/entrypoint.sh"]
'''

def generar_servicio(nombre):
    carpeta = BASE_DIR / nombre
    carpeta.mkdir(parents=True, exist_ok=True)

    app_py = carpeta / "app.py"
    if not app_py.exists():
        app_py.write_text(APP_TEMPLATE.format(name=nombre))
        print(f"✅ Creado: {app_py}")

    entry = carpeta / "entrypoint.sh"
    if not entry.exists():
        entry.write_text(ENTRYPOINT_TEMPLATE)
        entry.chmod(0o755)
        print(f"✅ Creado: {entry}")

    dockerfile = carpeta / "Dockerfile"
    if not dockerfile.exists():
        dockerfile.write_text(DOCKERFILE_TEMPLATE)
        print(f"✅ Creado: {dockerfile}")

if __name__ == "__main__":
    print("🔧 Generando archivos para servicios IA...")
    for svc in SERVICIOS:
        generar_servicio(svc)
    print("\n🌟 Todos los servicios IA tienen su app.py, Dockerfile y entrypoint.sh.")

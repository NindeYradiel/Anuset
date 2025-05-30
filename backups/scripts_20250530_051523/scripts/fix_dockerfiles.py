#!/usr/bin/env python3
import os
from pathlib import Path

# Servicios excluidos
EXCLUIR = {"frontend", "backend", "mem0", "openmemory"}

# Ruta base
BASE = Path("~/Anuset/services").expanduser()

# Contenido estándar
DOCKERFILE = '''FROM python:3.10-slim
WORKDIR /app
COPY . /app
RUN pip install --no-cache-dir fastapi uvicorn
RUN chmod +x /app/entrypoint.sh
CMD ["/app/entrypoint.sh"]
'''

ENTRYPOINT = '''#!/bin/bash
cd /app
echo "\U0001F680 Iniciando servicio IA: $(basename $(pwd))"
exec uvicorn app:app --host 0.0.0.0 --port 8080
'''

def arreglar_servicio(servicio):
    carpeta = BASE / servicio
    if not carpeta.exists():
        print(f"❌ No existe: {carpeta}")
        return

    # Dockerfile
    dockerfile = carpeta / "Dockerfile"
    if not dockerfile.exists():
        dockerfile.write_text(DOCKERFILE)
        print(f"✅ Dockerfile creado en {servicio}")

    # entrypoint.sh
    entrypoint = carpeta / "entrypoint.sh"
    if not entrypoint.exists():
        entrypoint.write_text(ENTRYPOINT)
        entrypoint.chmod(0o755)
        print(f"✅ entrypoint.sh creado en {servicio}")

if __name__ == "__main__":
    print("🔧 Aplicando fix a Dockerfiles y entrypoints...")
    for svc in os.listdir(BASE):
        if svc in EXCLUIR:
            continue
        arreglar_servicio(svc)
    print("\n🌟 Corrección completada para servicios IA.")

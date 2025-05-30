#!/usr/bin/env python3
import os
from pathlib import Path

BASE_DIR = Path.home() / "Anuset" / "services"

DOCKERFILE_TEMPLATE = '''FROM alpine:latest AS downloader
RUN apk add --no-cache curl git
WORKDIR /models
RUN echo "Sin descarga de modelo para {NAME}"

FROM python:3.11-slim
ENV PYTHONDONTWRITEBYTECODE=1 \\
    PYTHONUNBUFFERED=1 \\
    PATH="/app/bin:$PATH"

RUN adduser --disabled-password --gecos "" appuser
USER appuser

WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY . .

EXPOSE 8000
CMD ["python", "app.py"]
'''

def revisar_servicio(servicio_path):
    nombre = servicio_path.name
    print(f"🔍 Revisando: {nombre}")
    dockerfile = servicio_path / "Dockerfile"
    reqs = servicio_path / "requirements.txt"
    app = servicio_path / "app.py"

    errores = []

    if not app.exists():
        errores.append("❌ Falta app.py")

    if not reqs.exists():
        errores.append("⚠️  Falta requirements.txt")

    if not dockerfile.exists() or "FROM" not in dockerfile.read_text():
        errores.append("⚠️  Dockerfile ausente o incorrecto")

    for err in errores:
        print(f"  {err}")

    if errores:
        opcion = input(f"🛠 ¿Reparar Dockerfile de {nombre}? (s/n): ").strip().lower()
        if opcion == 's':
            if not reqs.exists():
                reqs.write_text("fastapi\nuvicorn\n")
                print("  ✅ requirements.txt creado.")
            dockerfile.write_text(DOCKERFILE_TEMPLATE.replace("{NAME}", nombre))
            print("  ✅ Dockerfile regenerado.")
    else:
        print("  ✅ Todo OK")

def main():
    for servicio in BASE_DIR.iterdir():
        if servicio.is_dir():
            revisar_servicio(servicio)

if __name__ == "__main__":
    main()

#!/bin/bash
set -euo pipefail

# === Anuset-FINAL :: Preparador de estructura ===
# Este script genera las carpetas y archivos clave para cada servicio IA definido

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

prepare_service() {
  local name=$1
  local target_dir="${PROJECT_ROOT}/services/${name}"

  mkdir -p "$target_dir"

  # Copiar entrypoint.sh si no existe
  if [[ ! -f "${target_dir}/entrypoint.sh" ]]; then
    cp "${PROJECT_ROOT}/scripts/base_entrypoint.sh" "${target_dir}/entrypoint.sh"
    chmod +x "${target_dir}/entrypoint.sh"
    echo "✅ entrypoint.sh creado para ${name}"
  fi

  # Copiar Dockerfile específico si no existe
  if [[ ! -f "${target_dir}/Dockerfile" ]]; then
    case "$name" in
      frontend)
        cp "${PROJECT_ROOT}/frontend/nginx.conf" "${target_dir}/nginx.conf"
        cat <<EOF > "${target_dir}/Dockerfile"
# Etapa de construcción
FROM node:20-alpine AS builder
WORKDIR /app
COPY ../../frontend ./
RUN npm install && npm run build

# Etapa de producción
FROM nginx:stable-alpine
WORKDIR /app
COPY --from=builder /app/dist /usr/share/nginx/html
COPY ./nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 3000
CMD ["nginx", "-g", "daemon off;"]
EOF
        ;;
      comfyui)
        cat <<EOF > "${target_dir}/Dockerfile"
FROM nvidia/cuda:11.8.0-cudnn8-runtime-ubuntu22.04
ENV DEBIAN_FRONTEND=noninteractive
WORKDIR /app
RUN apt-get update && apt-get install -y \
    python3 python3-pip git curl ffmpeg libgl1 && \
    pip3 install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu118 && \
    useradd -m appuser
COPY ./ /app
RUN pip3 install -r requirements.txt
USER appuser
EXPOSE 8188
ENTRYPOINT ["./entrypoint.sh"]
EOF
        ;;
      stable-diffusion)
        cat <<EOF > "${target_dir}/Dockerfile"
FROM python:3.10-slim
WORKDIR /app
RUN apt-get update && apt-get install -y git libgl1 && \
    useradd -m appuser
COPY ./ /app
RUN pip install --no-cache-dir -r requirements.txt || true
USER appuser
EXPOSE 7860
ENTRYPOINT ["./entrypoint.sh"]
EOF
        ;;
    esac
    echo "✅ Dockerfile creado para ${name}"
  fi
}

# Preparar servicios que fallaron hoy
prepare_service frontend
prepare_service comfyui
prepare_service stable-diffusion

echo '🎉 Estructura actualizada con éxito.'

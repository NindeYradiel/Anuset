#!/bin/bash
set -euo pipefail

# === Anuset-FINAL :: Preparador Unificado de servicios IA ===

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

#########################################
# Servicios IA funcionales (con modelo)
#########################################
prepare_service() {
  local name=$1
  local target_dir="${PROJECT_ROOT}/services/${name}"
  mkdir -p "$target_dir"

  # entrypoint
  if [[ ! -f "${target_dir}/entrypoint.sh" ]]; then
    cp "${PROJECT_ROOT}/scripts/base_entrypoint.sh" "${target_dir}/entrypoint.sh"
    chmod +x "${target_dir}/entrypoint.sh"
    echo "✅ entrypoint.sh creado para ${name}"
  fi

  # Dockerfile
  if [[ ! -f "${target_dir}/Dockerfile" ]]; then
    case "$name" in
      frontend)
        cp "${PROJECT_ROOT}/frontend/nginx.conf" "${target_dir}/nginx.conf"
        cat <<EOF > "${target_dir}/Dockerfile"
FROM node:20-alpine AS builder
WORKDIR /app
COPY ../../frontend ./
RUN npm install && npm run build
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
      *)
        cat <<EOF > "${target_dir}/Dockerfile"
FROM python:3.10-slim
WORKDIR /app
RUN apt-get update && apt-get install -y git libgl1 && \
  useradd -m appuser
COPY ./ /app
RUN pip install --no-cache-dir -r requirements.txt || true
USER appuser
EXPOSE 8080
ENTRYPOINT ["./entrypoint.sh"]
EOF
        ;;
    esac
    echo "✅ Dockerfile creado para ${name}"
  fi
}

#########################################
# Servicios Simbólicos (rituales)
#########################################
prepare_symbolic_service() {
  local name=$1
  local target_dir="${PROJECT_ROOT}/services/${name}"
  mkdir -p "$target_dir"

  declare -A field_map target_map path_map
  field_map=( [musica]=hechizo_musical [voz]=hechizo_verbal [codigo]=hechizo_codigo [memoria]=hechizo_recuerdo
              [imagen]=hechizo_visual [video]=hechizo_movimiento [audio]=hechizo_sonico [interaccion]=hechizo_dialogo [estilo]=hechizo_estilo )
  target_map=( [musica]=musicgen [voz]=xtts-es [codigo]=codellama [memoria]=memgpt
               [imagen]=stable-diffusion [video]=animatediff [audio]=stableaudio [interaccion]=memgpt [estilo]=comfyui )
  path_map=( [voz]=/tts [memoria]=/memoria [interaccion]=/dialogo [estilo]=/estilizar )

  local field="${field_map[$name]}"
  local target="${target_map[$name]}"
  local path="${path_map[$name]:-/generar}"

  # app.py
  if [[ ! -f "${target_dir}/app.py" ]]; then
    cat <<EOF > "${target_dir}/app.py"
from fastapi import FastAPI, HTTPException, Request
import subprocess
import json

app = FastAPI(title="Ritual de ${name^}", description="Servicio simbólico que invoca a $target.")

@app.post("/ritual-${name}")
async def ritual(request: Request):
    data = await request.json()
    hechizo = data.get("$field")
    if not hechizo:
        raise HTTPException(status_code=400, detail="Falta el campo '$field'.")

    try:
        result = subprocess.run(
            ["curl", "-s", "-X", "POST", "http://$target:8080$path", "-H", "Content-Type: application/json", "-d", json.dumps({"prompt": hechizo})],
            capture_output=True, text=True, timeout=60
        )
        return json.loads(result.stdout)
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error invocando $target: {{str(e)}}")
EOF
    echo "✅ app.py creado para ${name}"
  fi

  # Dockerfile
  if [[ ! -f "${target_dir}/Dockerfile" ]]; then
    cat <<EOF > "${target_dir}/Dockerfile"
FROM python:3.10-slim
WORKDIR /app
RUN apt-get update && apt-get install -y curl && useradd -m appuser
COPY ./ /app
RUN pip install fastapi uvicorn
USER appuser
EXPOSE 8080
ENTRYPOINT ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8080"]
EOF
    echo "✅ Dockerfile creado para ${name}"
  fi
}

# Servicios IA funcionales
for svc in frontend comfyui stable-diffusion codellama xtts-es memgpt musicgen stableaudio animatediff; do
  prepare_service "$svc"
done

# Servicios simbólicos
for sym in musica voz codigo memoria imagen video audio interaccion estilo; do
  prepare_symbolic_service "$sym"
done

echo '🎉 Todos los servicios (IA + simbólicos) han sido preparados.'

#!/usr/bin/env python3

services = [
    "animatediff", "audio", "codellama", "codigo", "comfyui",
    "estilo", "imagen", "interaccion", "mem0", "memgpt", "memoria",
    "musica", "musicgen", "openmemory", "stableaudio", "stable-diffusion",
    "video", "voz", "xtts-es"
]

def generate_service_block(service):
    return f"""  {service}:
    container_name: {service}
    build:
      context: ./services/{service}
    restart: unless-stopped
    ports: []
    networks:
      - anuset_net
"""

def main():
    compose_content = "version: '3.8'\nservices:\n"
    for s in services:
        compose_content += generate_service_block(s)
    compose_content += """
networks:
  anuset_net:
    driver: bridge
"""

    output_path = "../docker-compose.yml"  # Ajusta si tu estructura es distinta
    with open(output_path, "w") as f:
        f.write(compose_content)
    print(f"docker-compose.yml generado correctamente en {output_path}")

if __name__ == "__main__":
    main()

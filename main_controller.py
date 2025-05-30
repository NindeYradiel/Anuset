import subprocess
import os
import docker

# Rutas y scripts por servicio
SERVICES = {
    "codellama": {
        "model_path": "/home/saze/Anuset89-Vault/data/codellama/models/CodeLlama-7b-Instruct-hf",
        "download_script": "/home/saze/Anuset89-Vault/scripts/download_model_codellama.sh"
    },
    "xtts-es": {
        "model_path": "/home/saze/Anuset89-Vault/data/xtts-es/models",
        "download_script": "/home/saze/Anuset89-Vault/scripts/download_model_xtts-es.sh"
    },
    "stable-diffusion": {
        "model_path": "/home/saze/Anuset89-Vault/data/stable-diffusion/models/Stable-diffusion",
        "download_script": "/home/saze/Anuset89-Vault/scripts/download_model_stable-diffusion.sh"
    },
    "animatediff": {
        "model_path": "/home/saze/Anuset89-Vault/data/animatediff/models",
        "download_script": "/home/saze/Anuset89-Vault/scripts/download_model_animatediff.sh"
    },
    "stableaudio": {
        "model_path": "/home/saze/Anuset89-Vault/data/stableaudio/models",
        "download_script": "/home/saze/Anuset89-Vault/scripts/download_model_stableaudio.sh"
    },
    "memgpt": {
        "model_path": "/home/saze/Anuset89-Vault/data/memgpt/models",
        "download_script": "/home/saze/Anuset89-Vault/scripts/download_model_memgpt.sh"
    }
}

def check_and_download_models():
    for name, config in SERVICES.items():
        print(f"🐱 Verificando modelo para {name}...")
        if not os.path.exists(config["model_path"]):
            print(f"🧠 Modelo para {name} no encontrado. Ejecutando descarga...")
            subprocess.run([config["download_script"]], check=True)
        else:
            print(f"✅ Modelo de {name} ya presente.")

def check_container_health():
    client = docker.from_env()
    print("🔎 Revisando estado de contenedores...")
    for name in SERVICES.keys():
        try:
            container = client.containers.get(name)
            status = container.attrs['State']['Status']
            print(f"🐾 Contenedor {name}: {status}")
        except docker.errors.NotFound:
            print(f"❌ Contenedor {name} no encontrado.")
        except Exception as e:
            print(f"⚠️  Error al verificar {name}: {str(e)}")

def run_main():
    print("🔍 Ejecutando diagnóstico general de Anuset89 🐱✨")
    check_and_download_models()
    check_container_health()

if __name__ == "__main__":
    run_main()
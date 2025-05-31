import subprocess
import os
import sys
import time
from pathlib import Path
import json
import threading
import argparse
import requests
from typing import List

def run(cmd):
    print(f"🌀 Ejecutando: {' '.join(cmd)}")
    subprocess.run(cmd, check=True)

if "--start" in sys.argv:
    print("🚀 Levantando todos los servicios de Anuset-FINAL...")
    run(["docker", "compose", "up", "-d"])
    print("✅ Todos los contenedores iniciados.")

elif "--stop" in sys.argv:
    print("🛑 Deteniendo todo Anuset-FINAL y creando el vacío absoluto...")
    run(["docker", "compose", "down", "--volumes", "--remove-orphans"])
    run(["docker", "system", "prune", "-af", "--volumes"])
    print("☠️ Contenedores, redes, imágenes y volúmenes: PURGADOS.")
    print("🧼 Vacío absoluto alcanzado.")

# =======================
# Configuración general
# =======================

BASE_DIR = Path(__file__).resolve().parent.parent
SCRIPTS_DIR = BASE_DIR / "scripts"
CONFIG_FILE = BASE_DIR / "config.json"

# Servicios del proyecto
SERVICES = [
    "animatediff", "audio", "codellama", "codigo", "comfyui", "estilo",
    "imagen", "interaccion", "memgpt", "memoria", "musica", "musicgen",
    "stableaudio", "video", "voz", "xtts-es", "stable-diffusion"
]

# =======================
# Cargar configuración
# =======================

def load_config() -> dict:
    default_config = {"min_disk_gb": 50}
    if CONFIG_FILE.exists():
        try:
            with open(CONFIG_FILE, 'r') as f:
                return json.load(f)
        except json.JSONDecodeError:
            print("❌ Error: config.json inválido. Usando configuración por defecto.")
    return default_config

config = load_config()
MIN_DISK_GB = config.get("min_disk_gb", 50)

# =======================
# Verificar espacio libre
# =======================

def has_enough_disk_space(min_gb: int = MIN_DISK_GB) -> bool:
    model_dirs = [BASE_DIR / "data" / svc / "models" for svc in SERVICES]
    if all(d.exists() and any(d.iterdir()) for d in model_dirs):
        min_gb = 10
    statvfs = os.statvfs(str(BASE_DIR))
    free_gb = (statvfs.f_frsize * statvfs.f_bavail) / (1024 ** 3)
    if free_gb < min_gb:
        print(f"❌ Espacio insuficiente: {free_gb:.2f}GB libres, se requieren {min_gb}GB.")
        return False
    print(f"DEBUG: Espacio disponible: {free_gb:.2f}GB")
    return True

# =======================
# Verificar e iniciar Tor
# =======================

def check_tor_config(dry_run: bool = False) -> None:
    print("\n🔒 Verificando e iniciando configuración de Tor...")
    if dry_run:
        print("🧪 Simulando verificación de Tor (dry-run)")
        return

    torrc = BASE_DIR / "tor" / "torrc"
    if not torrc.exists():
        print("❌ Error: torrc no encontrado en tor/torrc")
        sys.exit(1)

    print(f"DEBUG: Usando torrc en {torrc}")
    
    try:
        result = subprocess.run(["tor", "--version"], capture_output=True, text=True, check=True)
        print(f"DEBUG: Tor versión {result.stdout.strip()}")
    except (subprocess.CalledProcessError, FileNotFoundError):
        print("❌ Error: Tor no está instalado o no se encuentra en el PATH")
        sys.exit(1)

    tor_process = None
    try:
        tor_process = subprocess.Popen(
            ["tor", "-f", str(torrc)],
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            text=True
        )
        for _ in range(30):
            if tor_process.poll() is not None:
                print(f"❌ Error: Tor falló al iniciar: {tor_process.stderr.read()}")
                sys.exit(1)
            try:
                proxies = {'http': 'socks5h://localhost:9050', 'https': 'socks5h://localhost:9050'}
                response = requests.get("https://check.torproject.org/api/ip", proxies=proxies, timeout=5)
                if response.json().get("IsTor"):
                    print("✅ Conexión Tor activa")
                    return
            except requests.RequestException:
                pass
            time.sleep(1)
        print("❌ Error: Tor no se conectó en 30 segundos")
        sys.exit(1)
    except Exception as e:
        print(f"❌ Error iniciando Tor: {e}")
        if tor_process:
            tor_process.terminate()
        sys.exit(1)

# =======================
# Notificaciones
# =======================

def notify(msg: str) -> None:
    try:
        subprocess.run(["notify-send", "Anuset-FINAL", msg], check=False, timeout=5)
    except (subprocess.SubprocessError, FileNotFoundError):
        print(f"DEBUG: Notificación fallida: {msg}")

# =======================
# Spinner
# =======================

def show_spinner(message: str, done_event: threading.Event) -> None:
    spinner = ['|', '/', '-', '\\']
    i = 0
    while not done_event.is_set():
        print(f"\r{message} {spinner[i % 4]}", end="", flush=True)
        i += 1
        time.sleep(0.1)
    print(f"\r{message} ✅")

# =======================
# Ejecutar scripts
# =======================

def run_script(script: Path, args: List[str] = None, dry_run: bool = False) -> None:
    args = args or []
    cmd = ["bash", str(script)] + args if script.suffix == ".sh" else [sys.executable, str(script)] + args
    print(f"\n🚀 Ejecutando: {' '.join(cmd)}")
    if dry_run:
        print("🧪 Simulando ejecución (dry-run)")
        return
    done_event = threading.Event()
    spinner_thread = threading.Thread(target=show_spinner, args=(f"Ejecutando {script.name}", done_event))
    spinner_thread.start()
    try:
        result = subprocess.run(cmd, check=True, text=True, capture_output=True)
        done_event.set()
        spinner_thread.join()
        print(f"DEBUG: Salida: {result.stdout}")
        notify(f"Script {script.name} completado")
    except subprocess.CalledProcessError as e:
        done_event.set()
        spinner_thread.join()
        print(f"❌ Error ejecutando {script.name}: {e.stderr}")
        notify(f"Error en {script.name}")
        sys.exit(1)

# =======================
# Verificar contenedores
# =======================

def check_containers(dry_run: bool = False) -> None:
    print("\n🐳 Verificando contenedores...")
    if dry_run:
        print("🧪 Simulando verificación de contenedores")
        return
    for svc in SERVICES:
        cmd = ["docker", "ps", "-q", "-f", f"name=an_{svc}"]
        try:
            result = subprocess.run(cmd, check=True, text=True, capture_output=True)
            if result.stdout.strip():
                print(f"✅ Contenedor para {svc} está corriendo")
            else:
                print(f"⚠️ Contenedor para {svc} no está corriendo")
        except subprocess.CalledProcessError as e:
            print(f"❌ Error verificando contenedor {svc}: {e.stderr}")

# =======================
# Main
# =======================

def run_main(dry_run: bool = False) -> None:
    print("🔧 Iniciando controlador principal Anuset-FINAL...")
    print(f"DEBUG: Directorio base: {BASE_DIR}")

    if not has_enough_disk_space():
        notify("Espacio en disco insuficiente")
        sys.exit(1)

    check_tor_config(dry_run)

    scripts = [
        SCRIPTS_DIR / "download_models.sh"
    ]

    for script in scripts:
        if script.exists():
            run_script(script, dry_run=dry_run)
        else:
            print(f"⚠️ Script {script.name} no encontrado")

    check_containers(dry_run)

    print("\n✅ Controlador principal finalizado")
    notify("Anuset-FINAL iniciado correctamente")
def iniciar_contenedores():
    print("\n🐳 Iniciando todos los contenedores con Docker Compose...")
    try:
        resultado = subprocess.run(["docker", "compose", "up", "-d"], check=True, capture_output=True, text=True)
        print("✅ Contenedores iniciados correctamente.")
        print(resultado.stdout)
    except subprocess.CalledProcessError as e:
        print("❌ Error al iniciar los contenedores:")
        print(e.stderr)
if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Controlador principal de Anuset-FINAL.")
    parser.add_argument("--start", action="store_true", help="Inicia todos los contenedores.")
    parser.add_argument("--dry-run", action="store_true", help="Simula todas las acciones sin ejecutar.")
    args = parser.parse_args()

    run_main(dry_run=args.dry_run)

    if args.start:
        iniciar_contenedores()

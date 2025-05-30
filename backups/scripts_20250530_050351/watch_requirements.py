#!/usr/bin/env python3
import os
import subprocess
import sys
import threading

SERVICES_DIR = "services"
COLOR_RESET = "\033[0m"
COLOR_GREEN = "\033[32m"
COLOR_YELLOW = "\033[33m"
COLOR_RED = "\033[31m"
COLOR_BLUE = "\033[34m"

def color(msg, c): return f"{c}{msg}{COLOR_RESET}"

def watch_service(service_path, service_name):
    try:
        subprocess.run([
            "inotifywait", "-m", "-e", "close_write", "--format", "%w%f", os.path.join(service_path, "app.py")
        ], stdout=subprocess.PIPE, stderr=subprocess.DEVNULL, text=True)
    except KeyboardInterrupt:
        print(color(f"🔴 Watcher detenido: {service_name}", COLOR_RED))

def start_watcher(service_path, service_name):
    def watcher():
        path = os.path.join(service_path, "app.py")
        proc = subprocess.Popen(
            ["inotifywait", "-m", "-e", "close_write", "--format", "%w%f", path],
            stdout=subprocess.PIPE,
            stderr=subprocess.DEVNULL,
            text=True
        )
        for line in proc.stdout:
            print(color(f"\n👁️ Cambio detectado en {service_name}", COLOR_BLUE))
            result = subprocess.run(
                ["make", "limpiar-requirements-servicio", f"SERVICE={service_name}"],
                capture_output=True,
                text=True
            )
            for l in result.stdout.splitlines():
                if "✅" in l:
                    print(color(l, COLOR_GREEN))
                elif "🟡" in l:
                    print(color(l, COLOR_YELLOW))
                elif "🔴" in l:
                    print(color(l, COLOR_RED))
                else:
                    print(color(l, COLOR_BLUE))

    print(color(f"👁️ Activado: {service_name}", COLOR_BLUE))
    threading.Thread(target=watcher, daemon=True).start()

def main():
    if not os.path.isdir(SERVICES_DIR):
        print(color(f"❌ No se encontró el directorio '{SERVICES_DIR}'", COLOR_RED))
        sys.exit(1)

    for service_name in sorted(os.listdir(SERVICES_DIR)):
        service_path = os.path.join(SERVICES_DIR, service_name)
        if os.path.isfile(os.path.join(service_path, "app.py")):
            start_watcher(service_path, service_name)

    print(color("\n👁️ Vigilando todos los app.py. Presioná Ctrl+C para salir...\n", COLOR_BLUE))
    try:
        while True:
            pass
    except KeyboardInterrupt:
        print(color("\n🔴 Vigilancia finalizada.", COLOR_RED))

if __name__ == "__main__":
    main()

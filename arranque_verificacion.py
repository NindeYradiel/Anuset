#!/usr/bin/env python3
# arranque_verificacion.py
# 🛠️ Verifica e inicia contenedores críticos de Anuset89

import subprocess
import time

# Lista de contenedores críticos
containers = [
    "frontend",
    "backend",
    "openwebui",
    "ollama"
]

def run(cmd):
    """Ejecuta un comando en shell y devuelve salida, error y código."""
    result = subprocess.run(cmd, shell=True, capture_output=True, text=True)
    return result.stdout.strip(), result.stderr.strip(), result.returncode

def is_running(container):
    out, _, _ = run(f"docker inspect -f '{{{{.State.Running}}}}' {container}")
    return out == "true"

def exists(container):
    _, _, code = run(f"docker inspect {container}")
    return code == 0

def start_container(container):
    print(f"🟡 Iniciando: {container}...")
    out, err, code = run(f"docker start {container}")
    if code == 0:
        print(f"✅ Contenedor '{container}' iniciado.")
        time.sleep(2)
    else:
        print(f"❌ Error al iniciar '{container}': {err}")

def check_nginx(container):
    out, err, code = run(f"docker exec {container} nginx -t")
    if code == 0:
        print(f"✅ Nginx OK en '{container}'")
        run(f"docker exec {container} nginx -s reload")
        print(f"🔄 Nginx recargado en '{container}'")
    else:
        print(f"⚠️  Nginx falló en '{container}': {err}\n{out}")

def main():
    for name in containers:
        print(f"\n🔍 Verificando: {name}")
        if not exists(name):
            print(f"❌ Contenedor '{name}' no existe.")
            continue
        if is_running(name):
            print(f"✅ '{name}' ya está corriendo.")
        else:
            start_container(name)
        if name == "frontend":
            check_nginx(name)

if __name__ == "__main__":
    main()

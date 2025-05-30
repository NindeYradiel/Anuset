#!/usr/bin/env python3

import os
import re

SERVICES_DIR = "services"

# Mapeo simple de import => paquete pip
IMPORT_TO_PIP = {
    "fastapi": "fastapi",
    "requests": "requests",
    "torch": "torch",
    "torchaudio": "torchaudio",
    "transformers": "transformers",
    "diffusers": "diffusers",
    "safetensors": "safetensors",
    "accelerate": "accelerate",
    "langchain": "langchain",
    "openai": "openai",
    "pydantic": "pydantic",
    "tiktoken": "tiktoken",
    "sentencepiece": "sentencepiece",
    "sqlite_utils": "sqlite-utils",
    "tinydb": "tinydb",
    "python_dotenv": "python-dotenv",
    "numpy": "numpy",
    "opencv": "opencv-python",
    "pyyaml": "pyyaml",
}

def detect_dependencies(app_py_path):
    used = set()
    if not os.path.exists(app_py_path):
        return used
    with open(app_py_path, 'r') as f:
        content = f.read()
    for key, pkg in IMPORT_TO_PIP.items():
        if re.search(rf"import {key}|from {key}", content):
            used.add(pkg)
    return used

def update_requirements(service):
    app_path = os.path.join(SERVICES_DIR, service, "app.py")
    req_path = os.path.join(SERVICES_DIR, service, "requirements.txt")
    used = detect_dependencies(app_path)
    if not used:
        print(f"🟡 {service}: No se detectaron dependencias en app.py")
        return
    with open(req_path, 'w') as f:
        for dep in sorted(used):
            f.write(dep + "\n")
    print(f"✅ {service}: requirements.txt actualizado ({len(used)} dependencias)")

def main():
    for service in os.listdir(SERVICES_DIR):
        path = os.path.join(SERVICES_DIR, service)
        if os.path.isdir(path):
            update_requirements(service)

if __name__ == "__main__":
    main()

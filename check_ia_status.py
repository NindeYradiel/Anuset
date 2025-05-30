# check_ia_status.py
import os
import json
import requests
from pathlib import Path
from datetime import datetime

SERVICES = {
    "memgpt": "http://localhost:5000/",
    "xtts-es": "http://localhost:5002/",
    "stableaudio": "http://localhost:6001/",
    "animatediff": "http://localhost:6010/",
    "comfyui": "http://localhost:8188/",
    "codellama": "http://localhost:5004/",
    "musicgen": "http://localhost:6000/",
    "backend": "http://localhost:8000/",
    "frontend": "http://localhost:3000/",
    "ollama": "http://localhost:11434/api/tags",
    "openwebui": "http://localhost:8888/",
}

def check_status(url):
    try:
        r = requests.get(url, timeout=2)
        if r.status_code == 200:
            return "ok"
        elif r.status_code == 401:
            return "unauthorized"
        else:
            return f"error {r.status_code}"
    except Exception:
        return "down"

def main():
    status = {}
    for name, url in SERVICES.items():
        if name == "ollama":
            try:
                resp = requests.get(url, timeout=3).json()
                models = {model["name"]: "ready" for model in resp.get("models", [])}
                status["ollama"] = models if models else {"none": "no models"}
            except Exception:
                status["ollama"] = {"status": "down"}
        else:
            status[name] = check_status(url)

    # Asegurar carpeta `data/`
    Path("data").mkdir(parents=True, exist_ok=True)

    # Guardar JSON con timestamp
    status["_timestamp"] = datetime.now().isoformat()
    with open("data/status.json", "w") as f:
        json.dump(status, f, indent=2)

    print("✅ Estado actualizado en data/status.json")

if __name__ == "__main__":
    main()

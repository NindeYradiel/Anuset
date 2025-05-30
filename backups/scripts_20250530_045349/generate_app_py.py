#!/usr/bin/env python3
import os
from pathlib import Path

EXCLUIR = {"frontend", "backend", "mem0", "openmemory"}
BASE = Path("~/Anuset/services").expanduser()

APP_PY = '''from fastapi import FastAPI, Request
from fastapi.responses import JSONResponse

app = FastAPI()

@app.get("/")
def status():
    return {"status": "Servicio {name} activo"}

@app.post("/v1/chat/completions")
def chat_completions(request: Request):
    return JSONResponse({
        "id": "test-response",
        "object": "chat.completion",
        "created": 0,
        "model": "{name}",
        "choices": [
            {"index": 0, "message": {"role": "assistant", "content": "Respuesta generada por {name}"}, "finish_reason": "stop"}
        ],
        "usage": {"prompt_tokens": 5, "completion_tokens": 5, "total_tokens": 10}
    })
'''

def crear_app(servicio):
    carpeta = BASE / servicio
    app_py = carpeta / "app.py"
    if not app_py.exists():
        app_py.write_text(APP_PY.format(name=servicio))
        print(f"✅ app.py creado en {servicio}")

if __name__ == "__main__":
    print("🧠 Generando app.py para servicios IA...")
    for svc in os.listdir(BASE):
        if svc in EXCLUIR:
            continue
        crear_app(svc)
    print("\n🌟 app.py generados correctamente.")

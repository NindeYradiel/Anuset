from fastapi import FastAPI, HTTPException, Request
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
import json
import os

# Inicializamos la app
app = FastAPI()

# Habilitamos CORS para que React (puerto 5173) pueda hablar con este backend
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Podés limitar esto a ["http://localhost:5173"]
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Modelo de datos que esperamos recibir desde el frontend
class Message(BaseModel):
    message: str

# Ruta a tu archivo de personalidad personalizado
PERSONALIDAD_PATH = "prompt_personalidad.txt"

# Cargar el prompt de personalidad si existe
def cargar_personalidad():
    if os.path.exists(PERSONALIDAD_PATH):
        with open(PERSONALIDAD_PATH, "r", encoding="utf-8") as f:
            return f.read()
    return "[Sin personalidad cargada]"

# Endpoint principal para interactuar con AnuSet89
@app.post("/api/router")
async def procesar_mensaje(msg: Message):
    try:
        personalidad = cargar_personalidad()
        respuesta = {
            "respuesta": f"AnuSet89 piensa sobre: '{msg.message}'\n\nCon su esencia:",
            "personalidad": personalidad
        }
        return respuesta
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

# Endpoint para saber si el servidor corre correctamente
@app.get("/api/status")
def estado():
    return {"status": "activo", "ruta_personalidad": PERSONALIDAD_PATH}


# backend/main.py

from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
import httpx
import os

# Cargar rutas si existen
try:
    from routes import rituales, despertar
except ImportError:
    print("⚠️ Módulos de rutas no encontrados. Continúa sin rutas adicionales.")
    rituales = None
    despertar = None

app = FastAPI(title="Anuset-FINAL Backend")

# CORS para permitir llamadas del frontend en otro puerto
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Puedes restringir esto si quieres
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Incluir routers si existen
if rituales:
    app.include_router(rituales.router)
if despertar:
    app.include_router(despertar.router)

# Endpoint de test para conexión con mem0
MEM0_URL = os.environ.get("MEM0_URL", "http://mem0:5000")

@app.get("/mem0/status")
async def estado_mem0():
    try:
        async with httpx.AsyncClient() as client:
            response = await client.get(f"{MEM0_URL}/ping")
        return {"estado": "ok", "respuesta": response.json()}
    except Exception as e:
        raise HTTPException(status_code=503, detail=f"No se pudo conectar con mem0: {e}")

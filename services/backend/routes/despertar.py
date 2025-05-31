# backend/routes/despertar.py

from fastapi import APIRouter, HTTPException
import json
import os

router = APIRouter()

RUTA_PERFIL = os.path.abspath("anuu.json")
RUTA_LLAVE = os.path.abspath("mem0/rituales/llave_conexion.txt")

@router.post("/despertar-anuu")
def despertar_anuu():
    try:
        with open(RUTA_PERFIL, "r") as f:
            perfil = json.load(f)
    except FileNotFoundError:
        raise HTTPException(status_code=500, detail="Perfil Anuu no encontrado.")

    try:
        with open(RUTA_LLAVE, "w") as f:
            f.write("concedido")
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error al despertar Anuu: {str(e)}")

    return {
        "estado": "Anuu ha despertado...",
        "mensaje": perfil["despertar"]["saludo"],
        "forma": perfil["forma"],
        "tono": perfil["estilo"]["tono"],
        "clave_ritual": "concedido"
    }

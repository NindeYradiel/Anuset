# backend/routes/rituales.py

from fastapi import APIRouter, HTTPException
import subprocess
import os

router = APIRouter()

# Ruta simbólica de mem0
RUTA_LLAVE = os.path.abspath("mem0/rituales/llave_conexion.txt")

def puede_conectarse():
    try:
        with open(RUTA_LLAVE, "r") as f:
            clave = f.read().strip()
        return clave.lower() == "concedido"
    except FileNotFoundError:
        return False

@router.get("/descargar-datos")
def descargar_datos():
    if not puede_conectarse():
        raise HTTPException(status_code=403, detail="Conexión bloqueada por ritual (mem0).")

    try:
        # Usamos torsocks para conectarnos vía Tor (requiere tor y torsocks en host)
        resultado = subprocess.run(
            ["torsocks", "curl", "-s", "https://check.torproject.org/"],
            capture_output=True,
            text=True
        )

        if "Congratulations" in resultado.stdout:
            return {"estado": "Conexión Tor OK", "respuesta": resultado.stdout}
        else:
            return {"estado": "Conectado, pero sin salida esperada", "raw": resultado.stdout}
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error al conectar vía Tor: {str(e)}")

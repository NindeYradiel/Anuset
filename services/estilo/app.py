from fastapi import FastAPI
import requests

app = FastAPI()

@app.get("/ping")
def ping():
    return {"message": "Servicio simbólico estilo activo"}

@app.post("/usar")
def usar(payload: dict):
    response = requests.post("http://comfyui:8000/usar", json=payload)
    return response.json()

from fastapi import FastAPI
import requests

app = FastAPI()

@app.get("/ping")
def ping():
    return {"message": "Servicio simbólico video activo"}

@app.post("/usar")
def usar(payload: dict):
    response = requests.post("http://animatediff:8000/usar", json=payload)
    return response.json()

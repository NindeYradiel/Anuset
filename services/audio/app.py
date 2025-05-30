from fastapi import FastAPI
import requests

app = FastAPI()

@app.get("/ping")
def ping():
    return {"message": "Servicio simbólico audio activo"}

@app.post("/usar")
def usar(payload: dict):
    response = requests.post("http://stableaudio:8000/usar", json=payload)
    return response.json()

from fastapi import FastAPI

app = FastAPI()

@app.get("/")
def status():
    return {"status": "Servicio stableaudio activo"}

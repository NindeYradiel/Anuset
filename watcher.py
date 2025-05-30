# watcher.py
import os, json, time

DATA_DIR = "./data"
SEEN = set()

while True:
    for servicio in os.listdir(DATA_DIR):
        ruta = os.path.join(DATA_DIR, servicio, "instruccion.json")
        if os.path.exists(ruta) and ruta not in SEEN:
            with open(ruta) as f:
                instruccion = json.load(f)
                print(f"🔮 Detected ritual for {servicio}:\n{instruccion['prompt']}")
                # Aquí: redirigir a WebUI o lanzar contenedor si se requiere
            SEEN.add(ruta)
    time.sleep(2)


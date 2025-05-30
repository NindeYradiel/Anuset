from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from typing import List
import uuid

app = FastAPI(
    title="Servicio API",
    description="API avanzada para gestionar recursos.",
    version="1.0.0"
)

class Item(BaseModel):
    id: str
    name: str
    description: str

items_db = []

@app.get("/items", response_model=List[Item])
async def get_items():
    return items_db

@app.post("/items", response_model=Item, status_code=201)
async def create_item(item: Item):
    item.id = str(uuid.uuid4())
    items_db.append(item)
    return item

@app.get("/items/{item_id}", response_model=Item)
async def get_item(item_id: str):
    for item in items_db:
        if item.id == item_id:
            return item
    raise HTTPException(status_code=404, detail="Item no encontrado")

@app.put("/items/{item_id}", response_model=Item)
async def update_item(item_id: str, updated_item: Item):
    for index, item in enumerate(items_db):
        if item.id == item_id:
            items_db[index] = updated_item
            return updated_item
    raise HTTPException(status_code=404, detail="Item no encontrado")

@app.delete("/items/{item_id}", status_code=204)
async def delete_item(item_id: str):
    for index, item in enumerate(items_db):
        if item.id == item_id:
            del items_db[index]
            return
    raise HTTPException(status_code=404, detail="Item no encontrado")

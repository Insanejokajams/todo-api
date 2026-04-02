from fastapi import FastAPI, HTTPException
from pydantic import BaseModel, Field
from typing import List
import uuid

app = FastAPI()

# Modelo de tarea con validación:
# - id generado automáticamente con uuid
# - title obligatorio y mínimo 3 caracteres
# - completed por defecto en False
class Task(BaseModel):
    id: str = Field(default_factory=lambda: str(uuid.uuid4()))
    title: str = Field(..., min_length=3)
    completed: bool = False

tasks: List[Task] = []

# POST /tasks → Crear nueva tarea
# - Devuelve 201 Created si todo está bien
# - Devuelve 422 Unprocessable Entity si falta 'title' o no cumple validación
@app.post("/tasks", response_model=Task, status_code=201)
def create_task(task: Task):
    tasks.append(task)
    return task

# GET /tasks → Listar todas las tareas
# - Devuelve 200 OK siempre
@app.get("/tasks", response_model=List[Task])
def list_tasks():
    return tasks

# GET /tasks/{id} → Obtener detalle de una tarea
# - Devuelve 200 OK si existe
# - Devuelve 404 Not Found si no existe
@app.get("/tasks/{task_id}", response_model=Task)
def get_task(task_id: str):
    for task in tasks:
        if task.id == task_id:
            return task
    raise HTTPException(status_code=404, detail="Task not found")

# DELETE /tasks/{id} → Eliminar una tarea
# - Devuelve 200 OK si se elimina
# - Devuelve 404 Not Found si no existe
@app.delete("/tasks/{task_id}", status_code=200)
def delete_task(task_id: str):
    global tasks
    for task in tasks:
        if task.id == task_id:
            tasks = [t for t in tasks if t.id != task_id]
            return {"message": "Task deleted"}
    raise HTTPException(status_code=404, detail="Task not found")

# (Opcional) PUT /tasks/{id} → Actualizar título o marcar como completada
# - Devuelve 200 OK si se actualiza
# - Devuelve 404 Not Found si no existe
@app.put("/tasks/{task_id}", response_model=Task)
def update_task(task_id: str, updated_task: Task):
    for i, task in enumerate(tasks):
        if task.id == task_id:
            tasks[i].title = updated_task.title
            tasks[i].completed = updated_task.completed
            return tasks[i]
    raise HTTPException(status_code=404, detail="Task not found")
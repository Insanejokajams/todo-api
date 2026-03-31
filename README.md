# Todo API

Una aplicación básica de FastAPI para gestionar tareas (To-Do), desplegable en AWS EKS.

## Instalación local

git clone https://github.com/Insanejokajams/todo-api.git
cd todo-api/app
pip install -r requirements.txt
uvicorn app.main:app --reload

La aplicación estará disponible en http://127.0.0.1:8000.

## Endpoints

- GET /tasks → Lista todas las tareas
- POST /tasks → Crea una nueva tarea
- GET /tasks/{id} → Obtiene una tarea por ID
- DELETE /tasks/{id} → Elimina una tarea

Ejemplo de creación de tarea:

Invoke-RestMethod -Uri "http://127.0.0.1:8000/tasks" -Method Post -ContentType "application/json" -Body '{"title":"Comprar Pan Dulce","completed":false}'

## Despliegue en EKS

1. Construir y subir la imagen a Docker Hub:
   docker build -t insanejokajams/todo-api:latest .
   docker push insanejokajams/todo-api:latest

2. Aplicar el manifiesto de Kubernetes:
   kubectl apply -f infra/deployment.yaml
   kubectl rollout status deployment/todo-api-deployment

3. Probar el LoadBalancer:
   Invoke-RestMethod -Uri "http://<LoadBalancer>/tasks" -Method Get

## Licencia

Este proyecto es de uso educativo.

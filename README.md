# Todo API

Una aplicación básica de FastAPI para gestionar tareas (To-Do), desplegable en AWS EKS.

## Instalación local

git clone https://github.com/Insanejokajams/todo-api.git <br>
pip install -r requirements.txt <br>
uvicorn app.main:app --reload <br>

La aplicación estará disponible en http://127.0.0.1:8000.

## Endpoints

- GET /tasks → Lista todas las tareas
- POST /tasks → Crea una nueva tarea
- GET /tasks/{id} → Obtiene una tarea por ID
- DELETE /tasks/{id} → Elimina una tarea

Ejemplo de creación de tarea:

Invoke-RestMethod -Uri "http://127.0.0.1:8000/tasks" -Method Post -ContentType "application/json" -Body '{"title":"Comprar Pan Dulce","completed":false}'

## Despliegue en EKS

1. Construir y subir la imagen a Docker Hub: <br>
   docker build -t insanejokajams/todo-api:latest . <br>
   docker push insanejokajams/todo-api:latest <br>

2. Aplicar el manifiesto de Kubernetes: <br>
   kubectl apply -f infra/deployment.yaml <br>
   kubectl rollout status deployment/todo-api-deployment <br>

3. Probar el LoadBalancer:
   Invoke-RestMethod -Uri "http://<LoadBalancer>/tasks" -Method Get <br>

## Licencia

Este proyecto es de uso educativo.
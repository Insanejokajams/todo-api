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

## Costos Estimados

| Configuración                  | Control Plane | Compute (EC2 Spot) | EBS (20 GB/nodo) | CloudWatch | Total mensual aprox. |
|--------------------------------|---------------|--------------------|------------------|------------|----------------------|
| **Small (t3.micro, 2 nodos, 24/7)** | $73           | $7–$9              | $4               | $10–$20    | **$94–$106**         |
| **Small (t3.micro, 2 nodos, apagando fuera de horario laboral)** | $73           | $2–$3              | $4               | $10–$20    | **$89–$100**         |
| **Medium (t3.medium, 2 nodos, 24/7)** | $73           | $20–$30            | $4               | $10–$20    | **$107–$127**        |
| **Medium (t3.medium, 2 nodos, apagando fuera de horario laboral)** | $73           | $6–$9              | $4               | $10–$20    | **$93–$106**         |

---

## Licencia

Este proyecto es de uso educativo.
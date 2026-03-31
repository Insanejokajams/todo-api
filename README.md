Proyecto: Mi To-Do list API online
Un backend ligero en FastAPI desplegado en AWS EKS, empaquetado en Docker, y monitoreado con CloudWatch.
Facilita la organización personal o de equipo al centralizar tareas en un servicio accesible vía API.

Flujo rápido de pruebas
Validar aplicación local (FastAPI)

uvicorn app.main:app --reload
Acceder a: http://127.0.0.1:8000/docs

Docker local

docker build -t todo-api .
docker run -p 8000:80 todo-api
Acceder a: http://127.0.0.1:8000/docs

Imagen publicada: insanejokajams/todo-api

docker pull insanejokajams/todo-api:latest
docker run -p 8000:80 insanejokajams/todo-api:latest


Infraestructura AWS (Terraform)

terraform init
terraform apply
aws eks update-kubeconfig --region us-east-1 --name todo-api-cluster
Despliegue en Kubernetes

kubectl apply -f deployment.yaml
kubectl apply -f service.yaml
kubectl get svc todo-api-service

Acceder a:
http://<LB-DNS>.us-east-1.elb.amazonaws.com/docs
Pruebas rápidas con PowerShell (Invoke-RestMethod)

Crear tarea:
Invoke-RestMethod -Uri "http://<LB-DNS>/tasks" -Method Post -ContentType "application/json" -Body '{"title":"Primera tarea","completed":false}'

Listar tareas:
Invoke-RestMethod -Uri "http://<LB-DNS>/tasks" -Method Get

Obtener tarea:
Invoke-RestMethod -Uri "http://<LB-DNS>/tasks/(numero de task)" -Method Get

Eliminar tarea:
Invoke-RestMethod -Uri "http://<LB-DNS>/tasks/(numero de task)" -Method Delete

Referencias
/app → desarrollo y empaquetado en Docker.
/infra → despliegue con Terraform y EKS, observabilidad en cloudwatch
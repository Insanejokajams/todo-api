Set-Content -Path README.md -Value @'
# Infraestructura Todo API

## 1. Configuración de acceso a AWS
- Crear un usuario IAM con permisos de administrador desde la consola de AWS.
- Generar sus llaves de acceso (Access Key y Secret Key).
- Configurar el perfil en tu entorno local:

aws configure --profile todo-api-user
# Access Key ID: <tu access key>
# Secret Access Key: <tu secret key>
# Región: us-east-1
# Output: json

Validar el perfil:
aws configure list --profile todo-api-user
aws sts get-caller-identity --profile todo-api-user

Asegurar que Terraform use este perfil:
setx AWS_PROFILE todo-api-user

## 2. Terraform
Archivos principales:
- main.tf → VPC, subnets, cluster EKS pequeño (2 nodos t3.micro), addon de CloudWatch para métricas, bucket S3 opcional.
- outputs.tf → expone nombre y endpoint del cluster.

Pasos:
terraform init
terraform apply

Configurar kubectl:
aws eks update-kubeconfig --region us-east-1 --name todo-api-cluster

## 3. Kubernetes
Manifiestos:
- deployment.yaml → despliega el contenedor insanejokajams/todo-api:latest
- service.yaml → crea un LoadBalancer

Aplicación:
kubectl apply -f deployment.yaml
kubectl apply -f service.yaml

Obtener ruta pública:
kubectl get svc todo-api-service

Ejemplo:
http://<LB-DNS>.us-east-1.elb.amazonaws.com/docs
http://<LB-DNS>.us-east-1.elb.amazonaws.com/openapi.json

## 4. Pruebas de la API
Invoke-RestMethod -Uri "http://<LB-DNS>/tasks" -Method Post -ContentType "application/json" -Body '{"title":"Primera tarea","completed":false}'
Invoke-RestMethod -Uri "http://<LB-DNS>/tasks" -Method Get
Invoke-RestMethod -Uri "http://<LB-DNS>/tasks/(id)" -Method Get
Invoke-RestMethod -Uri "http://<LB-DNS>/tasks/(id)" -Method Delete

## 5. Observabilidad
Logs y métricas disponibles en CloudWatch Container Insights:
Ruta: /aws/eks/todo-api-cluster/cluster
'@

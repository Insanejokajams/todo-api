# Infraestructura Todo API

## 1. Configuración de acceso a AWS
- Crear un usuario IAM con permisos de administrador desde la consola de AWS.

- Generar sus llaves de acceso (Access Key y Secret Key).

- Configurar el perfil en tu entorno local:

aws configure --profile todo-api-user

- Access Key ID: <tu access key>
- Secret Access Key: <tu secret key>
- Región: us-east-1
- Output: json

Validar el perfil:
-aws configure list --profile todo-api-user <br>
-aws sts get-caller-identity --profile todo-api-user <br>
Asegurar que Terraform use este perfil: <br>
<br>
-setx AWS_PROFILE todo-api-user

## 2. Terraform
Archivos principales:<br>
- main.tf → VPC, subnets, cluster EKS pequeño (2 nodos t3.micro), addon de CloudWatch para métricas, bucket S3 opcional.<br>
- outputs.tf → expone nombre y endpoint del cluster.<br>
<br>
Pasos:<br>
-terraform init<br>
-terraform apply
<br>
Configurar kubectl:<br>
-aws eks update-kubeconfig --region us-east-1 --name todo-api-cluster
<br>
## 3. Kubernetes<br>
Manifiestos:<br>
- deployment.yaml → despliega el contenedor insanejokajams/todo-api:latest<br>
- service.yaml → crea un LoadBalancer<br>
<br>
Aplicación:<br>
-kubectl apply -f deployment.yaml<br>
-kubectl apply -f service.yaml<br>
<br>
Obtener ruta pública:<br>
-kubectl get svc todo-api-service<br>
<br>
Ejemplo:<br>
-http://<LB-DNS>.us-east-1.elb.amazonaws.com/docs<br>
-http://<LB-DNS>.us-east-1.elb.amazonaws.com/openapi.json<br>

## 4. Pruebas de la API
-Invoke-RestMethod -Uri "http://<LB-DNS>/tasks" -Method Post -ContentType "application/json" -Body '{"title":"Primera tarea","completed":false}'<br>
-Invoke-RestMethod -Uri "http://<LB-DNS>/tasks" -Method Get<br>
-Invoke-RestMethod -Uri "http://<LB-DNS>/tasks/(id)" -Method Get<br>
-Invoke-RestMethod -Uri "http://<LB-DNS>/tasks/(id)" -Method Delete<br>

## 5. Observabilidad
Logs y métricas disponibles en CloudWatch Container Insights:<br>
Ruta: <br>
/aws/eks/todo-api-cluster/cluster
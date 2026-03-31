1. Configuración de acceso a AWS
Crear un usuario IAM con permisos de administrador desde la consola de AWS.

Generar sus llaves de acceso (Access Key y Secret Key).

Configurar el perfil en tu entorno local (ejemplo en PowerShell/VSCode):

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
2. Terraform
Archivos principales:

main.tf → VPC, subnets, cluster EKS pequeño (2 nodos t3.micro), addon de CloudWatch para métricas, bucket S3 opcional.

outputs.tf → expone nombre y endpoint del cluster.

Pasos:

terraform init
terraform apply
Configurar kubectl para usar el cluster:

aws eks update-kubeconfig --region us-east-1 --name todo-api-cluster

3. Kubernetes
Manifiestos a aplicar:

deployment.yaml → despliega el contenedor insanejokajams/todo-api:latest en el cluster.

service.yaml → crea un LoadBalancer para exponer la API.

Aplicación:

kubectl apply -f deployment.yaml
kubectl apply -f service.yaml

Obtener la ruta pública del balanceador:
kubectl get svc todo-api-service

Ejemplo de acceso:

http://<loadbalancer-dns>.us-east-1.elb.amazonaws.com/docs
http://<loadbalancer-dns>.us-east-1.elb.amazonaws.com/openapi.json

4. Pruebas de la API
Usar Invoke-RestMethod en PowerShell:

Crear tarea:
Invoke-RestMethod -Uri "http://<LB-DNS>/tasks" -Method Post -ContentType "application/json" -Body '{"title":"Primera tarea","completed":false}'

Listar tareas:
Invoke-RestMethod -Uri "http://<LB-DNS>/tasks" -Method Get

Obtener tarea por ID:
Invoke-RestMethod -Uri "http://<LB-DNS>/tasks/(numero de tarea)" -Method Get

Eliminar tarea:
Invoke-RestMethod -Uri "http://<LB-DNS>/tasks/(numero de tarea)" -Method Delete

5. Observabilidad
Logs y métricas del cluster y pods disponibles directamente en CloudWatch Container Insights.
CloudWatch
Administración de registros
/aws/eks/todo-api-cluster/cluster
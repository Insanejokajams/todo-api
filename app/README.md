# Todo API - Aplicación

## Prueba local de la aplicación

Se actualizó Python y se instaló el entorno con FastAPI y Uvicorn.

### Ejecución local
uvicorn app.main:app --reload

El servidor se levantó correctamente en http://127.0.0.1:8000.

Swagger UI (/docs) y OpenAPI (/openapi.json) disponibles para probar los endpoints.

---

## Empaquetado en Docker

### Construcción de la imagen
docker build -t todo-api .
docker run -p 8000:80 todo-api

La aplicación corrió en http://127.0.0.1:8000/docs dentro del contenedor.

Se verificó que los endpoints funcionaran correctamente.

---

## Publicación en Docker Hub

La imagen se subió al repositorio público: insanejokajams/todo-api

`ash
docker build -t insanejokajams/todo-api:latest .
docker push insanejokajams/todo-api:latest
Prueba desde Docker Hub
docker pull insanejokajams/todo-api:latest
docker run -p 8000:80 insanejokajams/todo-api:latest

Confirmación: Swagger UI y endpoints accesibles en http://127.0.0.1:8000/docs.

Próximos pasos
Con la aplicación validada y empaquetada en Docker, se procede al despliegue en la infraestructura de AWS EKS.
Ver instrucciones en el README dentro de /infra.

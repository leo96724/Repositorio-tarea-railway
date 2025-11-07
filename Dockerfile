FROM python:3.12-slim

# Buenas prácticas
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1

# Directorio de trabajo dentro de la imagen
WORKDIR /app

# Copiamos SOLO el código de la API (incluye el wheel dentro de bankchurn-api/model-pkg/)
COPY ./bankchurn-api /app

# Actualizamos pip e instalamos primero TU wheel local
RUN python -m pip install --upgrade pip
RUN python -m pip install ./model-pkg/model_abandono-0.0.1-py3-none-any.whl

# Ahora instalamos el resto de requirements (sin el wheel repetido)
RUN python -m pip install -r requirements.txt

# Railway expone el puerto en $PORT; por defecto exponemos 8001
EXPOSE 8001

# Si tu app FastAPI vive en app/main.py con variable "app"
# cambia "app.main:app" si tu módulo real es otro (ver nota más abajo)
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8001"]

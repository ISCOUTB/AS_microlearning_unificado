# Dockerfile para desplegar el backend FastAPI
# Basado en python:3.11-slim

FROM python:3.11-slim

# Evitar buffers en logs
ENV PYTHONUNBUFFERED=1

WORKDIR /app

# Copiar e instalar dependencias
COPY requirements.txt /app/requirements.txt
RUN pip install --no-cache-dir -r /app/requirements.txt

# Copiar el código
COPY . /app

# Exponer puerto (Render / Railway proveerán el PORT en tiempo de ejecución)
EXPOSE 8000

# Comando por defecto: uvicorn
CMD ["uvicorn","main:app","--host","0.0.0.0","--port","8000"]

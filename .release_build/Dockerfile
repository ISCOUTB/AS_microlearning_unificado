FROM python:3.11-slim
ENV PYTHONUNBUFFERED=1
WORKDIR /app
COPY requirements.txt /app/requirements.txt

# Instalar ffmpeg (necesario para moviepy) y dependencias mínimas
RUN apt-get update \
	&& apt-get install -y --no-install-recommends ffmpeg \
	&& rm -rf /var/lib/apt/lists/*

RUN pip install --no-cache-dir -r /app/requirements.txt
COPY . /app

# Escuchar en el puerto indicado por Render a través de la variable $PORT
EXPOSE 8000
CMD ["sh","-c","uvicorn main:app --host 0.0.0.0 --port ${PORT:-8000}"]

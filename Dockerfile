# Imagen base: Python 3.10
FROM python:3.10-slim

# Establecer directorio de trabajo
WORKDIR /app

# Variables de entorno
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Instalar dependencias del sistema
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    libpq-dev \
    && rm -rf /var/lib/apt/lists/*

# Instalar dependencias de Python
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Crear directorio para fixtures
RUN mkdir -p fixtures

# Copiar código fuente
COPY . .

# Recolectar archivos estáticos
RUN mkdir -p static
ENV STATIC_ROOT=/app/static

# Exponer puerto
EXPOSE 8000

# Comando para iniciar la aplicación
CMD ["sh", "-c", "python manage.py migrate && python manage.py runserver 0.0.0.0:8000"]

# --- ЭТАП 1: Сборка фронтенда (Vite + React 18 + Three.js) ---
FROM node:20-alpine AS frontend-builder
WORKDIR /frontend

COPY frontend/package.json ./
RUN npm install --legacy-peer-deps

COPY frontend/ ./
RUN npm run build

# --- ЭТАП 2: Финальный контейнер (Python 3.11 + FastAPI) ---
FROM python:3.11-slim
WORKDIR /app

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Копируем код бэкенда
COPY app/ ./app/

# Копируем собранный фронтенд в папку static
COPY --from=frontend-builder /frontend/dist ./app/static

# Создаём директорию /data для локального кэша/фоллбэк-базы Amvera
RUN mkdir -p /data

ENV PORT=8080
ENV PYTHONUNBUFFERED=1
EXPOSE 8080

CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8080"]

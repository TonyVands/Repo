FROM n8nio/n8n
# Убедимся, что у пользователя n8n есть права на запись в папку данных
USER root
RUN mkdir -p /data && chown -R node:node /data
USER node
# Установка переменных окружения внутри контейнера
ENV N8N_USER_FOLDER=/data
ENV N8N_DATA=/data
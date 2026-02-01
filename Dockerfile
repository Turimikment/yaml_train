# --- stage: swagger editor ---
FROM swaggerapi/swagger-editor:latest AS editor

# --- stage: runtime (nginx) ---
FROM nginx:alpine

# Копируем статические доки
COPY ./docs /usr/share/nginx/html/docs

# Конфиг nginx: / -> editor, /docs -> static
COPY ./nginx.conf /etc/nginx/conf.d/default.conf

# Копируем сборку swagger-editor (статические файлы)
# В swaggerapi/swagger-editor уже есть готовая статика.
# Обычно она лежит в /usr/share/nginx/html у самого образа.
COPY --from=editor /usr/share/nginx/html /usr/share/nginx/html/editor

# Render выставляет порт через env PORT (часто 10000).
# Nginx слушает $PORT.
ENV PORT=8080

# Подставляем порт в конфиг на старте и запускаем nginx
CMD /bin/sh -c "envsubst '\$PORT' < /etc/nginx/conf.d/default.conf > /tmp/default.conf && mv /tmp/default.conf /etc/nginx/conf.d/default.conf && nginx -g 'daemon off;'"

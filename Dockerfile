# --- stage: swagger editor ---
FROM swaggerapi/swagger-editor:latest AS editor

# --- stage: runtime (nginx) ---
FROM nginx:alpine

# envsubst находится в пакете gettext
RUN apk add --no-cache gettext

# Копируем статические доки
COPY ./docs /usr/share/nginx/html/docs

# Копируем конфиг nginx (шаблон с ${PORT})
COPY ./nginx.conf /etc/nginx/templates/default.conf.template

# Копируем статические файлы Swagger Editor
COPY --from=editor /usr/share/nginx/html /usr/share/nginx/html/editor

# На случай локального запуска
ENV PORT=8080

# Генерим реальный конфиг с подставленным портом и запускаем nginx
CMD /bin/sh -c "envsubst '\${PORT}' < /etc/nginx/templates/default.conf.template > /etc/nginx/conf.d/default.conf && nginx -g 'daemon off;'"

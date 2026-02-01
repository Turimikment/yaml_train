FROM swaggerapi/swagger-editor:latest AS editor

FROM nginx:alpine

COPY ./docs /usr/share/nginx/html/docs
COPY ./nginx.conf /etc/nginx/templates/default.conf.template
COPY --from=editor /usr/share/nginx/html /usr/share/nginx/html/editor

# На локалке пусть будет 8080, на Render он обычно задаётся автоматически
ENV PORT=8080

CMD /bin/sh -c "\
  set -eu; \
  echo \"PORT=$PORT\"; \
  sed \"s/__PORT__/$PORT/g\" /etc/nginx/templates/default.conf.template > /etc/nginx/conf.d/default.conf; \
  echo '----- GENERATED NGINX CONF -----'; \
  sed -n '1,40p' /etc/nginx/conf.d/default.conf; \
  echo '--------------------------------'; \
  nginx -g 'daemon off;' \
"

FROM swaggerapi/swagger-editor:latest AS editor
FROM nginx:alpine

COPY ./docs /usr/share/nginx/html/docs
COPY ./nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=editor /usr/share/nginx/html /usr/share/nginx/html/editor

EXPOSE 8080
CMD ["nginx", "-g", "daemon off;"]

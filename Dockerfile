FROM alpine:latest

# 1. Instalar icecast + nginx (sin prompts)
RUN apk add --no-cache icecast nginx python3

# 2. Crear usuario para icecast
RUN adduser -D -H -s /bin/false radio

# 3. Directorios y permisos
RUN mkdir -p /var/log/icecast /var/log/nginx /var/run/nginx && \
    chown -R radio:radio /var/log/icecast && \
    chown -R nginx:nginx /var/log/nginx /var/run/nginx

# 4. Copiar configuraciones
COPY icecast.xml /etc/icecast.xml
COPY nginx.conf /etc/nginx/nginx.conf
COPY start.sh /start.sh

# 6. Permisos de archivos
RUN chown radio:radio /etc/icecast.xml

# 7. Exponer puertos (8080 para nginx, 10000 interno icecast)
EXPOSE 8080

# 8. Usar usuario no-root (nginx corre como nginx, icecast como radio)
USER root

# 9. Comando de inicio
CMD ["/start.sh"]


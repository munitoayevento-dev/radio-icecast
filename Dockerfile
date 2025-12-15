FROM alpine:latest

# 1. Instalar icecast
RUN apk add --no-cache icecast

# 2. Crear un usuario simple (sin grupo complejo)
RUN adduser -D -H -s /bin/false radio

# 3. Crear directorio de logs
RUN mkdir -p /var/log/icecast && \
    chown radio:radio /var/log/icecast

# 4. Copiar configuración
COPY icecast.xml /etc/icecast.xml

# 5. Cambiar propietario del archivo de configuración
RUN chown radio:radio /etc/icecast.xml

# 6. Usar el usuario radio
USER radio

EXPOSE 10000

CMD ["icecast", "-c", "/etc/icecast.xml"]


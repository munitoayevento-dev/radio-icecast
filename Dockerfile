FROM alpine:latest

# Instalar icecast (en Alpine se llama 'icecast', no 'icecast2')
RUN apk add --no-cache icecast

# Crear usuario y grupo icecast
RUN addgroup -S icecast && adduser -S icecast -G icecast

# Crear directorios necesarios
RUN mkdir -p /var/log/icecast /var/run/icecast && \
    chown -R icecast:icecast /var/log/icecast /var/run/icecast

# Copiar configuración adaptada para Alpine
COPY icecast.xml /etc/icecast.xml

# Dar permisos
RUN chown icecast:icecast /etc/icecast.xml

USER icecast

EXPOSE 8000

CMD ["icecast", "-c", "/etc/icecast.xml"]

FROM alpine:latest

# Instalar icecast
RUN apk add --no-cache icecast

# Crear directorios básicos
RUN mkdir -p /var/log/icecast

# Copiar configuración
COPY icecast.xml /etc/icecast.xml

EXPOSE 8000

# Ejecutar como root (sí, se puede en contenedor)
CMD ["icecast", "-c", "/etc/icecast.xml"]

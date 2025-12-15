FROM ubuntu:22.04

# Evitar preguntas interactivas durante la instalación
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    icecast2 \
    && rm -rf /var/lib/apt/lists/*

# Crear directorios de log y dar permisos
RUN mkdir -p /var/log/icecast2 && \
    chown -R icecast2:icecast2 /var/log/icecast2 && \
    chmod 755 /var/log/icecast2

# Copiar configuración
COPY icecast.xml /etc/icecast2/icecast.xml

# Dar permisos a la configuración
RUN chown icecast2:icecast2 /etc/icecast2/icecast.xml && \
    chmod 644 /etc/icecast2/icecast.xml

# Usar el usuario icecast2 que ya existe
USER icecast2

EXPOSE 8000

CMD ["icecast2", "-c", "/etc/icecast2/icecast.xml"]

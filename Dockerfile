FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# 1. PRIMERO instalar icecast2 (crea usuario/grupo automáticamente)
RUN apt-get update && apt-get install -y \
    icecast2 \
    && rm -rf /var/lib/apt/lists/*

# 2. LUEGO configurar directorios (ahora icecast2:icecast2 existe)
RUN mkdir -p /var/log/icecast2 && \
    chown -R icecast2:icecast2 /var/log/icecast2 && \
    chmod 755 /var/log/icecast2

# 3. Copiar configuración
COPY icecast.xml /etc/icecast2/icecast.xml
RUN chown icecast2:icecast2 /etc/icecast2/icecast.xml

# 4. Usar usuario icecast2
USER icecast2

EXPOSE 8000

CMD ["icecast2", "-c", "/etc/icecast2/icecast.xml"]

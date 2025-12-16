FROM alpine:latest

# Instalar Icecast + Python mínimo
RUN apk add --no-cache icecast python3 py3-pip

# Crear usuario para icecast
RUN adduser -D -H -s /bin/false radio

# Directorios y permisos
RUN mkdir -p /var/log/icecast && \
    chown -R radio:radio /var/log/icecast

# Instalar Flask para el proxy
RUN pip3 install flask

# Copiar archivos
COPY icecast.xml /etc/icecast.xml
COPY proxy.py /proxy.py
COPY start_simple.sh /start_simple.sh

# Permisos
RUN chown radio:radio /etc/icecast.xml && \
    chmod +x /start_simple.sh /proxy.py

EXPOSE 8080  # Proxy escucha aquí

# Comando principal
CMD ["/start_simple.sh"]

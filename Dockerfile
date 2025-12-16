FROM alpine:latest

# 1. Instalar Icecast + Python + Flask (TODO vía apk)
RUN apk add --no-cache \
    icecast \
    python3 \
    py3-flask

# 2. Crear usuario para icecast
RUN adduser -D -H -s /bin/false radio

# 3. Directorios y permisos
RUN mkdir -p /var/log/icecast && \
    chown -R radio:radio /var/log/icecast

# 4. NO usar pip3 install flask (eliminado)

# 5. Copiar archivos
COPY icecast.xml /etc/icecast.xml
COPY proxy.py /proxy.py
COPY start_simple.sh /start_simple.sh

# 6. Permisos
RUN chown radio:radio /etc/icecast.xml && \
    chmod +x /start_simple.sh /proxy.py

# 7. Puerto donde escucha el proxy
EXPOSE 8080

# 8. Comando principal
CMD ["/start_simple.sh"]

FROM alpine:latest

# Instalar solo lo necesario
RUN apk add --no-cache icecast python3 py3-flask

# Crear usuario (el paquete icecast ya crea 'icecast', lo usamos)
RUN mkdir -p /var/log/icecast && chown -R icecast:icecast /var/log/icecast

# Copiar archivos
COPY icecast.xml /etc/icecast.xml
COPY proxy.py /proxy.py

# Permisos básicos
RUN chown icecast:icecast /etc/icecast.xml

# Puerto
EXPOSE 8080

# Comando simple: iniciar proxy (que a su vez inicia icecast)
CMD ["python3", "/proxy.py"]

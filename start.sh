#!/bin/sh
set -e

echo "=== INICIANDO RADIO STACK ==="
echo "Hora: $(date)"
echo "Configuración:"
echo "  - Icecast: 127.0.0.1:10000"
echo "  - Nginx: 0.0.0.0:8080"
echo "  - Ruta Butt: /butt-in"

# Iniciar Icecast (como usuario radio)
echo "Iniciando Icecast..."
su -s /bin/sh -c "icecast -c /etc/icecast.xml" radio &
ICECAST_PID=$!

# Esperar que Icecast esté listo
echo "Esperando Icecast (5 segundos)..."
sleep 5

# Verificar que Icecast está vivo
if ! kill -0 $ICECAST_PID 2>/dev/null; then
    echo "ERROR: Icecast no se inició correctamente"
    exit 1
fi

echo "Icecast PID: $ICECAST_PID"

# Iniciar Nginx
echo "Iniciando Nginx..."
nginx -c /etc/nginx/nginx.conf
NGINX_PID=$(cat /var/run/nginx/nginx.pid 2>/dev/null || echo "?")

echo "Nginx PID: $NGINX_PID"
echo "=== SERVICIOS INICIADOS ==="
echo "Logs disponibles en:"
echo "  - Icecast: /var/log/icecast/*.log"
echo "  - Nginx: /var/log/nginx/*.log"

# Mantener el script vivo y monitorear
wait $ICECAST_PID
echo "Icecast se detuvo. Terminando..."

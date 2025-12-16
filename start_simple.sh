#!/bin/sh
echo "=== INICIANDO RADIO ==="

# Iniciar Icecast en segundo plano (como usuario radio)
echo "1. Iniciando Icecast en puerto 10000..."
su -s /bin/sh -c "icecast -c /etc/icecast.xml" radio &
ICECAST_PID=$!

# Esperar que Icecast esté listo
echo "2. Esperando Icecast (3 segundos)..."
sleep 3

# Verificar que Icecast está vivo
if ! kill -0 $ICECAST_PID 2>/dev/null; then
    echo "ERROR: Icecast no se inició"
    exit 1
fi

echo "3. Icecast iniciado (PID: $ICECAST_PID)"

# Iniciar el proxy Python
echo "4. Iniciando proxy en puerto 8080..."
python3 /proxy.py &
PROXY_PID=$!

echo "5. Proxy iniciado (PID: $PROXY_PID)"
echo "=== SISTEMA LISTO ==="
echo "Butt debe conectarse a: /butt"
echo "Oyentes: /stream"
echo "Health check: /health"

# Mantener el script vivo
wait $ICECAST_PID

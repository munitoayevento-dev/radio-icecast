#!/usr/bin/env python3
"""
Proxy mínimo que traduce SOURCE→PUT para Render
Butt se conecta aquí, y este proxy reenvía a Icecast interno.
"""
from flask import Flask, request, Response, make_response
import requests
import logging
import os

app = Flask(__name__)
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

# Configuración
ICECAST_INTERNAL = "http://127.0.0.1:10000"
MOUNT_POINT = "/stream"  # El mountpoint real de Icecast

@app.route('/butt', methods=['PUT', 'POST', 'SOURCE'])
def handle_butt():
    """Maneja conexiones de Butt"""
    try:
        # 1. Obtener datos de la petición de Butt
        auth_header = request.headers.get('Authorization', '')
        content_type = request.headers.get('Content-Type', 'audio/mpeg')
        
        # 2. URL destino (Icecast interno)
        icecast_url = f"{ICECAST_INTERNAL}{MOUNT_POINT}"
        
        # 3. Reenviar a Icecast (siempre como PUT)
        logger.info(f"Reenviando audio a Icecast interno: {icecast_url}")
        
        resp = requests.request(
            method='PUT',  # SIEMPRE usamos PUT para Icecast
            url=icecast_url,
            data=request.get_data(),
            headers={
                'Authorization': auth_header,
                'Content-Type': content_type,
                'User-Agent': 'Butt-Proxy/1.0'
            },
            stream=True,
            timeout=30
        )
        
        # 4. Devolver respuesta a Butt
        return Response(
            resp.iter_content(chunk_size=8192),
            status=resp.status_code,
            headers=dict(resp.headers)
        )
        
    except Exception as e:
        logger.error(f"Error en proxy: {str(e)}")
        return make_response(f"Proxy Error: {str(e)}", 500)

@app.route('/health')
def health_check():
    """Health check para Render"""
    return "OK", 200

if __name__ == '__main__':
    # Escuchar en todas las interfaces, puerto 8080
    app.run(host='0.0.0.0', port=8080, debug=False, threaded=True)

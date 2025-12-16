#!/usr/bin/env python3
import subprocess
import time
import os
from flask import Flask, request, Response
import requests

app = Flask(__name__)

# 1. Iniciar Icecast al comenzar
print("Iniciando Icecast...")
icecast_process = subprocess.Popen(["icecast", "-c", "/etc/icecast.xml"])
time.sleep(3)  # Esperar que Icecast inicie

# 2. Proxy simple
@app.route('/butt', methods=['PUT', 'SOURCE'])
def handle_butt():
    try:
        # Reenviar a Icecast local
        icecast_url = "http://127.0.0.1:10000/stream"
        resp = requests.request(
            method='PUT',
            url=icecast_url,
            data=request.get_data(),
            headers={
                'Authorization': request.headers.get('Authorization', ''),
                'Content-Type': request.headers.get('Content-Type', 'audio/mpeg')
            },
            stream=True
        )
        return Response(resp.iter_content(chunk_size=8192), status=resp.status_code)
    except Exception as e:
        return f"Error: {str(e)}", 500

# 3. Health check para Render
@app.route('/health')
def health():
    return "OK", 200

# 4. Ruta para oyentes (pasa directo)
@app.route('/<path:path>')
def catch_all(path):
    response = requests.get(f"http://127.0.0.1:10000/{path}")
    return Response(response.content, status=response.status_code, headers=dict(response.headers))

if __name__ == '__main__':
    print("Proxy iniciado en puerto 8080")
    print("Butt debe usar: /butt")
    print("Oyentes: /stream")
    app.run(host='0.0.0.0', port=8080)

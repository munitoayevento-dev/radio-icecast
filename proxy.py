#!/usr/bin/env python3
import subprocess
import time
from flask import Flask, request, Response
import requests
import logging

logging.basicConfig(level=logging.INFO)
app = Flask(__name__)

# INICIAR ICECAST
logging.info("Iniciando Icecast...")
icecast_process = subprocess.Popen(
    ["icecast", "-c", "/etc/icecast.xml"],
    stdout=subprocess.PIPE,
    stderr=subprocess.PIPE
)
time.sleep(5)

# Verificar si Icecast está vivo
if icecast_process.poll() is not None:
    # Icecast falló, mostrar error
    stdout, stderr = icecast_process.communicate()
    logging.error(f"Icecast falló. Error: {stderr.decode()}")
else:
    logging.info("Icecast iniciado (PID: %s)", icecast_process.pid)

# Proxy para Butt
@app.route('/butt', methods=['PUT', 'SOURCE'])
def handle_butt():
    try:
        resp = requests.request(
            method='PUT',
            url='http://127.0.0.1:10000/stream',
            data=request.get_data(),
            headers={
                'Authorization': request.headers.get('Authorization', ''),
                'Content-Type': request.headers.get('Content-Type', 'audio/mpeg'),
                'Connection': 'keep-alive',
                'Keep-Alive': 'timeout=300, max=1000'
            },
            stream=True,
            timeout=300
        )
         response = Response(resp.iter_content(chunk_size=8192), status=resp.status_code)
        response.headers['Connection'] = 'keep-alive'
        response.headers['Keep-Alive'] = 'timeout=300'
        return response
        
    except Exception as e:
        return f"Error: {str(e)}", 500

# Health check
@app.route('/health')
def health():
    return "OK", 200

# Para oyentes
@app.route('/<path:path>')
def catch_all(path):
    response = requests.get(f"http://127.0.0.1:10000/{path}")
    return Response(response.content, status=response.status_code)

if __name__ == '__main__':
    logging.info("Proxy iniciado en puerto 8080")
    app.run(host='0.0.0.0', port=8080, debug=False)

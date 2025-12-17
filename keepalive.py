import time
import requests

def send_ping():
    try:
        # Acceder al health check cada 20 segundos
        requests.get("https://radio-icecast-5dy6.onrender.com/health", timeout=5)
        print(f"Ping enviado: {time.ctime()}")
    except:
        print("Error en ping")

if __name__ == "__main__":
    while True:
        send_ping()
        time.sleep(20)

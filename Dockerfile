FROM alpine:latest
RUN apk add --no-cache icecast python3 py3-flask py3-requests
RUN mkdir -p /var/log/icecast && chown -R icecast:icecast /var/log/icecast
COPY icecast.xml /etc/icecast.xml
COPY proxy.py /proxy.py
RUN chown icecast:icecast /etc/icecast.xml
EXPOSE 8080
CMD ["python3", "/proxy.py"]


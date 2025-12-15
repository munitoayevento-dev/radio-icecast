FROM ubuntu:22.04

RUN apt-get update && apt-get install -y \
    icecast2 \
    && rm -rf /var/lib/apt/lists/*

COPY icecast.xml /etc/icecast2/icecast.xml

RUN useradd -m iceuser && \
    chown -R iceuser:iceuser /etc/icecast2

USER iceuser

EXPOSE 8000

CMD ["icecast2", "-c", "/etc/icecast2/icecast.xml"]
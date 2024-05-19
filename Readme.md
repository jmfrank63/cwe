# CWE Project

## Docker Building

Build the whole project:

```bash
docker build -t cwe:latest .
```

Build individual workspace:

```bash
docker build -f ./server/Dockerfile . -t server:latest
```

Run:

```bash
docker run -d --name server -p 8443:8443 \
  -v "$HOME"/.local/ssl/certs/cwe:/etc/ssl/private \
  -e CERT_PATH=/etc/ssl/private/server.crt \
  -e KEY_PATH=/etc/ssl/private/server.key \
  -e ADDRESS=localhost \
  -e PORT=8443 \
  server:latest
```

## Simulating Pipeline

Install and Run:

```bash
act push
```

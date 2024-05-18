# CWE Project

## Docker Building

Build the whole project:

```bash
docker build -t cwe:latest .
```

Build individual worspace:

```bash
docker build -f ./server/Dockerfile . -t server:latest
```

Run:

```bash
docker run -d --name server -p 8443:8443 \
  -v "$HOME"/.local/ssl/certs/cwe:/ssl/certs/cwe \
  -e CERT_PATH=/ssl/certs/cwe/cwe.crt \
  -e KEY_PATH=/ssl/certs/cwe/cwe.key \
  -e ADDRESS=0.0.0.0 \
  -e PORT=8443 \
  server:latest
```

## Simulating Pipeline

Install and Run:

```bash
act push
```

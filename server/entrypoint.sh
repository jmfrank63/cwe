#!/bin/bash
set -e

# Ensure the cert and key files have the correct permissions
mkdir -p /ssl/private
chmod 0750 /ssl/private
chown root:ssl-cert /ssl/private
cp /etc/ssl/private/server.key /ssl/private/server.key
chown root:ssl-cert /ssl/private/server.key
chmod 640 /ssl/private/server.key
cp /etc/ssl/private/server.crt /ssl/private/server.crt
chown root:ssl-cert /ssl/private/server.crt
chmod 644 /ssl/private/server.crt

# Start the web server with the provided arguments as the app user
exec gosu "$APP_USER" "$@"

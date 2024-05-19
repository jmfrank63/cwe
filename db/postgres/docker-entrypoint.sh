#!/bin/bash
set -e

# Add postgres user to the ssl-cert group
usermod -aG ssl-cert postgres

# Ensure the key file has the correct permissions
chown root:ssl-cert /etc/ssl/private/server.key
chmod 640 /etc/ssl/private/server.key
chown root:ssl-cert /etc/ssl/certs/server.crt
chmod 644 /etc/ssl/certs/server.crt

# Start PostgreSQL with the provided arguments
exec docker-entrypoint.sh "$@"

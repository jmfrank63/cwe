#!/bin/bash
set -e

# Ensure the key file has the correct permissions
mkdir -p /var/lib/postgresql/data
chown -R postgres:postgres /var/lib/postgresql
mkdir -p /ssl/private
chmod 0750 /ssl/private
chown root:ssl-cert /ssl/private
cp /etc/ssl/private/server.key /ssl/private/server.key
chown root:ssl-cert /ssl/private/server.key
chmod 640 /ssl/private/server.key
cp /etc/ssl/private/server.crt /ssl/private/server.crt
chown root:ssl-cert /ssl/private/server.crt
chmod 644 /ssl/private/server.crt

# Start PostgreSQL with the provided arguments
exec gosu postgres docker-entrypoint.sh "$@"

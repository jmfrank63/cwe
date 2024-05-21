#!/bin/bash
set -e

# Ensure the key file has the correct permissions
mkdir -p /ssl/private
chmod 0750 /ssl/private
chown root:ssl-cert /ssl/private
cp /etc/ssl/private/admin.pem /ssl/private/admin.pem
chown root:ssl-cert /ssl/private/admin.pem
chmod 640 /ssl/private/admin.pem

# Start haproxy with the provided arguments
exec gosu haproxy docker-entrypoint.sh "$@"

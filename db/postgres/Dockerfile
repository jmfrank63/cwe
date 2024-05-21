FROM postgres:latest

COPY ./db/postgres/entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh \
    && apt-get update \
    && apt-get install -y gosu \
    && rm -rf /var/lib/apt/lists/* \
    && usermod -aG ssl-cert postgres

ENTRYPOINT ["/entrypoint.sh"]

CMD ["postgres", "-c", "config_file=/etc/postgresql/postgresql.conf"]

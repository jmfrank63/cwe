FROM postgres:latest

COPY ./db/postgres/postgresql.conf /etc/postgresql/postgresql.conf
COPY ./db/postgres/docker-entrypoint.sh /docker-entrypoint.sh

RUN chmod +x /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["postgres", "-c", "config_file=/etc/postgresql/postgresql.conf"]

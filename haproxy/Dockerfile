FROM haproxy:latest

COPY haproxy.cfg /usr/local/etc/haproxy/haproxy.cfg

USER root
COPY ./entrypoint.sh /entrypoint.sh
RUN apt-get update \
    && apt-get install -y gosu \
    && rm -rf /var/lib/apt/lists/* \
    && groupadd ssl-cert \
    && usermod -aG ssl-cert haproxy \
    && chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

CMD ["haproxy", "-f", "/usr/local/etc/haproxy/haproxy.cfg"]

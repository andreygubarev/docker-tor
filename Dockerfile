# syntax=docker/dockerfile:1
FROM debian:bullseye-slim

RUN apt-get update &&  \
    apt-get install -yq --no-install-recommends \
        ca-certificates \
        curl \
        tor && \
    rm -rf /var/lib/apt/lists/*

COPY src/healthcheck.sh /healthcheck.sh
COPY src/docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod a+x /healthcheck.sh /docker-entrypoint.sh

USER debian-tor
COPY --chown=debian-tor src/conf/torrc /etc/tor/torrc

ENV TOR_SERVICE=
ENV TOR_BRIDGE=

HEALTHCHECK --interval=60s --timeout=30s --start-period=30s \
            CMD ["sh", "/healthcheck.sh"]
ENTRYPOINT ["/docker-entrypoint.sh"]

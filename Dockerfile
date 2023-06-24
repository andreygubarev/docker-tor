# syntax=docker/dockerfile:1
FROM debian:bullseye-slim

RUN apt-get update &&  \
    apt-get install -yq --no-install-recommends \
        ca-certificates \
        curl \
        netcat \
        obfs4proxy \
        socat \
        tini \
        tor \
        xxd && \
    rm -rf /var/lib/apt/lists/*

COPY src/healthcheck.sh /healthcheck.sh
COPY src/docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod a+x /healthcheck.sh /docker-entrypoint.sh

USER debian-tor
COPY --chown=debian-tor src/conf/torrc /etc/tor/torrc

ENV SOCAT_BIND_TYPE=
ENV SOCAT_BIND_IFACE=
ENV SOCAT_BIND_OPTS=
ENV SOCAT_CONNECT_TYPE=
ENV SOCAT_CONNECT_IFACE=
ENV SOCAT_CONNECT_OPTS=
ENV SOCAT_PORTFORWARD=

ENV TOR_SERVICE=
ENV TOR_BRIDGE=

EXPOSE 9050
EXPOSE 9051

HEALTHCHECK --interval=60s --timeout=45s --start-period=30s \
            CMD ["sh", "/healthcheck.sh"]
ENTRYPOINT ["tini", "--", "/docker-entrypoint.sh"]

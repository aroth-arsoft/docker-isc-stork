FROM ubuntu:focal
MAINTAINER Andreas Roth "aroth@arsoft-online.com"
ARG BUILD_DATE
ARG VCS_REF
LABEL org.label-schema.build-date=$BUILD_DATE \
    org.label-schema.license=GPL-3.0 \
    org.label-schema.name=stork \
    org.label-schema.vcs-ref=$VCS_REF \
    org.label-schema.vcs-url=https://github.com/aroth-arsoft/docker-stork

ADD isc-stork.gpg /etc/apt/trusted.gpg.d/
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends --no-install-suggests -y curl python3 python3-pip && \
    echo "deb [arch=amd64,trusted=yes] https://dl.cloudsmith.io/public/isc/stork/deb/ubuntu focal main" >> /etc/apt/sources.list.d/isc-stork.list && \
    apt-get update && \
    apt-get install --no-install-recommends --no-install-suggests -y isc-stork-server && \
    apt-get clean && \
    rm -rf /usr/share/doc/* /usr/share/man/* /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENV STORK_DATABASE_HOST= \
    STORK_DATABASE_PORT= \
    STORK_DATABASE_NAME= \
    STORK_DATABASE_USER_NAME= \
    STORK_DATABASE_SSLMODE= \
    STORK_DATABASE_PASSWORD= \
    STORK_REST_STATIC_FILES_DIR=/usr/share/stork/www \
    STORK_SERVER_ENABLE_METRICS=true

EXPOSE 8080

ENTRYPOINT ["/usr/bin/stork-server"]

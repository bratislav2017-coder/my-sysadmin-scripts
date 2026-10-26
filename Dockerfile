FROM ubuntu:22.04

RUN apt-get update \
    && apt-get install -y --no-install-recommends bash coreutils procps python3 ca-certificates \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /var/www

COPY script.sh /usr/local/bin/script.sh
COPY entrypoint.sh /usr/local/bin/entrypoint.sh

RUN chmod 0755 /usr/local/bin/script.sh /usr/local/bin/entrypoint.sh

ENV LOG_FILE=/var/www/monitor.log

USER 1000:1000

EXPOSE 8080

CMD ["/usr/local/bin/entrypoint.sh"]

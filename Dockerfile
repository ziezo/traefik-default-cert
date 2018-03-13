FROM docker:dind

COPY ["run.sh", "cron.sh", "on-change.sh", "acme-cert-dump-all.py", "acme-cert-dump.py", "/"]

RUN apk add --update \
    bash \
    python \
  && rm -rf /var/cache/apk/* \
  && mkdir /cert

ENV CRON_TIME="0 1 * * *"

CMD ["/run.sh"]


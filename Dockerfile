FROM golang:1.12.7-alpine3.10 as base

RUN apk add --no-cache git \
    && go get -u github.com/jstemmer/go-junit-report \
    && apk del git

FROM busybox:1.31.0-glibc as tester

ENV SCRIPTS=/scripts
ENV UNIT_BINARIES=/test/bin/unit INTEGRATION_BIN=/test/bin/integration COVERAGE=/test/coverage/unit/coverage.txt REPORTS=/test/reports/ PATH="${SCRIPTS}:${PATH}"
RUN mkdir -p $SCRIPTS

COPY --from=base /etc/ssl/certs /etc/ssl/certs
COPY --from=base /go/bin/go-junit-report $SCRIPTS/

COPY ./unit.sh /scripts/unit
RUN chmod +x /scripts/unit;

COPY ./integration.sh /scripts/integration
RUN chmod +x /scripts/integration;

COPY ./start.sh /scripts/start
RUN chmod +x /scripts/start;

CMD ["start"]
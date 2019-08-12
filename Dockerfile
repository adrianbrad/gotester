FROM golang:1.12.7-alpine3.10 as base

RUN apk add --no-cache git \
    && go get -u github.com/jstemmer/go-junit-report \
    && apk del git

FROM busybox:1.31.0-glibc as tester

ENV SCRIPTS=/scripts
ENV UNIT_BINARIES=/test/bin/unit INTEGRATION_BIN=/test/bin/integration COVERAGE=/test/coverage/unit/coverage.txt REPORTS=/test/reports/ PATH="${SCRIPTS}:${PATH}"
RUN mkdir -p $SCRIPTS $UNIT_BINARIES $INTEGRATION_BIN $(dirname $COVERAGE) $REPORTS

COPY --from=base /etc/ssl/certs /etc/ssl/certs
COPY --from=base /go/bin/go-junit-report $SCRIPTS/

### UNIT TESTS SCRIPT
RUN printf '%s\n' \
'#!/bin/sh' \
"for d in $UNIT_BINARIES/*; do" \
    '$d -test.v -test.coverprofile=profile.out 2>&1 | tee /dev/tty  | go-junit-report -set-exit-code=1 > '"$REPORTS"'$(basename $d).xml' \
    '[ $? -eq 1 ] && exit 1 || true' \
        'if [ -f profile.out ]; then' \
        "cat profile.out >> $COVERAGE" \
            'rm profile.out' \
        'fi' \
'done' \
> /scripts/unit; chmod +x /scripts/unit;

RUN printf '%s\n' \
'#!/bin/sh' \
"for d in $INTEGRATION_BIN/*; do" \
    '$d -test.v 2>&1 | tee /dev/tty | go-junit-report -set-exit-code=1 > '"$REPORTS"'$(basename $d).xml;' \
    '[ $? -eq 1 ] && exit 1 || true' \
'done' \
> /scripts/integration; chmod +x /scripts/integration;
#!/bin/sh
for d in /test/bin/integration/*; do
    $d -test.v 2>&1 | tee /dev/tty | go-junit-report -set-exit-code=1 > /test/reports/$(basename $d).xml;
    [ $? -eq 1 ] && exit 1 || true
done
#!/bin/sh
for d in /test/bin/unit/*; do
    $d -test.v -test.coverprofile=profile.out 2>&1 | tee /dev/tty  | go-junit-report -set-exit-code=1 > /test/reports/$(basename $d).xml
    [ $? -eq 1 ] && exit 1 || true
    if [ -f profile.out ]; then
        cat profile.out >> /test/coverage/unit/coverage.txt
        rm profile.out
    fi
done
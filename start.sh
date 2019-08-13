#!/bin/sh
mkdir -p $(dirname $COVERAGE) $REPORTS
unit
integration
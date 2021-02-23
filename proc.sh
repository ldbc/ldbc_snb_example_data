#!/bin/bash

set -e
set -o pipefail

PATHVAR=${1:-"`pwd`/data/raw/"}

if [ "$2" = "--no-header" ]; then
    HEADER=
else
    HEADER=", HEADER"
fi

POSTFIX=_0_0.csv

rm -rf ldbc.duckdb
echo initialize schema
cat schema/raw.sql | ./duckdb ldbc.duckdb
cat schema/composite-merged-fk.sql | ./duckdb ldbc.duckdb
echo load data
cat snb-load.sql | \
  sed "s|\${PATHVAR}|${PATHVAR}|g" | \
  sed "s|\${POSTFIX}|${POSTFIX}|g" | \
  sed "s|\${HEADER}|${HEADER}|g" | \
  ./duckdb ldbc.duckdb
echo transform data
cat snb-transform.sql | sed "s|:bulkLoadTime|DATE '2013-01-01T00:00:00.000+00:00'|g" | ./duckdb ldbc.duckdb

#!/bin/bash

set -e
set -o pipefail

PATHVAR=${1:-"`pwd`/data/raw/"}

if [ "$2" = "--no-header" ]; then
    HEADER=
else
    HEADER=", HEADER"
fi

./get.sh

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

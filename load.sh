#!/bin/bash

set -eu
set -o pipefail

# Usage: ./load.sh <PATHVAR> [--no-header]

PATHVAR=${1:-"`pwd`/data/raw/"}

if [ "${2-}" = "--no-header" ]; then
    HEADER=
else
    HEADER=", HEADER"
fi

DUCKDB_PATH="${DUCKDB_PATH:=.}"
./get.sh

DYNAMIC_PREFIX="dynamic/"
POSTFIX=".csv"

rm -rf ldbc.duckdb
echo initialize schema
cat schema/raw.sql | ${DUCKDB_PATH}/duckdb ldbc.duckdb
cat schema/composite-merged-fk.sql | ${DUCKDB_PATH}/duckdb ldbc.duckdb
echo load data
cat sql/snb-load-raw.sql | \
    sed "s|\${PATHVAR}|${PATHVAR}|g" | \
    sed "s|\${DYNAMIC_PREFIX}|${DYNAMIC_PREFIX}|g" | \
    sed "s|\${POSTFIX}|${POSTFIX}|g" | \
    sed "s|\${HEADER}|${HEADER}|g" | \
    ${DUCKDB_PATH}/duckdb ldbc.duckdb

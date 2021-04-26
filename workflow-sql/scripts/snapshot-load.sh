#!/bin/bash

set -eu
set -o pipefail

cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )/.."

# loads the updates in the `batches` directory
# these files always have headers
PATHVAR="../data/csv-composite-merged-fk"
HEADER=", HEADER"
POSTFIX=".csv"
DYNAMIC_PREFIX="dynamic/"
DUCKDB_PATH="${DUCKDB_PATH:=..}"

rm -f ldbc.duckdb
cat ../schema/composite-merged-fk.sql | ${DUCKDB_PATH}/duckdb ldbc.duckdb
cat sql/deletes.sql | ${DUCKDB_PATH}/duckdb ldbc.duckdb

echo "Load initial snapshot"

# initial snapshot
echo "-> Static entities"
cat sql/snb-load-composite-merged-fk-static.sql | \
    sed "s|\${PATHVAR}|${PATHVAR}|g" | \
    sed "s|\${POSTFIX}|${POSTFIX}|g" | \
    sed "s|\${HEADER}|${HEADER}|g" | \
    ${DUCKDB_PATH}/duckdb ldbc.duckdb

echo "-> Dynamic entities"
cat sql/snb-load-composite-merged-fk-dynamic.sql | \
    sed "s|\${PATHVAR}|${PATHVAR}|g" | \
    sed "s|\${DYNAMIC_PREFIX}|${DYNAMIC_PREFIX}|g" | \
    sed "s|\${POSTFIX}|${POSTFIX}|g" | \
    sed "s|\${HEADER}|${HEADER}|g" | \
    ${DUCKDB_PATH}/duckdb ldbc.duckdb

echo "Loaded initial snapshot"

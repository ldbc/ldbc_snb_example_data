#!/bin/bash

set -eu
set -o pipefail

# loads the updates in the `batches` directory
# these files always have headers
PATHVAR="data/csv-composite-merged-fk"
HEADER=", HEADER"
POSTFIX=".csv"
DYNAMIC_PREFIX="dynamic/"

rm -f ldbc.duckdb
cat schema/composite-merged-fk.sql | ./duckdb ldbc.duckdb
cat schema/deletes.sql | ./duckdb ldbc.duckdb

# initial snapshot
cat sql/snb-load-composite-merged-fk-static.sql | \
    sed "s|\${PATHVAR}|${PATHVAR}|g" | \
    sed "s|\${POSTFIX}|${POSTFIX}|g" | \
    sed "s|\${HEADER}|${HEADER}|g" | \
    ./duckdb ldbc.duckdb

cat sql/snb-load-composite-merged-fk-dynamic.sql | \
    sed "s|\${PATHVAR}|${PATHVAR}|g" | \
    sed "s|\${DYNAMIC_PREFIX}|${DYNAMIC_PREFIX}|g" | \
    sed "s|\${POSTFIX}|${POSTFIX}|g" | \
    sed "s|\${HEADER}|${HEADER}|g" | \
    ./duckdb ldbc.duckdb

# insert batches iteratively
for BATCH in batches/*; do
    echo "Batch in directory '${BATCH}'"
    echo "-> Inserts"
    cat sql/snb-load-composite-merged-fk-dynamic.sql | \
        sed "s|\${PATHVAR}|${BATCH}/inserts|g" | \
        sed "s|\${DYNAMIC_PREFIX}||g" | \
        sed "s|\${POSTFIX}|${POSTFIX}|g" | \
        sed "s|\${HEADER}|${HEADER}|g" | \
        ./duckdb ldbc.duckdb
    echo "-> Deletes"
    cat sql/snb-deletes.sql | \
        sed "s|\${PATHVAR}|${BATCH}/deletes|g" | \
        sed "s|\${HEADER}|${HEADER}|g" | \
        ./duckdb ldbc.duckdb

done

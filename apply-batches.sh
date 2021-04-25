#!/bin/bash

set -eu
set -o pipefail

# loads the updates in the `batches` directory
# these files always have headers
PATHVAR="data/csv-composite-merged-fk"
HEADER=", HEADER"
POSTFIX=".csv"
DYNAMIC_PREFIX="dynamic/"
DUCKDB_PATH="${DUCKDB_PATH:=.}"

# apply batches iteratively
for BATCH in batches/*; do
    echo "Batch in directory '${BATCH}'"

    echo "-> Deletes"
    cat sql/snb-deletes.sql | \
        sed "s|\${PATHVAR}|${BATCH}/deletes|g" | \
        sed "s|\${HEADER}|${HEADER}|g" | \
        ${DUCKDB_PATH}/duckdb ldbc.duckdb

    echo "-> Inserts"
    cat sql/snb-load-composite-merged-fk-dynamic.sql | \
        sed "s|\${PATHVAR}|${BATCH}/inserts|g" | \
        sed "s|\${DYNAMIC_PREFIX}||g" | \
        sed "s|\${POSTFIX}|${POSTFIX}|g" | \
        sed "s|\${HEADER}|${HEADER}|g" | \
        ${DUCKDB_PATH}/duckdb ldbc.duckdb

    #echo "select * from forum_hasMember_person;" | ${DUCKDB_PATH}/duckdb ldbc.duckdb
    #echo "select * from person_likes_post;" | ${DUCKDB_PATH}/duckdb ldbc.duckdb
    #echo "select * from person_likes_comment;" | ${DUCKDB_PATH}/duckdb ldbc.duckdb

done

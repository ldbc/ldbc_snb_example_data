#!/bin/bash

set -eu
set -o pipefail

DUCKDB_PATH="${DUCKDB_PATH:=.}"

echo "create factor tables"
cat sql/factor-tables.sql | ${DUCKDB_PATH}/duckdb ldbc.duckdb
echo "generate parameters"
cat sql/select-bi-params.sql | ${DUCKDB_PATH}/duckdb ldbc.duckdb

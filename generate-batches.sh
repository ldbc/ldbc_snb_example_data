#!/bin/bash

set -eu
set -o pipefail

DUCKDB_PATH="${DUCKDB_PATH:=.}"

cat export/snb-export-composite-merged-fk.sql    | ${DUCKDB_PATH}/duckdb ldbc.duckdb

cat export/snb-export-composite-projected-fk.sql | ${DUCKDB_PATH}/duckdb ldbc.duckdb


cat workflow-sql/sql/initialize-delete-candidate-tables.sql | ${DUCKDB_PATH}/duckdb ldbc.duckdb
python3 batches.py

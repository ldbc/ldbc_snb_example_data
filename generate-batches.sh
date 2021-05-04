#!/bin/bash

set -eu
set -o pipefail

DUCKDB_PATH="${DUCKDB_PATH:=.}"

cat workflow-sql/sql/initialize-delete-candidate-tables.sql | ${DUCKDB_PATH}/duckdb ldbc.duckdb
python3 batches.py

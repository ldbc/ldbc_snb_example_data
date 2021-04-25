#!/bin/bash

set -eu
set -o pipefail

DUCKDB_PATH="${DUCKDB_PATH:=.}"

cat schema/deletes.sql | ${DUCKDB_PATH}/duckdb ldbc.duckdb
python3 batches.py

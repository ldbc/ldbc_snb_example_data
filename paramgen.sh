#!/bin/bash

set -eu
set -o pipefail

DUCKDB_PATH="${DUCKDB_PATH:=.}"

cat sql/select-bi-params.sql | ${DUCKDB_PATH}/duckdb ldbc.duckdb

#!/bin/bash

set -e
set -o pipefail
echo "create factor tables"
cat factor-tables.sql | ./duckdb ldbc.duckdb

cat select-bi-params.sql | ./duckdb ldbc.duckdb

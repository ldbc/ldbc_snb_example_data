#!/bin/bash

set -e
set -o pipefail
echo "create factor tables"
cat factor-views.sql | ./duckdb ldbc.duckdb

cat select-bi-params.sql | ./duckdb ldbc.duckdb

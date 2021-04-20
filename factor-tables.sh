#!/bin/bash

set -e
set -o pipefail
echo "create factor tables"
cat sql/factor-tables.sql | ./duckdb ldbc.duckdb
echo "generate parameters"
cat sql/select-bi-params.sql | ./duckdb ldbc.duckdb

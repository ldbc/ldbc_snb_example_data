#!/bin/bash

set -eu
set -o pipefail

DUCKDB_PATH="${DUCKDB_PATH:=.}"

echo "export data"
for export_script in export/*.sql; do
    echo ${export_script}
    cat ${export_script} | ${DUCKDB_PATH}/duckdb ldbc.duckdb
done

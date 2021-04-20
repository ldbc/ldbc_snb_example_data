#!/bin/bash

set -eu
set -o pipefail

echo "export data"
for export_script in export/*.sql; do
    echo ${export_script}
    cat ${export_script} | ./duckdb ldbc.duckdb
done

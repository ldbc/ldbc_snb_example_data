#!/bin/bash

set -e
set -o pipefail

echo export data
for export_script in snb-export-*.sql; do
  echo ${export_script}
  cat ${export_script} | ./duckdb ldbc.duckdb
done

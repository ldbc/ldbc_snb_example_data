#!/bin/bash

set -eu
set -o pipefail

DUCKDB_PATH="${DUCKDB_PATH:=.}"
BULK_LOAD_DATE="2011-01-01"

echo "transform data from raw to composite-merged-fk format"

cat sql/snb-transform.sql | \
    sed "s|:bulkLoadTime|DATE '${BULK_LOAD_DATE}T00:00:00.000+00:00'|g" |
    ${DUCKDB_PATH}/duckdb ldbc.duckdb

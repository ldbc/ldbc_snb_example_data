#!/bin/bash

set -e
set -o pipefail

echo "transform data from raw to composite-merged-fk format"
cat sql/snb-transform.sql | \
    sed "s|:bulkLoadTime|DATE '2011-01-01T00:00:00.000+00:00'|g" |
    ./duckdb ldbc.duckdb

cat export/snb-export-singular-merged-fk.sql | \
    ./duckdb ldbc.duckdb

#!/bin/bash

set -e
set -o pipefail

echo transform data
cat snb-transform.sql | sed "s|:bulkLoadTime|DATE '2013-01-01T00:00:00.000+00:00'|g" | ./duckdb ldbc.duckdb

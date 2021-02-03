#!/bin/bash

set -e
set -o pipefail

export PATHVAR=`pwd`/data/raw
export POSTFIX=_0_0.csv

rm -rf ldbc.duckdb
cat schema/raw.sql | ./duckdb ldbc.duckdb
cat schema/composite-merged-fk.sql | ./duckdb ldbc.duckdb
cat snb-load.sql | sed "s|\${PATHVAR}|${PATHVAR}|g" | sed "s|\${POSTFIX}|${POSTFIX}|g" | ./duckdb ldbc.duckdb
cat snb-transform.sql | sed "s|:bulkLoadTime|'2014-01-01T00:00:00.000+00:00'|g" | ./duckdb ldbc.duckdb
cat snb-export.sql | ./duckdb ldbc.duckdb

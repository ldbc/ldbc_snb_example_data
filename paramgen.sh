#!/bin/bash

set -e
set -o pipefail

cat sql/select-bi-params.sql | ./duckdb ldbc.duckdb

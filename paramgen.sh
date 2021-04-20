#!/bin/bash

set -eu
set -o pipefail

cat sql/select-bi-params.sql | ./duckdb ldbc.duckdb

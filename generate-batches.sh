#!/bin/bash

set -eu
set -o pipefail

cat schema/deletes.sql | ./duckdb ldbc.duckdb
python3 batches.py

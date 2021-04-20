#!/bin/bash

set -e
set -o pipefail

cat schema/deletes.sql | ./duckdb ldbc.duckdb
python3 batches.py
